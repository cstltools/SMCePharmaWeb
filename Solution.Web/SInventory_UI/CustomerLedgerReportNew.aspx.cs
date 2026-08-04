using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_CustomerLedgerReportNew : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }
    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {


        string empName = cCodeTextBox.Text.Trim();

        if (empName != "")
        {
            try
            {
                if (empName.Contains(':'))
                {
                    string[] emp = empName.Split('|');
                    string[] custCode = empName.Split(':');
                    hfCustomerId.Value = custCode[0].Trim();
                    cCodeTextBox.Text = emp[0].Trim();



                }
                else
                {

                    //custNameTextBox.Text = "";
                    hfCustomerId.Value = "";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Input Correct Data !" + "','Faild');", true);


                }

            }
            catch
            {
                hfCustomerId.Value = "";
            }
        }

    }
    CustomerLedgerBLL aCustomerMasterBlls = new CustomerLedgerBLL();
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(hfCustomerId.Value))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                    "faildalert('" + "Please select a valid customer!" + "','Failed');", true);
                return;
            }

            // Validate dates
            DateTime fromDate;
            DateTime toDate;

            if (!DateTime.TryParse(fromDateTextBox.Text, out fromDate))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                    "faildalert('" + "Please enter a valid From Date!" + "','Failed');", true);
                return;
            }

            if (!DateTime.TryParse(toDateTextBox.Text, out toDate))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                    "faildalert('" + "Please enter a valid To Date!" + "','Failed');", true);
                return;
            }

            if (fromDate > toDate)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                    "faildalert('" + "From Date cannot be greater than To Date!" + "','Failed');", true);
                return;
            }

            string customerID = hfCustomerId.Value.Trim();

            DataTable mainDataTable = aCustomerMasterBlls.CustomerLedgerBllNew(customerID, fromDate.ToString(), toDate.ToString());

            if (mainDataTable == null || mainDataTable.Rows.Count == 0)
            {
                ltReportHtml.Text = "<div class='no-data'>No records found for the selected criteria.</div>";
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                    "faildalert('" + "No records found for the selected customer and date range!" + "','Failed');", true);
            }
            else
            {
                ltReportHtml.Text = GenerateReportTable(mainDataTable);
                // Optional success message if needed
                // ScriptManager.RegisterStartupScript(this, GetType(), "Popup", 
                //     "successalert('" + "Report generated successfully!" + "','Success');", true);
            }
        }
        catch (Exception ex)
        {
            ltReportHtml.Text = "<div class='error'>An error occurred while generating the report.</div>";
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                "faildalert('" + "An error occurred: " + ex.Message.Replace("'", "\\'") + "','Failed');", true);
        }
    }
    private string GenerateReportTable(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();

        // Calculate totals
        decimal totalInvNetAmount = 0;
        decimal totalInvNetTP = 0;
        decimal totalDeliveryNetTP = 0;
        decimal totalDeliveryNetAmount = 0;
        decimal totalRtnNetTP = 0;
        decimal totalRtnNetAmount = 0;
        decimal TotalPaymentTP = 0;
        decimal totalPaymentNet = 0;

        foreach (DataRow row in dt.Rows)
        {
            totalInvNetAmount += Convert.ToDecimal(row["InvNetAmount"]);
            totalInvNetTP += Convert.ToDecimal(row["InvNetTP"]);
            totalRtnNetTP += Convert.ToDecimal(row["RtnNetTP"]);
            totalRtnNetAmount += Convert.ToDecimal(row["RtnNetAmount"]);
            totalPaymentNet += Convert.ToDecimal(row["PaymentNet"]);
            TotalPaymentTP += Convert.ToDecimal(row["PaymentTP"]);
            totalDeliveryNetTP += Convert.ToDecimal(row["DeliveryNetTP"]);
            totalDeliveryNetAmount += Convert.ToDecimal(row["DeliveryNetAmount"]);
        }

        decimal deliveryReturnTotalNetAmount = totalDeliveryNetAmount - totalRtnNetAmount;
        decimal deliveryReturnPaymentTotal = deliveryReturnTotalNetAmount - totalPaymentNet;
        decimal displayDueAmount = Math.Abs(deliveryReturnPaymentTotal) <= 1 ? 0 : deliveryReturnPaymentTotal;

        sb.Append("<table id='dtTb'>");
        // Header Rows
        sb.Append("<thead>");

        // Company Info Rows
        sb.Append("<tr><th colspan='18' style='font-size:20px; font-weight:bold; text-align:left;'>SMC Enterprise Ltd.</th></tr>");
        sb.Append("<tr><th colspan='18' style='text-align:left;'>SMC Tower, 33, Banani C/A, Dhaka - 1213</th></tr>");

        sb.Append("<tr><th colspan='18' style='font-size:16px; font-weight:bold;'>Customer Ledger Report</th></tr>");
        sb.AppendFormat("<tr><th colspan='18'>From: {0} To: {1}</th></tr>", fromDateTextBox.Text, toDateTextBox.Text);

        // Actual Table Header
        sb.Append("<tr>");
        sb.Append("<th rowspan='2'>Sales Center <br/> Code</th>");
        sb.Append("<th rowspan='2'>Sales Center <br/> Name</th>");
        sb.Append("<th rowspan='2'><i>Customer<br/>Code</i></th>");
        sb.Append("<th rowspan='2'><i>Customer<br/>Name</i></th>");
        sb.Append("<th rowspan='2'>Order No</th>");
        sb.Append("<th rowspan='2'>Market Code</th>");
        sb.Append("<th rowspan='2'>Market Name</th>");
        sb.Append("<th rowspan='2'>Invoice Number</th>");
        sb.Append("<th rowspan='2'>Invoice Date</th>");
        sb.Append("<th colspan='2' class='header-yellow'>Proforma</th>");
        sb.Append("<th colspan='2' class='header-green'>Delivery</th>");
        sb.Append("<th colspan='2' class='header-lightblue'>Return</th>");
        sb.Append("<th colspan='2' class='header-skyblue'>Payment</th>");
        sb.Append("<th rowspan='2'>Campaign</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th class='header-yellow'>Net TP</th>");
        sb.Append("<th class='header-yellow'>Net Amount</th>");
        sb.Append("<th class='header-green'>Net TP</th>");
        sb.Append("<th class='header-green'>Net Amount</th>");
        sb.Append("<th class='header-lightblue'>Net TP</th>");
        sb.Append("<th class='header-lightblue'>Net Amount</th>");
        sb.Append("<th class='header-skyblue'>Net TP</th>");
        sb.Append("<th class='header-skyblue'>Net Amount</th>");

        //   sb.Append("<th></th>"); // Empty cell to match colspan
        sb.Append("</tr>");

        sb.Append("</thead>");

        // Data Rows
        sb.Append("<tbody>");
        foreach (DataRow row in dt.Rows)
        {
            sb.Append("<tr>");
            sb.AppendFormat("<td>{0}</td>", row["ComUnitCode"]);
            sb.AppendFormat("<td>{0}</td>", row["ComUnitName"]);
            sb.AppendFormat("<td>{0}</td>", row["CustomerCode"]);
            sb.AppendFormat("<td>{0}</td>", row["CustomerName"]);
            sb.AppendFormat("<td>{0}</td>", row["OrderNo"]);
            sb.AppendFormat("<td>{0}</td>", row["MarketCode"]);
            sb.AppendFormat("<td>{0}</td>", row["MarketName"]);
            sb.AppendFormat("<td>{0}</td>", row["InvoiceNo"]);
            sb.AppendFormat("<td>{0}</td>", row["InvoiceDate"]);
            sb.AppendFormat("<td>{0}</td>", row["InvNetTP"]);
            sb.AppendFormat("<td>{0}</td>", row["InvNetAmount"]);
            sb.AppendFormat("<td>{0}</td>", row["DeliveryNetTP"]);
            sb.AppendFormat("<td>{0}</td>", row["DeliveryNetAmount"]);
            sb.AppendFormat("<td>{0}</td>", row["RtnNetTP"]);
            sb.AppendFormat("<td>{0}</td>", row["RtnNetAmount"]);
            sb.AppendFormat("<td>{0}</td>", row["PaymentTP"]);
            sb.AppendFormat("<td>{0}</td>", row["PaymentNet"]);
            sb.AppendFormat("<td>{0}</td>", row["CustomerType"]);
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");

        // Footer Row with Totals
        sb.Append("<tfoot>");
        sb.Append("<tr style='font-weight:bold; background-color:#f2f2f2;'>");
        sb.Append("<td colspan='9' style='text-align:right;'>Total:</td>");
        sb.AppendFormat("<td>{0}</td>", totalInvNetTP.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", totalInvNetAmount.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", totalDeliveryNetTP.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", totalDeliveryNetAmount.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", totalRtnNetTP.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", totalRtnNetAmount.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", TotalPaymentTP.ToString("N2"));
        sb.AppendFormat("<td>{0}</td>", totalPaymentNet.ToString("N2"));
        sb.Append("<td></td>"); // Empty cell for Campaign column
        sb.Append("</tr>");
        sb.Append("</tfoot>");

        sb.Append("</table>");

        sb.Append("<div style='width:100%; display:flex; justify-content:flex-end; margin-top:12px;'>");
        sb.Append("<div id='ledgerSummaryBox' style='min-width:380px; border:1px solid #000; padding:8px 10px; font-weight:bold; background-color:#fff;'>");
        sb.Append("<div style='display:flex; justify-content:space-between; gap:20px; padding:3px 0;'><span>Delivery Net Amount=</span>");
        sb.AppendFormat("<span>{0}</span></div>", totalDeliveryNetAmount.ToString("N2"));
        sb.Append("<div style='display:flex; justify-content:space-between; gap:20px; padding:3px 0;'><span>Return Net Amount=</span>");
        sb.AppendFormat("<span>{0}</span></div>", totalRtnNetAmount.ToString("N2"));
        sb.Append("<div style='border-top:1px solid #000; margin:6px 0;'></div>");
        sb.Append("<div style='display:flex; justify-content:space-between; gap:20px; padding:3px 0;'><span>(Delivery - Return) Total Net Amount=</span>");
        sb.AppendFormat("<span>{0}</span></div>", deliveryReturnTotalNetAmount.ToString("N2"));
        sb.Append("<div style='display:flex; justify-content:space-between; gap:20px; padding:3px 0;'><span>Payment Net Amount=</span>");
        sb.AppendFormat("<span>{0}</span></div>", totalPaymentNet.ToString("N2"));
        sb.Append("<div style='border-top:1px solid #000; margin:6px 0;'></div>");
        sb.Append("<div style='display:flex; justify-content:space-between; gap:20px; padding:3px 0;'><span>((Delivery - Return) - Payment) Total DUE AMOUNT=</span>");
        sb.AppendFormat("<span>{0}</span></div>", displayDueAmount.ToString("N2"));
        sb.Append("</div>");
        sb.Append("</div>");

        return sb.ToString();
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

        Response.Redirect("CustomerLedgerReportNew.aspx");
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}
