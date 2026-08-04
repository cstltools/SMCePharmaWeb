using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class SInventory_UI_DepositSlipReport : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    private static readonly string UiFmt = "dd MMMM, yyyy";
    private static readonly CultureInfo UiCulture = CultureInfo.InvariantCulture;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            var now = DateTime.Now;
            var start = new DateTime(now.Year, now.Month, 1);
            var end = start.AddMonths(1).AddDays(-1);

            fromDateTextBox.Text = start.ToString(UiFmt, UiCulture);
            toDateTextBox.Text = end.ToString(UiFmt, UiCulture);
            DropDownlist();
            
            if (Session["RoleTypeName"] != null && Session["RoleTypeName"].ToString() == "DIC")
            {
                if (Session["ComUnitId"] != null)
                {
                    salesCenterDropDownList.SelectedValue = Session["ComUnitId"].ToString();
                }
                salesCenterDropDownList.Enabled = false;
            }
        }
    }
    private static readonly string[] UiFmts = new[]
{
    "d MMMM, yyyy",   // 1 September, 2025
    "dd MMMM, yyyy",  // 01 September, 2025
    "d MMMM yyyy",    // 1 September 2025
    "dd MMMM yyyy"    // 01 September 2025
};

    // Update TryParseUi:
    private static bool TryParseUi(string s, out DateTime dt)
    {
        if (s != null) s = s.Trim();
        return DateTime.TryParseExact(s, UiFmts, UiCulture, DateTimeStyles.None, out dt);
    }

    /// <summary>
    /// Forces full month range based on the FROM date's month.
    /// Reflects snapped values back to the UI.
    /// </summary>
    private bool EnforceFullMonth(out DateTime fromDate, out DateTime toDate)
    {
        fromDate = DateTime.MinValue;
        toDate = DateTime.MinValue;

        DateTime from, to;
        if (!TryParseUi(fromDateTextBox.Text, out from))
        {
            ShowToastr("Invalid From Date. Use format: " + UiFmt, "Error");
            return false;
        }
        if (!TryParseUi(toDateTextBox.Text, out to))
        {
            ShowToastr("Invalid To Date. Use format: " + UiFmt, "Error");
            return false;
        }

        // Snap to full month of FROM
        DateTime monthStart = new DateTime(from.Year, from.Month, 1);
        DateTime monthEnd = monthStart.AddMonths(1).AddDays(-1);

        fromDate = monthStart;
        toDate = monthEnd;

        // Reflect back to UI
        fromDateTextBox.Text = monthStart.ToString(UiFmt, UiCulture);
        toDateTextBox.Text = monthEnd.ToString(UiFmt, UiCulture);

        return true;
    }

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(fromDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }

    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 0;
            HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            //HeaderCell.ColumnSpan = 1;

            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Opening Receivable";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.IndianRed;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Current Period Sales";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Collection from Sales";
            HeaderCell.BackColor = Color.PowderBlue;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Deposit";
            HeaderCell.BackColor = Color.LightSeaGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Closing Receivable";
            HeaderCell.BackColor = Color.Yellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }
    public void DropDownlist()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
        aOrderInfoBll.LoadTerritory(territoryDropDownList, Session["UserId"].ToString());
        aOrderInfoBll.LoadZone(zoneDropDownList, Session["UserId"].ToString());
        // salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }
    protected void btnProcessOpeningBalance_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!EnforceFullMonth(out fromDate, out toDate)) return;

        // TODO: use fromDate/toDate in your DAL calls
        // aDal.RunReport(fromDate, toDate);

        ShowToastr("Date range set to full month.", "Success");
        ProcessOpening();
    }
    private void ShowToastr(string message, string title)
    {
        string type = "info";
        if (string.Equals(title, "Error", StringComparison.OrdinalIgnoreCase)) type = "error";
        else if (string.Equals(title, "Success", StringComparison.OrdinalIgnoreCase)) type = "success";

        string script = string.Format("toastr.{0}('{1}','{2}');", type, EscapeJs(message), EscapeJs(title));
        ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
    }

    // Minimal JS-escape for quotes/newlines
    private static string EscapeJs(string s)
    {
        if (s == null) return "";
        return s.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\r", "").Replace("\n", "\\n");
    }
    private void ProcessOpening()
    {
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {


            try
            {
                string comUnitId = salesCenterDropDownList.SelectedValue != "0" && !string.IsNullOrEmpty(salesCenterDropDownList.SelectedValue) ? salesCenterDropDownList.SelectedValue : null;
                int aDataTable = aSummaryBll.LoadDepositSlipSummaryProcess(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), comUnitId);
            }
            catch
            {

            }
        }
    }
    private void LoadInfo()
    {
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            ProcessOpening();
            DataTable aDataTable = new DataTable();

            try
            {
                string comUnitId = salesCenterDropDownList.SelectedValue != "0" && !string.IsNullOrEmpty(salesCenterDropDownList.SelectedValue) ? salesCenterDropDownList.SelectedValue : null;
                aDataTable = aSummaryBll.LoadDepositSlipSummary(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()), comUnitId);
                if (aDataTable.Rows.Count > 0)
                {
                    loadGridView.DataSource = aDataTable;
                    loadGridView.DataBind();


                    loadGridView.FooterRow.Cells[1].Text = "Total";
                    loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;

                    decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CashinHand") == null ? 0 : row.Field<decimal>("CashinHand"));
                    loadGridView.FooterRow.Cells[2].Text = Math.Round(total).ToString();

                    decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("MArketOutStanding") == null ? 0 : row.Field<decimal>("MArketOutStanding"));

                    loadGridView.FooterRow.Cells[3].Text = Math.Round(total2).ToString("#,##0");


                    decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalOpeningReceivable") == null ? 0 : row.Field<decimal>("TotalOpeningReceivable"));

                    loadGridView.FooterRow.Cells[4].Text = Math.Round(total3).ToString("#,##0");




                    decimal JustSalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesAmtTP") == null ? 0 : row.Field<decimal>("JustSalesAmtTP"));

                    loadGridView.FooterRow.Cells[5].Text = Math.Round(JustSalesAmtTP).ToString("#,##0");


                    decimal JustSalesVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesVat") == null ? 0 : row.Field<decimal>("JustSalesVat"));

                    loadGridView.FooterRow.Cells[6].Text = Math.Round(JustSalesVat).ToString("#,##0");


                    decimal JustSalesTotal = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesTotal") == null ? 0 : row.Field<decimal>("JustSalesTotal"));

                    loadGridView.FooterRow.Cells[7].Text = Math.Round(JustSalesTotal).ToString("#,##0");

                    decimal CurrentPeriodSales = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CurrentPeriodSales") == null ? 0 : row.Field<decimal>("CurrentPeriodSales"));

                    loadGridView.FooterRow.Cells[8].Text = Math.Round(CurrentPeriodSales).ToString("#,##0");



                    decimal PriorPeriodSales = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("PriorPeriodSales") == null ? 0 : row.Field<decimal>("PriorPeriodSales"));

                    loadGridView.FooterRow.Cells[9].Text = Math.Round(PriorPeriodSales).ToString("#,##0");


                    decimal TotalCollection = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalCollection") == null ? 0 : row.Field<decimal>("TotalCollection"));

                    loadGridView.FooterRow.Cells[10].Text = Math.Round(TotalCollection).ToString("#,##0");

                    decimal BankDeposit = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("BankDeposit") == null ? 0 : row.Field<decimal>("BankDeposit"));

                    loadGridView.FooterRow.Cells[11].Text = Math.Round(BankDeposit).ToString("#,##0");


                    decimal AIT = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("AIT") == null ? 0 : row.Field<decimal>("AIT"));

                    loadGridView.FooterRow.Cells[12].Text = Math.Round(AIT).ToString("#,##0");

                    decimal totalDeposit = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("totalDeposit") == null ? 0 : row.Field<decimal>("totalDeposit"));

                    loadGridView.FooterRow.Cells[13].Text = Math.Round(totalDeposit).ToString("#,##0");

                    decimal ClosingCashinHand = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingCashinHand") == null ? 0 : row.Field<decimal>("ClosingCashinHand"));

                    loadGridView.FooterRow.Cells[14].Text = Math.Round(ClosingCashinHand).ToString("#,##0");



                    decimal ClosingMarketOutstanding = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingMarketOutstanding") == null ? 0 : row.Field<decimal>("ClosingMarketOutstanding"));

                    loadGridView.FooterRow.Cells[15].Text = Math.Round(ClosingMarketOutstanding).ToString("#,##0");

                    decimal ClosingTotalReceivable = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingTotalReceivable") == null ? 0 : row.Field<decimal>("ClosingTotalReceivable"));

                    loadGridView.FooterRow.Cells[16].Text = Math.Round(ClosingTotalReceivable).ToString("#,##0");


                    loadGridView.FooterRow.BackColor = System.Drawing.Color.Bisque;
                    loadGridView.FooterRow.Font.Bold = true;
                    loadGridView.FooterRow.HorizontalAlign = HorizontalAlign.Right;
                    //decimal total16 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding3") == null ? 0 : row.Field<decimal>("Outstanding3"));

                    //loadGridView.FooterRow.Cells[21].Text = (Math.Round((total16)).ToString("#,##0"));
                }
                else
                {
                    showMessageBox("No Data Found!!");
                    loadGridView.DataSource = null;
                    loadGridView.DataBind();
                }

            }
            catch (Exception)
            {

                //  throw;
            }

        }
        else
        {
            showMessageBox("Please Select Date Range!!");
        }
    }


    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void excelButton1_Click(object sender, EventArgs e)
    {
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            string fromDate = fromDateTextBox.Text;
            string toDate = toDateTextBox.Text;

            string url = "../SInventory_RPTVIEW/BusinessSummaryViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        else
        {
            showMessageBox("Please Select Date Range!!");
        }

    }
    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {

    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadInfo();
    }
    protected void rptTypeDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (rptTypeDropDownList.SelectedValue == "BranchWise")
        //{

        //}

        //else if ()
        //{

        //}

        //else
        //{

        //}
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Pharma_Sales_Collection_Deposition_Statement_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;



            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;

            this.LoadInfo();

            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in loadGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }



            loadGridView.RenderControl(htw);
            string headerTable = @"<span  style='text-align:center'><h4> SMC Enterprise Limited</h4>
