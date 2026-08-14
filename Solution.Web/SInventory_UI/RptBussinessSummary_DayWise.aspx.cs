using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_RptBussinessSummary_DayWise : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    private static readonly string MiUiFmt = "dd MMMM, yyyy";

    // sp_Get_MonthlyInventoryReportBatchWise's opening-balance join is hardcoded to the
    // 31-Jul-2026 snapshot (DCOpeningBalanceDate = '31-july-2026'), so a From Date earlier
    // than that would silently return a zero opening stock rather than a meaningful error.
    private static readonly DateTime MiMinFromDate = new DateTime(2026, 7, 31);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            fromDateTextBox.Text = MiMinFromDate.ToString(MiUiFmt);

            var now = DateTime.Now;
            var monthEnd = new DateTime(now.Year, now.Month, 1).AddMonths(1).AddDays(-1);
            miFromDateTextBox.Text = MiMinFromDate.ToString(MiUiFmt);
            miToDateTextBox.Text = (monthEnd < MiMinFromDate ? MiMinFromDate : monthEnd).ToString(MiUiFmt);
        }

        RenderNegativeClosingChart();
        RenderDuplicateOrderCode();
        RenderDuplicateChart(aSummaryBll.LoadRptDuplicateOrderNoInInvoiceDAL(), gv_DupOrderNoInv, dupOrderNoInvChartScript, "dupOrderNoInvChart", "OrderNo", "Duplicate Order No");
        RenderDuplicateChart(aSummaryBll.LoadRptDuplicateInvoiceNoDAL(), gv_DupInvoiceNo, dupInvoiceNoChartScript, "dupInvoiceNoChart", "InvoiceNo", "Duplicate Invoice No");
        RenderDuplicateChart(aSummaryBll.LoadRptDuplicateCustomerCodeDAL(), gv_DupCustomerCode, dupCustomerCodeChartScript, "dupCustomerCodeChart", "CustomerCode", "Duplicate Customer Code");
        RenderVatTpMismatch();
        RenderTourPlanMissingSerial();
    }

    private void RenderDuplicateOrderCode()
    {
        DataTable aDataTable = aSummaryBll.LoadRptDuplicateOrderCodeDAL();

        gv_DupOrder.DataSource = aDataTable;
        gv_DupOrder.DataBind();

        var categories = aDataTable.AsEnumerable().Select(row => row.Field<string>("OrderCode")).ToList();
        var data = aDataTable.AsEnumerable().Select(row => row.Field<int>("DuplicateCount")).ToList();

        var serializer = new JavaScriptSerializer();
        string categoriesJson = serializer.Serialize(categories);
        string dataJson = serializer.Serialize(data);

        StringBuilder script = new StringBuilder();
        script.Append("<script type=\"text/javascript\">");
        script.Append("document.addEventListener('DOMContentLoaded', function () {");
        script.Append("Highcharts.chart('dupOrderChart', {");
        script.Append("chart: { type: 'column', styledMode: true },");
        script.Append("credits: { enabled: false },");
        script.Append("title: { text: '' },");
        script.Append("xAxis: { categories: ").Append(categoriesJson).Append(", crosshair: true },");
        script.Append("yAxis: { title: { text: 'Occurrences' }, allowDecimals: false },");
        script.Append("legend: { enabled: false },");
        script.Append("series: [{ name: 'Duplicate Order Code', data: ").Append(dataJson).Append(" }]");
        script.Append("});");
        script.Append("});");
        script.Append("</script>");

        dupOrderChartScript.Text = script.ToString();
    }

    // Shared by the three "duplicate <column>" checks (Req1-3 of the same shape): bind the grid,
    // then build a column chart out of whatever two columns are named categoryField/DuplicateCount.
    private void RenderDuplicateChart(DataTable aDataTable, GridView grid, Literal chartScriptLiteral, string chartDivId, string categoryField, string seriesName)
    {
        grid.DataSource = aDataTable;
        grid.DataBind();

        var categories = aDataTable.AsEnumerable().Select(row => row[categoryField] == DBNull.Value ? "" : row[categoryField].ToString()).ToList();
        var data = aDataTable.AsEnumerable().Select(row => row.Field<int>("DuplicateCount")).ToList();

        var serializer = new JavaScriptSerializer();
        string categoriesJson = serializer.Serialize(categories);
        string dataJson = serializer.Serialize(data);

        StringBuilder script = new StringBuilder();
        script.Append("<script type=\"text/javascript\">");
        script.Append("document.addEventListener('DOMContentLoaded', function () {");
        script.Append("Highcharts.chart('").Append(chartDivId).Append("', {");
        script.Append("chart: { type: 'column', styledMode: true },");
        script.Append("credits: { enabled: false },");
        script.Append("title: { text: '' },");
        script.Append("xAxis: { categories: ").Append(categoriesJson).Append(", crosshair: true },");
        script.Append("yAxis: { title: { text: 'Occurrences' }, allowDecimals: false },");
        script.Append("legend: { enabled: false },");
        script.Append("series: [{ name: '").Append(seriesName).Append("', data: ").Append(dataJson).Append(" }]");
        script.Append("});");
        script.Append("});");
        script.Append("</script>");

        chartScriptLiteral.Text = script.ToString();
    }

    private void RenderVatTpMismatch()
    {
        DataTable aDataTable = aSummaryBll.LoadRptInvoicePaymentVatTpMismatchDAL();
        gv_VatTpMismatch.DataSource = aDataTable;
        gv_VatTpMismatch.DataBind();
    }

    private void RenderTourPlanMissingSerial()
    {
        DataTable aDataTable = aSummaryBll.LoadRptTourPlanMissingSerialDAL();
        gv_TourPlanMissingSerial.DataSource = aDataTable;
        gv_TourPlanMissingSerial.DataBind();
    }

    // sp_Get_MonthlyInventoryReportBatchWise is a heavy multi-join, cross-database proc - one call
    // for a single DC takes ~12s on this dev DB, so 14 DCs sequentially would take minutes. Loading
    // this chart's data is done async (client calls this WebMethod after the page has already
    // rendered) and the per-DC calls run in parallel to bring total wall time down to ~30-45s
    // instead of ~3 minutes, without touching the existing proc's own (already slow) logic.
    [System.Web.Services.WebMethod]
    public static string GetMiClosingChartData()
    {
        var bll = new TotalSummaryBLL();
        DataTable dcTable = bll.GetDistributionCenterListDAL();

        DateTime fromDate = MiMinFromDate;
        DateTime toDate = DateTime.Now.Date;

        var results = new System.Collections.Concurrent.ConcurrentBag<Tuple<string, decimal>>();

        System.Threading.Tasks.Parallel.ForEach(
            dcTable.AsEnumerable(),
            new System.Threading.Tasks.ParallelOptions { MaxDegreeOfParallelism = 8 },
            row =>
            {
                string comUnitId = row.Field<int>("ComUnitId").ToString();
                string comUnitName = row.Field<string>("ComUnitName");

                DataTable aDataTable = bll.LoadMonthlyInventoryReportBatchWise(fromDate, toDate, comUnitId);
                decimal totalNegative = aDataTable.AsEnumerable()
                    .Select(r => r.Field<decimal?>("ClosingStock") ?? 0)
                    .Where(v => v < 0)
                    .Sum();

                if (totalNegative < 0)
                {
                    results.Add(Tuple.Create(comUnitName, totalNegative));
                }
            });

        var ordered = results.OrderBy(t => t.Item1).ToList();

        var serializer = new JavaScriptSerializer();
        return serializer.Serialize(new
        {
            categories = ordered.Select(t => t.Item1).ToList(),
            data = ordered.Select(t => t.Item2).ToList()
        });
    }

    private void RenderNegativeClosingChart()
    {
        DataTable aDataTable = aSummaryBll.LoadRptNegativeClosingStock_DCWiseDAL();

        var categories = aDataTable.AsEnumerable().Select(row => row.Field<string>("ShortName")).ToList();
        var data = aDataTable.AsEnumerable().Select(row => row.Field<decimal>("TotalNegativeClosing")).ToList();

        var serializer = new JavaScriptSerializer();
        string categoriesJson = serializer.Serialize(categories);
        string dataJson = serializer.Serialize(data);

        StringBuilder script = new StringBuilder();
        script.Append("<script type=\"text/javascript\">");
        script.Append("document.addEventListener('DOMContentLoaded', function () {");
        script.Append("Highcharts.chart('negClosingChart', {");
        script.Append("chart: { type: 'column', styledMode: true },");
        script.Append("credits: { enabled: false },");
        script.Append("title: { text: '' },");
        script.Append("xAxis: { categories: ").Append(categoriesJson).Append(", crosshair: true },");
        script.Append("yAxis: { title: { text: 'Closing Qty' } },");
        script.Append("legend: { enabled: false },");
        script.Append("series: [{ name: 'Negative Closing', data: ").Append(dataJson).Append(" }]");
        script.Append("});");
        script.Append("});");
        script.Append("</script>");

        negClosingChartScript.Text = script.ToString();
    }

    private void DropDownlist()
    {
        try
        {
            OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
            aOtherStockActionBLL.DCLoad(dcDropDownList1);
            aOtherStockActionBLL.DCLoad(dcDropDownList2);

            OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
            aOrderInfoBll.LoadSC(salesCenterDropDownList3, Session["UserId"].ToString());
        }
        catch { }

        PopulateYearDropdown();
        PopulateMonthDropdown();
    }

    private void PopulateYearDropdown()
    {
        ddlYear.Items.Clear();
        ddlYear.Items.Add(new ListItem("Select Year", ""));

        int currentYear = DateTime.Now.Year;
        for (int i = currentYear - 10; i <= currentYear + 5; i++)
        {
            ListItem item = new ListItem(i.ToString(), i.ToString());
            if (i == currentYear)
                item.Selected = true;

            ddlYear.Items.Add(item);
        }
    }

    private void PopulateMonthDropdown()
    {
        ddlMonth.Items.Clear();
        ddlMonth.Items.Add(new ListItem("Select Month", ""));

        string[] monthNames =
        {
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        };

        int currentMonth = DateTime.Now.Month;
        for (int i = 0; i < 12; i++)
        {
            ListItem item = new ListItem(monthNames[i], (i + 1).ToString());
            if ((i + 1) == currentMonth)
                item.Selected = true;

            ddlMonth.Items.Add(item);
        }
    }

    protected void gv_DayWise_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Net Sales";
            HeaderCell.ColumnSpan = 1;
            HeaderCell.Font.Bold = true;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.BackColor = Color.DodgerBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderGridRow.Cells.Add(HeaderCell);

            gv_DayWise.Controls[0].Controls.AddAt(0, HeaderGridRow);
        }
    }

    protected void gv_DayWise_OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView drv = (DataRowView)e.Row.DataItem;
            decimal gross = Math.Round(drv["JustSalesGrossAmt"] == DBNull.Value ? 0 : Convert.ToDecimal(drv["JustSalesGrossAmt"]), 2);
            decimal sap = Math.Round(drv["SAPsendAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(drv["SAPsendAmount"]), 2);

            if (gross != sap)
            {
                e.Row.BackColor = Color.FromArgb(248, 215, 218);
            }
        }
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }

    private void LoadInfo()
    {
        gv_DayWise.DataSource = null;
        gv_DayWise.DataBind();

        if (dcDropDownList1.SelectedValue == "" || ddlYear.SelectedValue == "" || ddlMonth.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution Center, Year and Month!!");
            return;
        }

        int comUnitId = Convert.ToInt32(dcDropDownList1.SelectedValue);
        int year = Convert.ToInt32(ddlYear.SelectedValue);
        int month = Convert.ToInt32(ddlMonth.SelectedValue);

        DataTable aDataTable = aSummaryBll.LoadRptBussinessSummary_DayWiseDAL(comUnitId, year, month);

        if (aDataTable.Rows.Count > 0)
        {
            gv_DayWise.DataSource = aDataTable;
            gv_DayWise.DataBind();

            try
            {
                // FooterRow.Cells still has one cell per declared BoundField, including the
                // Visible="false" JustSalesAmtTP column (cell index 1) - it just isn't rendered.
                // So visible cells are 0=Date, 1=hidden TP, 2=Gross Amount, 3=SAP Send Amount.
                gv_DayWise.FooterRow.Cells[0].Text = "Total:";

                decimal justSalesGrossAmt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesGrossAmt") ?? 0);
                gv_DayWise.FooterRow.Cells[2].Text = justSalesGrossAmt.ToString("N2");

                decimal sapSendAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SAPsendAmount") ?? 0);
                gv_DayWise.FooterRow.Cells[3].Text = sapSendAmount.ToString("N2");

                gv_DayWise.FooterRow.BackColor = Color.Bisque;
                gv_DayWise.FooterRow.Font.Bold = true;
                gv_DayWise.FooterRow.HorizontalAlign = HorizontalAlign.Right;
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
        Response.Redirect("RptBussinessSummary_DayWise.aspx");
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (dcDropDownList1.SelectedValue == "" || ddlYear.SelectedValue == "" || ddlMonth.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution Center, Year and Month!!");
            return;
        }

        try
        {
            LoadInfo();

            if (gv_DayWise.Rows.Count == 0)
            {
                showMessageBox("No Data Found!!");
                return;
            }

            string attachment = "attachment; filename=DayWise_NetSales_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            gv_DayWise.AllowPaging = false;

            HtmlForm frm = new HtmlForm();
            gv_DayWise.Parent.Controls.Add(frm);

            gv_DayWise.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in gv_DayWise.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in gv_DayWise.Rows)
            {
                gridViewRow.BackColor = Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            gv_DayWise.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h3>" + dcDropDownList1.SelectedItem.Text + " - Day Wise Net Sales Report (" + ddlMonth.SelectedItem.Text + " " + ddlYear.SelectedItem.Text + ")</h3></span> <span style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);
            Response.Write(sw.ToString());
            Response.End();
        }
        catch
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void viewClosingStockButton_Click(object sender, EventArgs e)
    {
        LoadNegativeClosingStock();
    }

    private void LoadNegativeClosingStock()
    {
        gv_NegativeClosingStock.DataSource = null;
        gv_NegativeClosingStock.DataBind();

        if (dcDropDownList2.SelectedValue == "" || fromDateTextBox.Text.Trim() == "")
        {
            showMessageBox("Please Select Distribution Center and From Date!!");
            return;
        }

        int comUnitId = Convert.ToInt32(dcDropDownList2.SelectedValue);
        DateTime fromDate = Convert.ToDateTime(fromDateTextBox.Text.Trim());

        DataTable aDataTable = aSummaryBll.LoadRptNegativeClosingStockDAL(comUnitId, fromDate);

        if (aDataTable.Rows.Count > 0)
        {
            gv_NegativeClosingStock.DataSource = aDataTable;
            gv_NegativeClosingStock.DataBind();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void ResetClosingStock_Click(object sender, EventArgs e)
    {
        Response.Redirect("RptBussinessSummary_DayWise.aspx");
    }

    protected void btnExportClosingStockToExcel_Click(object sender, EventArgs e)
    {
        if (dcDropDownList2.SelectedValue == "" || fromDateTextBox.Text.Trim() == "")
        {
            showMessageBox("Please Select Distribution Center and From Date!!");
            return;
        }

        try
        {
            LoadNegativeClosingStock();

            if (gv_NegativeClosingStock.Rows.Count == 0)
            {
                showMessageBox("No Data Found!!");
                return;
            }

            string attachment = "attachment; filename=NegativeClosingStock_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            gv_NegativeClosingStock.AllowPaging = false;

            HtmlForm frm = new HtmlForm();
            gv_NegativeClosingStock.Parent.Controls.Add(frm);

            gv_NegativeClosingStock.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in gv_NegativeClosingStock.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in gv_NegativeClosingStock.Rows)
            {
                gridViewRow.BackColor = Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            gv_NegativeClosingStock.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h3>" + dcDropDownList2.SelectedItem.Text + " - Negative Closing Stock Report (From " + fromDateTextBox.Text + " to " + toDateTextBox.Text + ")</h3></span> <span style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);
            Response.Write(sw.ToString());
            Response.End();
        }
        catch
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void viewMonthlyInvButton_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!ValidateMonthlyInv(out fromDate, out toDate))
            return;

        LoadMonthlyInv(fromDate, toDate);
    }

    private bool ValidateMonthlyInv(out DateTime fromDate, out DateTime toDate)
    {
        fromDate = DateTime.MinValue;
        toDate = DateTime.MinValue;

        if (string.IsNullOrEmpty(salesCenterDropDownList3.SelectedValue))
        {
            showMessageBox("Distribution Center is required.");
            return false;
        }

        if (string.IsNullOrEmpty(miFromDateTextBox.Text) || !DateTime.TryParse(miFromDateTextBox.Text.Trim(), out fromDate))
        {
            showMessageBox("From Date is required.");
            return false;
        }

        if (fromDate < MiMinFromDate)
        {
            showMessageBox("From Date cannot be earlier than " + MiMinFromDate.ToString(MiUiFmt) + ".");
            return false;
        }

        if (string.IsNullOrEmpty(miToDateTextBox.Text) || !DateTime.TryParse(miToDateTextBox.Text.Trim(), out toDate))
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

    private void LoadMonthlyInv(DateTime fromDate, DateTime toDate)
    {
        DataTable aDataTable = aSummaryBll.LoadMonthlyInventoryReportBatchWise(fromDate, toDate, salesCenterDropDownList3.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            loadGridView3.DataSource = aDataTable;
            loadGridView3.DataBind();
        }
        else
        {
            showMessageBox("No Data Found!!");
            loadGridView3.DataSource = null;
            loadGridView3.DataBind();
        }
    }

    protected void ResetMonthlyInv_Click(object sender, EventArgs e)
    {
        Response.Redirect("RptBussinessSummary_DayWise.aspx");
    }

    protected void btnExportMonthlyInvToExcel_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!ValidateMonthlyInv(out fromDate, out toDate))
            return;

        LoadMonthlyInv(fromDate, toDate);

        if (loadGridView3.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Monthly_Inventory_Report_BatchWise_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView3.AllowPaging = false;

            HtmlForm frm = new HtmlForm();
            loadGridView3.Parent.Controls.Add(frm);

            loadGridView3.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in loadGridView3.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in loadGridView3.Rows)
            {
                gridViewRow.BackColor = Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            loadGridView3.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h3>Monthly Inventory Report (Batch Wise) (From " + miFromDateTextBox.Text + " to " + miToDateTextBox.Text + ")</h3></span> <span style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

    protected void btnExportDupOrderToExcel_Click(object sender, EventArgs e)
    {
        RenderDuplicateOrderCode();
        ExportGridToExcel(gv_DupOrder, "Duplicate_Order_Code", "Duplicate Order Number Check");
    }

    protected void btnExportDupOrderNoInvToExcel_Click(object sender, EventArgs e)
    {
        RenderDuplicateChart(aSummaryBll.LoadRptDuplicateOrderNoInInvoiceDAL(), gv_DupOrderNoInv, dupOrderNoInvChartScript, "dupOrderNoInvChart", "OrderNo", "Duplicate Order No");
        ExportGridToExcel(gv_DupOrderNoInv, "Duplicate_OrderNo_Invoice", "Duplicate Order No in Invoice");
    }

    protected void btnExportDupInvoiceNoToExcel_Click(object sender, EventArgs e)
    {
        RenderDuplicateChart(aSummaryBll.LoadRptDuplicateInvoiceNoDAL(), gv_DupInvoiceNo, dupInvoiceNoChartScript, "dupInvoiceNoChart", "InvoiceNo", "Duplicate Invoice No");
        ExportGridToExcel(gv_DupInvoiceNo, "Duplicate_InvoiceNo", "Duplicate Invoice No");
    }

    protected void btnExportDupCustomerCodeToExcel_Click(object sender, EventArgs e)
    {
        RenderDuplicateChart(aSummaryBll.LoadRptDuplicateCustomerCodeDAL(), gv_DupCustomerCode, dupCustomerCodeChartScript, "dupCustomerCodeChart", "CustomerCode", "Duplicate Customer Code");
        ExportGridToExcel(gv_DupCustomerCode, "Duplicate_Customer_Code", "Duplicate Customer Code");
    }

    protected void btnExportVatTpMismatchToExcel_Click(object sender, EventArgs e)
    {
        RenderVatTpMismatch();
        ExportGridToExcel(gv_VatTpMismatch, "Invoice_Payment_VatTp_Mismatch", "Invoice Payment VAT/TP Mismatch");
    }

    protected void btnExportTourPlanToExcel_Click(object sender, EventArgs e)
    {
        RenderTourPlanMissingSerial();
        ExportGridToExcel(gv_TourPlanMissingSerial, "TourPlan_Missing_Serial", "Tour Plan Missing Serial (Today)");
    }

    protected void btnFixTourPlanSerial_Click(object sender, EventArgs e)
    {
        int updatedRows = aSummaryBll.FixTourPlanMissingSerialDAL();
        RenderTourPlanMissingSerial();
        showMessageBox(updatedRows > 0 ? updatedRows + " tour plan row(s) updated to Serial No = 1." : "Nothing to fix - no missing serial found.");
    }

    // Shared by every "Export to Excel" button on this page - each caller re-binds its own grid
    // with fresh data first, then hands it here to render/stream as .xls, matching the existing
    // GridView-outside-a-form workaround (see VerifyRenderingInServerForm below).
    private void ExportGridToExcel(GridView grid, string filenamePrefix, string title)
    {
        if (grid.Rows.Count == 0)
        {
            showMessageBox("No Data Found!!");
            return;
        }

        try
        {
            string attachment = "attachment; filename=" + filenamePrefix + "_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            grid.AllowPaging = false;

            HtmlForm frm = new HtmlForm();
            grid.Parent.Controls.Add(frm);

            grid.HeaderRow.Style.Add("background-color", "#E5EEF1");
            foreach (TableCell tableCell in grid.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            foreach (GridViewRow gridViewRow in grid.Rows)
            {
                gridViewRow.BackColor = Color.White;
                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";
                }
            }

            grid.RenderControl(htw);

            string headerTable = @"<span style='text-align:center'><h3>" + title + "</h3></span> <span style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

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
