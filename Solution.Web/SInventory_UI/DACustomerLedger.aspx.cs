using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_DACustomerLedger : System.Web.UI.Page
{
    private readonly CustPaymentBLL_daaw aCustPaymentBll = new CustPaymentBLL_daaw();
    private readonly InvoiceBLL_daaw aInvoiceBll = new InvoiceBLL_daaw();
    private readonly StockTransportOrderReportBLL_daaw aOrderReportBll = new StockTransportOrderReportBLL_daaw();
    private static readonly SeedDataDAL_daaw _seedRepo = new SeedDataDAL_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        SetDateInputAttributes();

        if (!IsPostBack)
        {
            LoadSalesCenters();
            string currentDate = DateTime.Today.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            fromDateTextBox.Text = currentDate;
            toDateTextBox.Text = currentDate;
        }
    }

    private void SetDateInputAttributes()
    {
        fromDateTextBox.Attributes["type"] = "date";
        toDateTextBox.Attributes["type"] = "date";
    }

    private void LoadSalesCenters()
    {
        try
        {
            aCustPaymentBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            if (salesCenterDropDownList.Items.Count > 1)
            {
                salesCenterDropDownList.SelectedIndex = 1;
            }
            salesCenterDropDownList_SelectedIndexChanged(null, null);
        }
        catch
        {
        }
    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        rootDropDownList.Items.Clear();
        int salesCenterId;
        if (!int.TryParse(salesCenterDropDownList.SelectedValue, out salesCenterId))
        {
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            return;
        }

        try
        {
            using (DataTable dt = _seedRepo.GetRouteInfoforCustPayment(salesCenterId))
            {
                rootDropDownList.DataSource = dt;
                rootDropDownList.DataValueField = "DistributionRouteId";
                rootDropDownList.DataTextField = "DistributionRouteName";
                rootDropDownList.DataBind();
                rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                rootDropDownList.SelectedIndex = 0;
            }
        }
        catch
        {
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        }
    }

    protected void resetButton_Click(object sender, EventArgs e)
    {
        LoadSalesCenters();
        string currentDate = DateTime.Today.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
        fromDateTextBox.Text = currentDate;
        toDateTextBox.Text = currentDate;
        reportLiteral.Text = string.Empty;
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (!ValidateSearch())
        {
            return;
        }

        DataTable reportTable = aInvoiceBll.MoneyReceiptAfterPaymentInfoForDALedger(BuildReportParameter());
        DataTable companyInfoTable = aOrderReportBll.CompanyInfoBLL().Copy();

        reportLiteral.Text = BuildReportHtml(reportTable, companyInfoTable);
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowDALedgerReport", "showDaLedgerReportModal();", true);
    }

    private bool ValidateSearch()
    {
        if (string.IsNullOrWhiteSpace(salesCenterDropDownList.SelectedValue))
        {
            ShowMessageBox("Please Select Sales Center!!");
            return false;
        }

        DateTime fromDate;
        if (!DateTime.TryParse(fromDateTextBox.Text, out fromDate))
        {
            ShowMessageBox("Please Select From Date!!");
            return false;
        }

        DateTime toDate;
        if (!DateTime.TryParse(toDateTextBox.Text, out toDate))
        {
            ShowMessageBox("Please Select To Date!!");
            return false;
        }

        if (fromDate.Date > toDate.Date)
        {
            ShowMessageBox("From Date cannot be greater than To Date!!");
            return false;
        }

        return true;
    }

    private string BuildReportParameter()
    {
        DateTime fromDate = DateTime.Parse(fromDateTextBox.Text, CultureInfo.InvariantCulture);
        DateTime toDate = DateTime.Parse(toDateTextBox.Text, CultureInfo.InvariantCulture);

        StringBuilder parameter = new StringBuilder();
        parameter.Append(" AND ord.ComUnitId='").Append(salesCenterDropDownList.SelectedValue.Replace("'", "''")).Append("' ");
        parameter.Append(" AND CONVERT(DATE, custPay.custPaymentDate) BETWEEN '")
            .Append(fromDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture))
            .Append("' AND '")
            .Append(toDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture))
            .Append("' ");

        if (!string.IsNullOrWhiteSpace(rootDropDownList.SelectedValue))
        {
            parameter.Append(" AND ord.DistributionRouteId='").Append(rootDropDownList.SelectedValue.Replace("'", "''")).Append("' ");
        }

        return parameter.ToString();
    }

    private string BuildReportHtml(DataTable reportTable, DataTable companyInfoTable)
    {
        if (reportTable == null || reportTable.Rows.Count == 0)
        {
            return "<div class=\"money-receipt-report\"><strong>No Data Found.</strong></div>";
        }

        DataRow companyRow = companyInfoTable != null && companyInfoTable.Rows.Count > 0 ? companyInfoTable.Rows[0] : null;
        string companyName = GetValue(companyRow, "CompanyName", "SMC Enterprise Ltd.");
        string logoUrl = ResolveUrl("~/images/smc-logo-(horizontal).png");

        StringBuilder html = new StringBuilder();
        html.Append("<div class=\"money-receipt-report\">");

        DataRow topRow = reportTable.Rows[0];
        html.Append("<div class=\"report-header\">");
        html.Append("<div class=\"company-block\">");
        html.Append("<img src=\"").Append(HttpUtility.HtmlAttributeEncode(logoUrl)).Append("\" alt=\"SMC\" />");
        html.Append("<div class=\"company-subtitle\">Helping you live better</div>");
        html.Append("<div class=\"company-name\">").Append(Encode(companyName)).Append("</div>");
        html.Append("</div>");
        html.Append("<div class=\"dc-block\">");
        html.Append(Encode(GetValue(topRow, "ComUnitName", String.Empty)));
        html.Append("<span class=\"dc-address\">").Append(Encode(GetValue(topRow, "Address", GetValue(companyRow, "Address", String.Empty)))).Append("</span>");
        html.Append("</div>");
        html.Append("</div>");

        html.Append("<div class=\"receipt-page\">");
        
        html.Append("<div class=\"receipt-title-row\">");
        html.Append("<div class=\"receipt-title\">Money Receipt</div>");
        html.Append("<div class=\"print-date\">Print On : &nbsp; ").Append(Encode(DateTime.Now.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture))).Append("</div>");
        html.Append("</div>");

        html.Append("<br/>");

        html.Append("<table>");
        html.Append("<thead><tr>");
        html.Append("<th>Order No</th>");
        html.Append("<th>Customer Code</th>");
        html.Append("<th>CustomerName</th>");
        html.Append("<th>Invoice No</th>");
        html.Append("<th>Invoice Date</th>");
        html.Append("<th>Payment Date</th>");
        html.Append("<th>Collection By</th>");
        html.Append("<th>TP</th>");
        html.Append("<th>Vat</th>");
        html.Append("<th>T.Amount</th>");
        html.Append("</tr></thead><tbody>");

        decimal totalAmount = 0;

        foreach (DataRow row in reportTable.Rows)
        {
            decimal paymentAmount = GetDecimal(row, "PaymentAmount");
            totalAmount += paymentAmount;

            html.Append("<tr>");
            html.Append("<td class=\"text-center\">").Append(Encode(GetValue(row, "OrderNo", String.Empty))).Append("</td>");
            html.Append("<td class=\"text-center\">").Append(Encode(GetValue(row, "CustomerCode", String.Empty))).Append("</td>");
            html.Append("<td>").Append(Encode(GetValue(row, "CustomerName", String.Empty))).Append("</td>");
            html.Append("<td class=\"text-center\">").Append(Encode(GetValue(row, "InvoiceNo", String.Empty))).Append("</td>");
            html.Append("<td class=\"text-center\">").Append(Encode(GetValue(row, "InvoiceDate", String.Empty))).Append("</td>");
            html.Append("<td class=\"text-center\">").Append(Encode(GetValue(row, "PaymentDate", String.Empty))).Append("</td>");
            html.Append("<td>").Append(Encode(GetValue(row, "OrderBy", String.Empty))).Append("</td>");
            html.Append("<td class=\"text-right\">").Append(GetDecimal(row, "TPAmount").ToString("N2")).Append("</td>");
            html.Append("<td class=\"text-right\">").Append(GetDecimal(row, "VatAmount").ToString("N2")).Append("</td>");
            html.Append("<td class=\"text-right\">").Append(paymentAmount.ToString("N2")).Append("</td>");
            html.Append("</tr>");
        }

        html.Append("<tr class=\"total-row\"><td colspan=\"8\"></td><td class=\"text-right\">Total:</td><td class=\"text-right\">")
            .Append(totalAmount.ToString("N2")).Append("</td></tr>");
        html.Append("</tbody></table>");
        html.Append("<div class=\"in-words\"><u><b>In Words : </b></u> &nbsp;&nbsp; ").Append(Encode(ConvertAmountToWords(totalAmount))).Append("</div>");

        html.Append("</div>");
        html.Append("</div>");
        return html.ToString();
    }

    private static string GetValue(DataRow row, string columnName, string defaultValue)
    {
        if (row == null || row.Table == null || !row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
        {
            return defaultValue;
        }

        return Convert.ToString(row[columnName]);
    }

    private static decimal GetDecimal(DataRow row, string columnName)
    {
        decimal value;
        return Decimal.TryParse(GetValue(row, columnName, "0"), out value) ? value : 0m;
    }

    private static string Encode(string value)
    {
        return HttpUtility.HtmlEncode(value ?? String.Empty);
    }

    private static string ConvertAmountToWords(decimal amount)
    {
        long taka = (long)Math.Floor(amount);
        int paisa = (int)Math.Round((amount - taka) * 100);
        string words = NumberToWords(taka) + " Taka";
        if (paisa > 0)
        {
            words += " and " + NumberToWords(paisa) + " Paisa";
        }

        return words + " Only";
    }

    private static string NumberToWords(long number)
    {
        if (number == 0)
        {
            return "Zero";
        }

        if (number < 0)
        {
            return "Minus " + NumberToWords(Math.Abs(number));
        }

        string words = "";

        if ((number / 10000000) > 0)
        {
            words += NumberToWords(number / 10000000) + " Crore ";
            number %= 10000000;
        }

        if ((number / 100000) > 0)
        {
            words += NumberToWords(number / 100000) + " Lac ";
            number %= 100000;
        }

        if ((number / 1000) > 0)
        {
            words += NumberToWords(number / 1000) + " Thousand ";
            number %= 1000;
        }

        if ((number / 100) > 0)
        {
            words += NumberToWords(number / 100) + " Hundred ";
            number %= 100;
        }

        if (number > 0)
        {
            string[] unitsMap = { "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
            string[] tensMap = { "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

            if (number < 20)
            {
                words += unitsMap[(int)number];
            }
            else
            {
                words += tensMap[(int)(number / 10)];
                if ((number % 10) > 0)
                {
                    words += " " + unitsMap[(int)(number % 10)];
                }
            }
        }

        return words.Trim();
    }

    private void ShowMessageBox(string message)
    {
        message = (message ?? String.Empty).Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + message + "');", true);
    }
}