</span> <span   style='text-align:center'>
   <h4>Pharma Sales, Collection & Deposition Statement Report 	</h4>

</span>
 ";

            string SubTi = @"<span  style='text-align:center'>
<h5>Between: " + fromDateTextBox.Text + toDateTextBox.Text + "   Reporting Date: " + DateTime.Now.ToString("dd-MMM-yyyy") + "</h5>  </span>";

            HttpContext.Current.Response.Write(headerTable);
            HttpContext.Current.Response.Write(SubTi);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }
    //protected void btnExportToExcel_Click(object sender, EventArgs e)
    //{
    //    if (loadGridView.Rows.Count > 0)
    //    {
    //        Response.Clear();
    //        Response.Buffer = true;
    //        Response.AddHeader("content-disposition", "attachment;filename=Pharma_Sales_Collection_Deposition_Statement_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
    //        Response.Charset = "";
    //        Response.ContentType = "text/csv";
    //        Response.ContentEncoding = Encoding.Default;
    //        //To Export all pages.
    //        loadGridView.AllowPaging = false;
    //        this.LoadInfo();

    //        StringBuilder sb = new StringBuilder();
    //        foreach (TableCell cell in loadGridView.HeaderRow.Cells)
    //        {
    //            //Append data with separator.
    //            sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
    //        }
    //        //Append new line character.
    //        sb.Append("\r\n");

    //        foreach (GridViewRow row in loadGridView.Rows)
    //        {
    //            foreach (TableCell cell in row.Cells)
    //            {
    //                //Append data with separator.
    //                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
    //            }
    //            //Append new line character.
    //            sb.Append("\r\n");
    //        }

    //        Response.Output.Write(sb.ToString());
    //        Response.Flush();
    //        Response.End();
    //    }
    //    else
    //    {
    //        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

    //    }

    //}


    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("DepositSlipReport.aspx");
    }
}