using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_StockOutReport : System.Web.UI.Page
{
    DeStockOutBLL aDeStockOutBll = new DeStockOutBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDepotDropDown();
            fromDateTextBox.Text = DateTime.Today.AddMonths(-1).ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Today.ToString("dd MMMM, yyyy");
        }

        ApplyReportTypeHeaders();
    }

    private void LoadDepotDropDown()
    {
        // OtherStockActionBLL.DCLoad -> ClsCommonInternalDAL.LoadDropDownValue already inserts a
        // "--------Select---------" placeholder at index 0 - don't add a second one here.
        new OtherStockActionBLL().DCLoad(depotDropDownList);
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        gv_StockOut.PageIndex = 0;
        LoadInfo();
    }

    protected void gv_StockOut_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gv_StockOut.PageIndex = e.NewPageIndex;
        LoadInfo();
    }

    protected void rbReportType_CheckedChanged(object sender, EventArgs e)
    {
        ApplyReportTypeHeaders();
        gv_StockOut.DataSource = null;
        gv_StockOut.DataBind();
    }

    // Both report types share the same GridView/DataFields (sp_RPT_NCPReport aliases its columns
    // to match sp_RPT_StockOutReport's output shape) - only these two header labels need to flip.
    // The active/inactive button look is also set explicitly here (not left to the CSS
    // :checked+sibling rule alone) so the selected report type is unambiguous on every render.
    private void ApplyReportTypeHeaders()
    {
        ((BoundField)gv_StockOut.Columns[3]).HeaderText = rbGift.Checked ? "Stock Out Date" : "Expiry Date";
        ((BoundField)gv_StockOut.Columns[7]).HeaderText = rbGift.Checked ? "Stock Out Qty" : "Quantity";

        lblGift.CssClass = rbGift.Checked ? "btn btn-primary px-4" : "btn btn-outline-primary px-4";
        lblNCP.CssClass = rbGift.Checked ? "btn btn-outline-primary px-4" : "btn btn-primary px-4";
    }

    private string ReportTypeName()
    {
        return rbGift.Checked ? "Gift" : "NCP";
    }

    private bool ValidateFilter(out DateTime fromDate, out DateTime toDate)
    {
        fromDate = DateTime.MinValue;
        toDate = DateTime.MinValue;

        if (string.IsNullOrEmpty(fromDateTextBox.Text) || !DateTime.TryParse(fromDateTextBox.Text.Trim(), out fromDate))
        {
            showMessageBox("Please select From Date!!");
            return false;
        }

        if (string.IsNullOrEmpty(toDateTextBox.Text) || !DateTime.TryParse(toDateTextBox.Text.Trim(), out toDate))
        {
            showMessageBox("Please select To Date!!");
            return false;
        }

        if (toDate < fromDate)
        {
            showMessageBox("Invalid date range. To Date cannot be earlier than From Date!!");
            return false;
        }

        return true;
    }

    private void LoadInfo()
    {
        ApplyReportTypeHeaders();
        gv_StockOut.DataSource = null;
        gv_StockOut.DataBind();

        DateTime fromDate, toDate;
        if (!ValidateFilter(out fromDate, out toDate))
            return;

        int comUnitId = string.IsNullOrEmpty(depotDropDownList.SelectedValue) ? 0 : Convert.ToInt32(depotDropDownList.SelectedValue);

        DataTable aDataTable = rbGift.Checked
            ? aDeStockOutBll.StockOutReportBll(fromDate, toDate, comUnitId)
            : aDeStockOutBll.NCPReportBll(fromDate, toDate, comUnitId);

        if (aDataTable.Rows.Count > 0)
        {
            gv_StockOut.DataSource = aDataTable;
            gv_StockOut.DataBind();

            try
            {
                gv_StockOut.FooterRow.Cells[0].Text = "Total:";
                decimal totalQty = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("StockOutQty") ?? 0);
                gv_StockOut.FooterRow.Cells[7].Text = totalQty.ToString("N2");
                gv_StockOut.FooterRow.BackColor = Color.Bisque;
                gv_StockOut.FooterRow.Font.Bold = true;
                gv_StockOut.FooterRow.HorizontalAlign = HorizontalAlign.Right;
            }
            catch { }
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("StockOutReport.aspx");
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!ValidateFilter(out fromDate, out toDate))
            return;

        try
        {
            gv_StockOut.AllowPaging = false;
            LoadInfo();

            if (gv_StockOut.Rows.Count == 0)
            {
                showMessageBox("No Data Found!!");
                return;
            }

            string attachment = "attachment; filename=" + ReportTypeName() + "_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            HtmlForm frm = new HtmlForm();
            gv_StockOut.Parent.Controls.Add(frm);

            gv_StockOut.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in gv_StockOut.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in gv_StockOut.Rows)
            {
                gridViewRow.BackColor = Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            gv_StockOut.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h3>" + ReportTypeName() + " Report (" + depotDropDownList.SelectedItem.Text + ", " + fromDateTextBox.Text + " to " + toDateTextBox.Text + ")</h3></span> <span style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);
            Response.Write(sw.ToString());
            Response.End();
        }
        catch
        {
            showMessageBox("No Data Found!!");
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
    }
}
