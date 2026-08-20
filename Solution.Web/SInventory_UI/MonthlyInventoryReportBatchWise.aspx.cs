using Library.BLL.SInventory_BLL;
using System;
using System.Data;
using System.IO;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class SInventory_UI_MonthlyInventoryReportBatchWise : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    private static readonly string UiFmt = "dd MMMM, yyyy";

    // Opening_Qty in sp_Get_MonthlyInventoryReportBatchWise_SAP comes from the Sap_Stock13thSepOpening
    // snapshot, which is fixed at 31-Jul-2026 and carries no date column of its own. A later From Date
    // would keep that same opening but drop the movements before it, so the closing stock would be
    // wrong - From Date is pinned here and the datepicker's min in the markup enforces the same.
    private static readonly DateTime MinFromDate = new DateTime(2026, 7, 31);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var today = DateTime.Now.Date;

            fromDateTextBox.Text = MinFromDate.ToString(UiFmt);
            toDateTextBox.Text = (today < MinFromDate ? MinFromDate : today).ToString(UiFmt);

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

        if (fromDate != MinFromDate)
        {
            showMessageBox("From Date is fixed at " + MinFromDate.ToString(UiFmt) + " (SAP opening stock date).");
            fromDateTextBox.Text = MinFromDate.ToString(UiFmt);
            fromDate = MinFromDate;
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
        DataTable aDataTable = aSummaryBll.LoadMonthlyInventoryReportBatchWiseSap(
            fromDate, toDate, salesCenterDropDownList.SelectedValue, productCodeTextBox.Text);

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

            // the Closing Qty header is a template carrying the info button; setting Text drops those
            // controls so the popover markup doesn't leak into the sheet.
            loadGridView.HeaderRow.Cells[loadGridView.Columns.Count - 1].Text = "Closing Qty";

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
                "   Sales Center: " + salesCenterDropDownList.SelectedItem.Text +
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
