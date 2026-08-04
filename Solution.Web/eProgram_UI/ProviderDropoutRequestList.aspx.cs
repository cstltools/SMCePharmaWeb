using Library.DAL.SAP_IntegrationDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

public partial class eProgram_UI_ProviderDropoutRequestList : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ProviderDropoutResponse GetProviderDropoutIntrigrationList()
    {
        ProviderDropoutResponse response = new ProviderDropoutResponse
        {
            isSuccess = false,
            message = "No data found.",
            data = new List<ProviderDropoutItem>()
        };

        try
        {
            SAP_IntrigationPointDAL dal = new SAP_IntrigationPointDAL();
            DataTable dt = dal.GetProviderDropoutIntrigrationListDAL();

            foreach (DataRow row in dt.Rows)
            {
                ProviderDropoutItem item = new ProviderDropoutItem
                {
                    providerIDropoutIntrigrationd = row["providerIDropoutIntrigrationd"] == DBNull.Value
                        ? 0
                        : Convert.ToInt64(row["providerIDropoutIntrigrationd"]),
                    providerId = row["providerId"] == DBNull.Value
                        ? (int?)null
                        : Convert.ToInt32(row["providerId"]),
                    programShortName = row["programShortName"] == DBNull.Value
                        ? string.Empty
                        : row["programShortName"].ToString(),
                    providerCode = row["providerCode"] == DBNull.Value
                        ? string.Empty
                        : row["providerCode"].ToString(),
                    providerName = row["providerName"] == DBNull.Value
                        ? string.Empty
                        : row["providerName"].ToString(),
                    mobileNo = row["mobileNo"] == DBNull.Value
                        ? string.Empty
                        : row["mobileNo"].ToString(),
                    nid = row["nid"] == DBNull.Value
                        ? string.Empty
                        : row["nid"].ToString(),
                    email = row["email"] == DBNull.Value
                        ? string.Empty
                        : row["email"].ToString(),
                    outlet = row["outlet"] == DBNull.Value
                        ? string.Empty
                        : row["outlet"].ToString(),
                    dropoutReason = row["dropoutReason"] == DBNull.Value
                        ? string.Empty
                        : row["dropoutReason"].ToString(),
                    insertedAt = row["insertedAt"] == DBNull.Value
                        ? string.Empty
                        : Convert.ToDateTime(row["insertedAt"]).ToString("dd-MMM-yyyy hh:mm tt"),
                    isApprove = dt.Columns.Contains("IsApprove") && row["IsApprove"] != DBNull.Value
                        ? Convert.ToBoolean(row["IsApprove"])
                        : false,
                    isApproveBy = dt.Columns.Contains("IsApproveBy") && row["IsApproveBy"] != DBNull.Value
                        ? row["IsApproveBy"].ToString()
                        : string.Empty,
                    approveDate = dt.Columns.Contains("ApproveDate") && row["ApproveDate"] != DBNull.Value
                        ? Convert.ToDateTime(row["ApproveDate"]).ToString("dd-MMM-yyyy hh:mm tt")
                        : string.Empty
                };

                response.data.Add(item);
            }

            response.isSuccess = true;
            response.message = "Data loaded successfully.";
        }
        catch (Exception ex)
        {
            response.isSuccess = false;
            response.message = ex.Message;
        }

        return response;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static ActionResponse ApproveProviderDropoutIntrigration(long providerIDropoutIntrigrationd)
    {
        ActionResponse response = new ActionResponse
        {
            isSuccess = false,
            message = "Approve failed."
        };

        try
        {
            SAP_IntrigationPointDAL dal = new SAP_IntrigationPointDAL();
            var result = dal.ApproveProviderDropoutIntrigrationDAL(providerIDropoutIntrigrationd);

            response.isSuccess = result.isSuccess;
            response.message = result.isSuccess ? "Approved successfully." : "Approve failed.";
        }
        catch (Exception ex)
        {
            response.isSuccess = false;
            response.message = ex.Message;
        }

        return response;
    }
}

public class ProviderDropoutResponse
{
    public bool isSuccess { get; set; }
    public string message { get; set; }
    public List<ProviderDropoutItem> data { get; set; }
}

public class ProviderDropoutItem
{
    public long providerIDropoutIntrigrationd { get; set; }
    public int? providerId { get; set; }
    public string programShortName { get; set; }
    public string providerCode { get; set; }
    public string providerName { get; set; }
    public string mobileNo { get; set; }
    public string nid { get; set; }
    public string email { get; set; }
    public string outlet { get; set; }
    public string dropoutReason { get; set; }
    public string insertedAt { get; set; }
    public bool isApprove { get; set; }
    public string isApproveBy { get; set; }
    public string approveDate { get; set; }
}

public class ActionResponse
{
    public bool isSuccess { get; set; }
    public string message { get; set; }
}
