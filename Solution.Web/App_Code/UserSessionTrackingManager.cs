using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Dapper;

public static class UserSessionTrackingManager
{
    private const string TrackingIdSessionKey = "__UserSessionTrackingId";
    private const string LastActivityUpdateSessionKey = "__UserSessionTrackingLastActivity";
    private static readonly TimeSpan ActivityUpdateInterval = TimeSpan.FromMinutes(1);

    public static void StartTracking(HttpContext context)
    {
        if (context == null || context.Session == null || context.Request == null)
        {
            return;
        }

        int userId;
        if (!TryGetCurrentUserId(context.Session, out userId))
        {
            return;
        }

        DateTime now = DateTime.Now;
        string sessionId = context.Session.SessionID;
        string userAgent = context.Request.UserAgent ?? string.Empty;
        string ipAddress = GetClientIpAddress(context.Request);
        LocationInfo location = ResolveLocation(ipAddress);

        try
        {
            CloseExistingActiveSession(sessionId, now);

            int trackingId = InsertTrackingRecord(new TrackingRecord
            {
                UserId = userId,
                LoginDateTime = now,
                IPAddress = ipAddress,
                Country = location.Country,
                RegionState = location.RegionState,
                City = location.City,
                BrowserName = ResolveBrowserName(context.Request, userAgent),
                OSName = ResolveOperatingSystem(context.Request, userAgent),
                DeviceType = ResolveDeviceType(context.Request, userAgent),
                SessionId = sessionId,
                LastActivityTime = now,
                IsActiveSession = true
            });

            context.Session[TrackingIdSessionKey] = trackingId;
            context.Session[LastActivityUpdateSessionKey] = now;
        }
        catch
        {
            // Audit logging should not break the login flow.
        }
    }

    public static void TouchCurrentSession(HttpContext context)
    {
        if (context == null || context.Session == null || context.Request == null)
        {
            return;
        }

        if (!ShouldTrackRequest(context.Request))
        {
            return;
        }

        int trackingId = GetTrackingId(context.Session);
        if (trackingId <= 0)
        {
            return;
        }

        DateTime now = DateTime.Now;
        DateTime lastActivityUpdate = GetLastActivityUpdate(context.Session);
        if ((now - lastActivityUpdate) < ActivityUpdateInterval)
        {
            return;
        }

        try
        {
            UpdateLastActivity(trackingId, now);
            context.Session[LastActivityUpdateSessionKey] = now;
        }
        catch
        {
            // Activity tracking is best effort only.
        }
    }

    public static void MarkCurrentSessionLoggedOut(HttpSessionState session)
    {
        if (session == null)
        {
            return;
        }

        int trackingId = GetTrackingId(session);
        if (trackingId <= 0)
        {
            return;
        }

        DateTime now = DateTime.Now;

        try
        {
            CloseTrackingRecord(trackingId, now);
        }
        catch
        {
            // Logout should continue even if audit update fails.
        }
        finally
        {
            session.Remove(TrackingIdSessionKey);
            session.Remove(LastActivityUpdateSessionKey);
        }
    }

