using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.DataManager;

public partial class SInventory_RPTVIEW_DAExpenseDayWiseSummaryViewer : System.Web.UI.Page
{
    private const int MinGridRows = 29;

    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            return;
        }

        string daIds = Request.QueryString["daIds"];
        DateTime fromDate = ParseQueryDate("FromDate", new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1));
        DateTime toDate = ParseQueryDate("ToDate", fromDate.AddMonths(1).AddDays(-1));

        if (toDate < fromDate)
        {
            DateTime swapDate = fromDate;
            fromDate = toDate;
            toDate = swapDate;
        }

        using (DataTable dataTable = GetDayWiseData(daIds, fromDate, toDate))
        {
            litReport.Text = BuildReportHtml(dataTable);
        }

        if (String.Equals(Request.QueryString["fType"], "Print", StringComparison.OrdinalIgnoreCase))
        {
            litAutoPrint.Text = "<script type='text/javascript'>window.onload = function () { window.print(); };</script>";
        }
    }

    private DateTime ParseQueryDate(string key, DateTime fallback)
    {
        DateTime date;
        if (DateTime.TryParseExact(Request.QueryString[key], "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
        {
            return date;
        }

        return fallback;
    }

    private DataTable GetDayWiseData(string daIds, DateTime fromDate, DateTime toDate)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@Mode", "DayWise"));
        parameters.Add(new SqlParameter("@ComUnitId", DBNull.Value));
        parameters.Add(new SqlParameter("@Month", DBNull.Value));
        parameters.Add(new SqlParameter("@Year", DBNull.Value));
        parameters.Add(new SqlParameter("@DAId", DBNull.Value));
        parameters.Add(new SqlParameter("@DAIds", String.IsNullOrEmpty(daIds) ? (object)DBNull.Value : daIds));
        parameters.Add(new SqlParameter("@FromDate", fromDate));
        parameters.Add(new SqlParameter("@ToDate", toDate));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            return accessManager.GetDataTable("sp_Get_DAExpenseDayWiseSummary", parameters);
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private string BuildReportHtml(DataTable dataTable)
    {
        if (dataTable == null || dataTable.Rows.Count == 0)
        {
            return "<div class='report-section'><p style='text-align:center;'>No data found for the selected Sales Assistant(s) and date range.</p></div>";
        }

        StringBuilder sb = new StringBuilder();
        foreach (var daGroup in dataTable.AsEnumerable().GroupBy(r => Field(r, "DAId")))
        {
            sb.Append(BuildBillHtml(daGroup.ToList()));
        }

        return sb.ToString();
    }

    private string BuildBillHtml(List<DataRow> rows)
    {
        DataRow first = rows[0];
        string daName = (Field(first, "DACode") + " : " + Field(first, "DAName")).Trim(' ', ':');

        StringBuilder sb = new StringBuilder();
        sb.Append("<div class='report-section'>");

        sb.Append("<div class='title'>");
        sb.Append("<div class='co'>SMC Enterprise Limited</div>");
        sb.Append("<div class='div'>Pharmaceuticals Division</div>");
        sb.Append("<div class='rpt'>Expense Bill (Delivery, Market Visit, Tour)</div>");
        sb.Append("</div>");

        sb.Append("<table class='info-row'><tr>");

        sb.Append("<td style='width:33%;'><div class='info-box'><span class='cap'>Information</span><table>");
        sb.Append(InfoLine("Depot Name", Field(first, "BaseHQ")));
        sb.Append(InfoLine("Name", daName));
        sb.Append(InfoLine("Desig.", Field(first, "RoleName")));
        sb.Append(InfoLine("Month", Field(first, "MonthYear")));
        sb.Append(InfoLine("Bill Date", ""));
        sb.Append("</table></div></td>");

        sb.Append("<td style='width:33%;'><div class='info-box'><span class='cap'>Delivery Info.</span><table>");
        sb.Append(PairLine("No of Customer:", "COD:", "", "NCOD:", ""));
        sb.Append(PairLine("No of Invoice:", "COD:", "", "NCOD:", ""));
        sb.Append(PairLine("Invoice Value:", "COD:", "", "NCOD:", ""));
        sb.Append(InfoLine("Route Name", ""));
        sb.Append("</table></div></td>");

        sb.Append("<td style='width:34%;'><div class='info-box'><span class='cap'>Collection &amp; Return Info.</span><table>");
        sb.Append(PairLine("Collection Amount:", "COD:", "", "NCOD:", ""));
        sb.Append(InfoLine("60 Days above collection: Tk.", ""));
        sb.Append(InfoLine("30 Days below collection: Tk.", ""));
        sb.Append(PairLine("Retun Amount: Tk.", "", "", "No of Cus.", ""));
        sb.Append("</table></div></td>");

        sb.Append("</tr></table>");

        sb.Append("<table class='grid'>");
        sb.Append("<tr><td colspan='4' style='border:none;'></td><td colspan='2' class='place-cap'>Place of Delivery / Visit</td><td colspan='5' style='border:none;'></td></tr>");
        sb.Append("<tr>");
        sb.Append("<th style='width:4%;'>Sl</th>");
        sb.Append("<th style='width:9%;'>Date</th>");
        sb.Append("<th style='width:7%;'>From time</th>");
        sb.Append("<th style='width:7%;'>To time</th>");
        sb.Append("<th style='width:11%;'>From (Place)</th>");
        sb.Append("<th style='width:11%;'>To (Place)</th>");
        sb.Append("<th style='width:17%;'>Visited Customer Code or Name</th>");
        sb.Append("<th style='width:12%;'>Type Delivery/Collection</th>");
        sb.Append("<th style='width:9%;'>Transport Type</th>");
        sb.Append("<th style='width:9%;'>Working Hrs</th>");
        sb.Append("<th style='width:11%;'>Total Amount (Tk.)</th>");
        sb.Append("</tr>");

        decimal subTotal = 0;
        int sl = 1;
        foreach (DataRow row in rows)
        {
            decimal amount = Amount(row, "TotalAmount");
            subTotal += amount;

            sb.Append("<tr>");
            sb.AppendFormat("<td>{0}</td>", sl++);
            sb.AppendFormat("<td>{0}</td>", FormatWorkDate(row));
            sb.Append("<td></td>");
            sb.Append("<td></td>");
            sb.AppendFormat("<td class='l'>{0}</td>", Html(Field(row, "BaseHQ")));
            sb.AppendFormat("<td class='l'>{0}</td>", Html(Field(row, "MarketName")));
            sb.Append("<td></td>");
            sb.Append("<td></td>");
            sb.Append("<td></td>");
            sb.Append("<td class='r'>____Hrs</td>");
            sb.AppendFormat("<td class='r'>{0:N2}</td>", amount);
            sb.Append("</tr>");
        }

        for (int i = rows.Count; i < MinGridRows; i++)
        {
            sb.Append("<tr>");
            sb.AppendFormat("<td>{0}</td>", sl++);
            sb.Append("<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>");
            sb.Append("<td class='r'>____Hrs</td>");
            sb.Append("<td></td>");
            sb.Append("</tr>");
        }

        sb.Append("<tr class='subtotal'>");
        sb.Append("<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>");
        sb.Append("<td class='r'>Sub Total</td>");
        sb.Append("<td class='r'>____Hrs</td>");
        sb.AppendFormat("<td class='r'>{0:N2}</td>", subTotal);
        sb.Append("</tr>");
        sb.Append("</table>");

        // The proc exposes one AllowanceAmount (repeated on every row) and tags tours 'Ex. HQ',
        // so it lands on the Ex. HQ line; HQ and OS allowance have no source and stay blank.
        decimal allowance = Amount(first, "AllowanceAmount");

        sb.Append("<div style='margin-top:8px;font-weight:bold;'>Amount in word : <span class='fill' style='min-width:520px;'>&nbsp;</span></div>");

        sb.Append("<table class='foot'><tr>");
        sb.Append("<td style='width:70%;padding-right:10px;'><div class='feedback'>Market Feedback:</div></td>");
        sb.Append("<td style='width:30%;'><table class='allow' style='width:100%;'>");
        sb.Append(AllowLine("HQ Allowance :", ""));
        sb.Append(AllowLine("Ex. HQ Allowance :", allowance.ToString("N2", CultureInfo.InvariantCulture)));
        sb.Append(AllowLine("OS Allowance :", ""));
        sb.Append(AllowLine("Total Bill :", (subTotal + allowance).ToString("N2", CultureInfo.InvariantCulture)));
        sb.Append("</table></td>");
        sb.Append("</tr></table>");

        sb.Append("<table class='sign'><tr>");
        sb.Append("<td>Prepared by _______________</td>");
        sb.Append("<td>Checked by DA_______________</td>");
        sb.Append("<td>Checked by DIC_______________</td>");
        sb.Append("<td>Approved by _______________</td>");
        sb.Append("</tr></table>");

        sb.Append("</div>");
        return sb.ToString();
    }

    private static string InfoLine(string label, string value)
    {
        return String.Format("<tr><td style='width:45%;'>{0}</td><td>: <span class='fill fill-lg'>{1}</span></td></tr>",
            HttpUtility.HtmlEncode(label), Html(value));
    }

    private static string PairLine(string label, string leftCap, string leftValue, string rightCap, string rightValue)
    {
        return String.Format("<tr><td>{0}</td><td>{1}<span class='fill'>{2}</span>, {3}<span class='fill'>{4}</span></td></tr>",
            HttpUtility.HtmlEncode(label),
            HttpUtility.HtmlEncode(leftCap), Html(leftValue),
            HttpUtility.HtmlEncode(rightCap), Html(rightValue));
    }

    private static string AllowLine(string label, string value)
    {
        return String.Format("<tr><td>{0}</td><td style='width:45%;'><span class='fill fill-lg'>{1}</span></td></tr>",
            HttpUtility.HtmlEncode(label), Html(value));
    }

    private static string FormatWorkDate(DataRow row)
    {
        DateTime workDate;
        if (DateTime.TryParseExact(Field(row, "WorkDate"), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out workDate))
        {
            return workDate.ToString("dd-MM-yyyy", CultureInfo.InvariantCulture);
        }

        return Html(Field(row, "DisplayDate"));
    }

    private static string Field(DataRow row, string column)
    {
        if (!row.Table.Columns.Contains(column) || row[column] == DBNull.Value)
        {
            return String.Empty;
        }

        return row[column].ToString();
    }

    private static decimal Amount(DataRow row, string column)
    {
        if (!row.Table.Columns.Contains(column) || row[column] == DBNull.Value)
        {
            return 0;
        }

        return Convert.ToDecimal(row[column]);
    }

    private static string Html(string value)
    {
        return String.IsNullOrEmpty(value) ? "&nbsp;" : HttpUtility.HtmlEncode(value);
    }
}
