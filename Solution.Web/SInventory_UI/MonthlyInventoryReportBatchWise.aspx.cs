using Library.BLL.SInventory_BLL;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class SInventory_UI_MonthlyInventoryReportBatchWise : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    private static readonly string UiFmt = "dd MMMM, yyyy";

    // The underlying sp_Get_MonthlyInventoryReportBatchWise proc's opening-balance join is hardcoded
    // to the 31-Jul-2026 snapshot (DCOpeningBalanceDate = '31-july-2026'), so a From Date earlier than
    // that would silently return a zero opening stock rather than a meaningful error.
    private static readonly DateTime MinFromDate = new DateTime(2026, 7, 31);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var now = DateTime.Now;
            var monthEnd = new DateTime(now.Year, now.Month, 1).AddMonths(1).AddDays(-1);

            fromDateTextBox.Text = MinFromDate.ToString(UiFmt);
            toDateTextBox.Text = (monthEnd < MinFromDate ? MinFromDate : monthEnd).ToString(UiFmt);

            DropDownlist();
        }
    }

    private void DropDownlist()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!Validate(out fromDate, out toDate))
            return;

        LoadInfo(fromDate, toDate);
    }

    private bool Validate(out DateTime fromDate, out DateTime toDate)
    {
        fromDate = DateTime.MinValue;
        toDate = DateTime.MinValue;

        if (string.IsNullOrEmpty(salesCenterDropDownList.SelectedValue))
        {
            showMessageBox("Sales Center is required.");
            return false;
        }

        if (string.IsNullOrEmpty(fromDateTextBox.Text) || !DateTime.TryParse(fromDateTextBox.Text.Trim(), out fromDate))
        {
            showMessageBox("From Date is required.");
            return false;
        }

        if (fromDate < MinFromDate)
        {
            showMessageBox("From Date cannot be earlier than " + MinFromDate.ToString(UiFmt) + ".");
            return false;
        }

        if (string.IsNullOrEmpty(toDateTextBox.Text) || !DateTime.TryParse(toDateTextBox.Text.Trim(), out toDate))
        {
            showMessageBox("To Date is required.");
            return false;
        }

        if (toDate < fromDate)
        {
            showMessageBox("Invalid date range. To Date cannot be earlier than From Date.");
            return false;
        }

        return true;
    }

    private void LoadInfo(DateTime fromDate, DateTime toDate)
    {
        DataTable aDataTable = aSummaryBll.LoadMonthlyInventoryReportBatchWise(fromDate, toDate, salesCenterDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            showMessageBox("No Data Found!!");
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!Validate(out fromDate, out toDate))
            return;

        LoadInfo(fromDate, toDate);

        if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Monthly_Inventory_Report_BatchWise_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;

            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in loadGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            loadGridView.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h4>SMC Enterprise Limited</h4></span>
<span style='text-align:center'><h4>Monthly Inventory Report (Batch Wise)</h4></span>";

            string subTitle = "<span style='text-align:center'><h5>Between: " + fromDateTextBox.Text + " - " + toDateTextBox.Text +
                "   Reporting Date: " + DateTime.Now.ToString("dd-MMM-yyyy") + "</h5></span>";

            Response.Write(headerTable);
            Response.Write(subTitle);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        // required to avoid the runtime error "Control 'loadGridView' of type 'GridView' must be
        // placed inside a form tag with runat=server" during the Excel export's manual RenderControl.
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("MonthlyInventoryReportBatchWise.aspx");
    }
}