    private static bool ShouldTrackRequest(HttpRequest request)
    {
        string extension = VirtualPathUtility.GetExtension(request.Path);
        if (!".aspx".Equals(extension, StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        string pageName = VirtualPathUtility.GetFileName(request.Path);
        return !"Login.aspx".Equals(pageName, StringComparison.OrdinalIgnoreCase);
    }

    private static bool TryGetCurrentUserId(HttpSessionState session, out int userId)
    {
        userId = 0;
        if (session == null || session["UserId"] == null)
        {
            return false;
        }

        return int.TryParse(session["UserId"].ToString(), out userId);
    }

    private static int GetTrackingId(HttpSessionState session)
    {
        if (session == null || session[TrackingIdSessionKey] == null)
        {
            return 0;
        }

        int trackingId;
        return int.TryParse(session[TrackingIdSessionKey].ToString(), out trackingId) ? trackingId : 0;
    }

    private static DateTime GetLastActivityUpdate(HttpSessionState session)
    {
        if (session == null || session[LastActivityUpdateSessionKey] == null)
        {
            return DateTime.MinValue;
        }

        object value = session[LastActivityUpdateSessionKey];
        return value is DateTime ? (DateTime)value : DateTime.MinValue;
    }

    private static int InsertTrackingRecord(TrackingRecord record)
    {
        const string sql = @"
INSERT INTO dbo.tblUserSessionTracking
(
    UserId,
    LoginDateTime,
    LogoutDateTime,
    IPAddress,
    Country,
    RegionState,
    City,
    BrowserName,
    OSName,
    DeviceType,
    SessionId,
    LastActivityTime,
    IsActiveSession
)
VALUES
(
    @UserId,
    @LoginDateTime,
    NULL,
    @IPAddress,
    @Country,
    @RegionState,
    @City,
    @BrowserName,
    @OSName,
    @DeviceType,
    @SessionId,
    @LastActivityTime,
    @IsActiveSession
);
SELECT CAST(SCOPE_IDENTITY() AS INT);";

        using (SqlConnection connection = new SqlConnection(GetConnectionString()))
        {
            object result = connection.ExecuteScalar(sql, new
            {
                UserId = record.UserId,
                LoginDateTime = record.LoginDateTime,
                IPAddress = NullableString(record.IPAddress),
                Country = NullableString(record.Country),
                RegionState = NullableString(record.RegionState),
                City = NullableString(record.City),
                BrowserName = NullableString(record.BrowserName),
                OSName = NullableString(record.OSName),
                DeviceType = NullableString(record.DeviceType),
                SessionId = NullableString(record.SessionId),
                LastActivityTime = record.LastActivityTime,
                IsActiveSession = record.IsActiveSession
            });
            return result == null ? 0 : Convert.ToInt32(result);
        }
    }

    private static object NullableString(string value)
    {
        return string.IsNullOrWhiteSpace(value) ? (object)DBNull.Value : value.Trim();
    }

    private static void UpdateLastActivity(int trackingId, DateTime lastActivityTime)
    {
        const string sql = @"
UPDATE dbo.tblUserSessionTracking
SET LastActivityTime = @LastActivityTime
WHERE TrackingId = @TrackingId
  AND IsActiveSession = 1;";

        using (SqlConnection connection = new SqlConnection(GetConnectionString()))
        {
            connection.Execute(sql, new { TrackingId = trackingId, LastActivityTime = lastActivityTime });
        }
    }

    private static void CloseTrackingRecord(int trackingId, DateTime logoutDateTime)
    {
        const string sql = @"
UPDATE dbo.tblUserSessionTracking
SET LogoutDateTime = CASE WHEN LogoutDateTime IS NULL THEN @LogoutDateTime ELSE LogoutDateTime END,
    LastActivityTime = @LogoutDateTime,
    IsActiveSession = 0
WHERE TrackingId = @TrackingId
  AND IsActiveSession = 1;";

        using (SqlConnection connection = new SqlConnection(GetConnectionString()))
        {
            connection.Execute(sql, new { TrackingId = trackingId, LogoutDateTime = logoutDateTime });
        }
    }

    private static void CloseExistingActiveSession(string sessionId, DateTime logoutDateTime)
    {
        const string sql = @"
UPDATE dbo.tblUserSessionTracking
SET LogoutDateTime = CASE WHEN LogoutDateTime IS NULL THEN @LogoutDateTime ELSE LogoutDateTime END,
    LastActivityTime = @LogoutDateTime,
    IsActiveSession = 0
WHERE SessionId = @SessionId
  AND IsActiveSession = 1;";

        using (SqlConnection connection = new SqlConnection(GetConnectionString()))
        {
            connection.Execute(sql, new { SessionId = NullableString(sessionId), LogoutDateTime = logoutDateTime });
        }
    }

    private static string GetConnectionString()
    {
        ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["SolutionConnectionStringSSIDB"];
        if (settings == null || string.IsNullOrWhiteSpace(settings.ConnectionString))
        {
            throw new InvalidOperationException("SolutionConnectionStringSSIDB was not found.");
        }

        return settings.ConnectionString;
    }

    private static string GetClientIpAddress(HttpRequest request)
    {
        if (request == null)
        {
            return string.Empty;
        }

        string[] rawValues = new string[]
        {
            GetRequestValue(request, "HTTP_X_FORWARDED_FOR"),
            GetRequestValue(request, "X-Forwarded-For"),
            GetRequestValue(request, "HTTP_X_REAL_IP"),
            GetRequestValue(request, "X-Real-IP"),
            GetRequestValue(request, "HTTP_CF_CONNECTING_IP"),
            GetRequestValue(request, "CF-Connecting-IP"),
            GetRequestValue(request, "HTTP_CLIENT_IP"),
            GetRequestValue(request, "Client-IP"),
            GetRequestValue(request, "REMOTE_ADDR"),
            request.UserHostAddress
        };

        string fallbackIpAddress = string.Empty;
        for (int i = 0; i < rawValues.Length; i++)
        {
            string candidate;
            if (!TryGetClientIpFromValue(rawValues[i], out candidate))
            {
                continue;
            }

            if (!IsPrivateOrLocalIpAddress(candidate))
            {
                return candidate;
            }

            if (string.IsNullOrWhiteSpace(fallbackIpAddress))
            {
                fallbackIpAddress = candidate;
            }
        }

        return fallbackIpAddress;
    }

    private static bool TryGetClientIpFromValue(string rawValue, out string ipAddress)
    {
        ipAddress = string.Empty;
        if (string.IsNullOrWhiteSpace(rawValue))
        {
            return false;
        }

        string[] candidates = rawValue.Split(',');
        string fallbackIpAddress = string.Empty;

        for (int i = 0; i < candidates.Length; i++)
        {
            string candidate = NormalizeIpAddress(candidates[i]);
            if (string.IsNullOrWhiteSpace(candidate))
            {
                continue;
            }

            IPAddress parsedAddress;
            if (!IPAddress.TryParse(candidate, out parsedAddress))
            {
                continue;
            }

            if (!IsPrivateOrLocalIpAddress(candidate))
            {
                ipAddress = candidate;
                return true;
            }

            if (string.IsNullOrWhiteSpace(fallbackIpAddress))
            {
                fallbackIpAddress = candidate;
            }
        }

        if (!string.IsNullOrWhiteSpace(fallbackIpAddress))
        {
            ipAddress = fallbackIpAddress;
            return true;
        }

        return false;
    }

    private static string NormalizeIpAddress(string ipAddress)
    {
        if (string.IsNullOrWhiteSpace(ipAddress))
        {
            return string.Empty;
        }

        string trimmed = ipAddress.Trim();
        IPAddress parsedAddress;
        if (!IPAddress.TryParse(trimmed, out parsedAddress))
        {
            return trimmed;
        }

        string mappedIpv4Address;
        if (TryGetIpv4MappedAddress(parsedAddress, out mappedIpv4Address))
        {
            return mappedIpv4Address;
        }

        if (IPAddress.IsLoopback(parsedAddress))
        {
            return "127.0.0.1";
        }

        return parsedAddress.ToString();
    }

    private static bool TryGetIpv4MappedAddress(IPAddress address, out string ipv4Address)
    {
        ipv4Address = string.Empty;
        if (address == null || address.AddressFamily != System.Net.Sockets.AddressFamily.InterNetworkV6)
        {
            return false;
        }

        byte[] bytes = address.GetAddressBytes();
        if (bytes == null || bytes.Length != 16)
        {
            return false;
        }

        for (int i = 0; i < 10; i++)
        {
            if (bytes[i] != 0)
            {
                return false;
            }
        }

        if (bytes[10] != 0xff || bytes[11] != 0xff)
        {
            return false;
        }

        ipv4Address = string.Format("{0}.{1}.{2}.{3}", bytes[12], bytes[13], bytes[14], bytes[15]);
        return true;
    }

    private static string GetRequestValue(HttpRequest request, string key)
    {
        if (request == null || string.IsNullOrWhiteSpace(key))
        {
            return string.Empty;
        }

        string value = request.ServerVariables[key];
        if (string.IsNullOrWhiteSpace(value))
        {
            value = request.Headers[key];
        }

        return string.IsNullOrWhiteSpace(value) ? string.Empty : value.Trim();
    }

    private static LocationInfo ResolveLocation(string ipAddress)
    {
        LocationInfo location = new LocationInfo();
        if (string.IsNullOrWhiteSpace(ipAddress))
        {
            return location;
        }

        if (IsPrivateOrLocalIpAddress(ipAddress))
        {
            return CreateLocalLocationInfo(ipAddress);
        }

        try
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | (SecurityProtocolType)3072;
            string url = "https://ipapi.co/" + HttpUtility.UrlEncode(ipAddress) + "/json/";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.Timeout = 3000;
            request.ReadWriteTimeout = 3000;
            request.UserAgent = "SMC-Session-Tracker";

            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            using (Stream stream = response.GetResponseStream())
            {
                if (stream == null)
                {
                    return location;
                }

                using (StreamReader reader = new StreamReader(stream))
                {
                    string json = reader.ReadToEnd();
                    if (string.IsNullOrWhiteSpace(json))
                    {
                        return location;
                    }

                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    Dictionary<string, object> result = serializer.Deserialize<Dictionary<string, object>>(json);
                    if (result == null)
                    {
                        return location;
                    }

                    location.Country = GetDictionaryValue(result, "country_name");
                    location.RegionState = GetDictionaryValue(result, "region");
                    location.City = GetDictionaryValue(result, "city");
                }
            }
        }
        catch
        {
            // Ignore location lookup failures and keep login fast.
        }

        return location;
    }

    private static LocationInfo CreateLocalLocationInfo(string ipAddress)
    {
        IPAddress parsedAddress;
        if (IPAddress.TryParse(ipAddress, out parsedAddress) && IPAddress.IsLoopback(parsedAddress))
        {
            return new LocationInfo
            {
                Country = "Local",
                RegionState = "Loopback",
                City = "Localhost"
            };
        }

        return new LocationInfo
        {
            Country = "Private Network",
            RegionState = "LAN",
            City = "Internal"
        };
    }

    private static string GetDictionaryValue(IDictionary<string, object> data, string key)
    {
        object value;
        if (data == null || !data.TryGetValue(key, out value) || value == null)
        {
            return string.Empty;
        }

        return value.ToString();
    }

    private static bool IsPrivateOrLocalIpAddress(string ipAddress)
    {
        IPAddress parsedAddress;
        if (!IPAddress.TryParse(ipAddress, out parsedAddress))
        {
            return false;
        }

        if (IPAddress.IsLoopback(parsedAddress))
        {
            return true;
        }

        if (parsedAddress.AddressFamily == System.Net.Sockets.AddressFamily.InterNetworkV6)
        {
            byte[] ipv6Bytes = parsedAddress.GetAddressBytes();
            if (ipv6Bytes != null && ipv6Bytes.Length == 16)
            {
                if (ipv6Bytes[0] == 0xfc || ipv6Bytes[0] == 0xfd)
                {
                    return true;
                }
            }

            return parsedAddress.IsIPv6LinkLocal || parsedAddress.IsIPv6SiteLocal;
        }

        byte[] bytes = parsedAddress.GetAddressBytes();
        if (bytes.Length != 4)
        {
            return false;
        }

        if (bytes[0] == 10 || bytes[0] == 127)
        {
            return true;
        }

        if (bytes[0] == 192 && bytes[1] == 168)
        {
            return true;
        }

        if (bytes[0] == 169 && bytes[1] == 254)
        {
            return true;
        }

        return bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31;
    }

    private static string ResolveBrowserName(HttpRequest request, string userAgent)
    {
        HttpBrowserCapabilities browser = request.Browser;
        string browserName = browser == null ? string.Empty : browser.Browser;
        string version = browser == null ? string.Empty : browser.Version;

        if (!string.IsNullOrWhiteSpace(browserName) &&
            !browserName.Equals("Unknown", StringComparison.OrdinalIgnoreCase) &&
            !browserName.Equals("Mozilla", StringComparison.OrdinalIgnoreCase))
        {
            return string.IsNullOrWhiteSpace(version) ? browserName : browserName + " " + version;
        }

        string agent = (userAgent ?? string.Empty).ToLowerInvariant();
        if (agent.Contains("edg/"))
        {
            return "Microsoft Edge";
        }
        if (agent.Contains("opr/") || agent.Contains("opera"))
        {
            return "Opera";
        }
        if (agent.Contains("chrome/"))
        {
            return "Chrome";
        }
        if (agent.Contains("firefox/"))
        {
            return "Firefox";
        }
        if (agent.Contains("safari/"))
        {
            return "Safari";
        }
        if (agent.Contains("trident/") || agent.Contains("msie"))
        {
            return "Internet Explorer";
        }

        return "Unknown";
    }

    private static string ResolveOperatingSystem(HttpRequest request, string userAgent)
    {
        string agent = (userAgent ?? string.Empty).ToLowerInvariant();
        if (agent.Contains("windows nt 10.0"))
        {
            return "Windows 10/11";
        }
        if (agent.Contains("windows nt 6.3"))
        {
            return "Windows 8.1";
        }
        if (agent.Contains("windows nt 6.2"))
        {
            return "Windows 8";
        }
        if (agent.Contains("windows nt 6.1"))
        {
            return "Windows 7";
        }
        if (agent.Contains("android"))
        {
            return "Android";
        }
        if (agent.Contains("iphone") || agent.Contains("ipad") || agent.Contains("ipod"))
        {
            return "iOS";
        }
        if (agent.Contains("mac os x") || agent.Contains("macintosh"))
        {
            return "macOS";
        }
        if (agent.Contains("linux"))
        {
            return "Linux";
        }

        string platform = request.Browser == null ? string.Empty : request.Browser.Platform;
        return string.IsNullOrWhiteSpace(platform) ? "Unknown" : platform;
    }

    private static string ResolveDeviceType(HttpRequest request, string userAgent)
    {
        string agent = (userAgent ?? string.Empty).ToLowerInvariant();
        if (agent.Contains("ipad") || agent.Contains("tablet") || agent.Contains("kindle"))
        {
            return "Tablet";
        }

        if ((request.Browser != null && request.Browser.IsMobileDevice) ||
            agent.Contains("mobile") ||
            agent.Contains("iphone") ||
            agent.Contains("android"))
        {
            return "Mobile";
        }

        return "Desktop";
    }

    private sealed class TrackingRecord
    {
        public int UserId { get; set; }
        public DateTime LoginDateTime { get; set; }
        public string IPAddress { get; set; }
        public string Country { get; set; }
        public string RegionState { get; set; }
        public string City { get; set; }
        public string BrowserName { get; set; }
        public string OSName { get; set; }
        public string DeviceType { get; set; }
        public string SessionId { get; set; }
        public DateTime LastActivityTime { get; set; }
        public bool IsActiveSession { get; set; }
    }

    private sealed class LocationInfo
    {
        public string Country { get; set; }
        public string RegionState { get; set; }
        public string City { get; set; }
    }
}
