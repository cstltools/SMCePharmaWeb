using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_SalesReturnReportSAP : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            DropDownlist();
        }
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

    private void LoadInfo()
    {
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();

            try
            {
                aDataTable = aSummaryBll.LoadSalesReturnReportSAP(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));
                if (aDataTable.Rows.Count > 0)
                {
                    loadGridView.DataSource = aDataTable;
                    loadGridView.DataBind();

                  
                    //loadGridView.FooterRow.Cells[1].Text = "Total";
                    //loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;

                    //decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CashinHand") == null ? 0 : row.Field<decimal>("CashinHand"));
                    //loadGridView.FooterRow.Cells[2].Text = Math.Round(total).ToString();

                    //decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("MArketOutStanding") == null ? 0 : row.Field<decimal>("MArketOutStanding"));

                    //loadGridView.FooterRow.Cells[3].Text = Math.Round(total2).ToString("#,##0");


                    //decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalOpeningReceivable") == null ? 0 : row.Field<decimal>("TotalOpeningReceivable"));

                    //loadGridView.FooterRow.Cells[4].Text = Math.Round(total3).ToString("#,##0");




                    //decimal JustSalesAmtTP = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesAmtTP") == null ? 0 : row.Field<decimal>("JustSalesAmtTP"));

                    //loadGridView.FooterRow.Cells[5].Text = Math.Round(JustSalesAmtTP).ToString("#,##0");


                    //decimal JustSalesVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesVat") == null ? 0 : row.Field<decimal>("JustSalesVat"));

                    //loadGridView.FooterRow.Cells[6].Text = Math.Round(JustSalesVat).ToString("#,##0");


                    //decimal JustSalesTotal = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("JustSalesTotal") == null ? 0 : row.Field<decimal>("JustSalesTotal"));

                    //loadGridView.FooterRow.Cells[7].Text = Math.Round(JustSalesTotal).ToString("#,##0");

                    //decimal CurrentPeriodSales = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CurrentPeriodSales") == null ? 0 : row.Field<decimal>("CurrentPeriodSales"));

                    //loadGridView.FooterRow.Cells[8].Text = Math.Round(CurrentPeriodSales).ToString("#,##0");



                    //decimal PriorPeriodSales = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("PriorPeriodSales") == null ? 0 : row.Field<decimal>("PriorPeriodSales"));

                    //loadGridView.FooterRow.Cells[9].Text = Math.Round(PriorPeriodSales).ToString("#,##0");


                    //decimal TotalCollection = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalCollection") == null ? 0 : row.Field<decimal>("TotalCollection"));

                    //loadGridView.FooterRow.Cells[10].Text = Math.Round(TotalCollection).ToString("#,##0");

                    //decimal BankDeposit = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("BankDeposit") == null ? 0 : row.Field<decimal>("BankDeposit"));

                    //loadGridView.FooterRow.Cells[11].Text = Math.Round(BankDeposit).ToString("#,##0");


                    //decimal AIT = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("AIT") == null ? 0 : row.Field<decimal>("AIT"));

                    //loadGridView.FooterRow.Cells[12].Text = Math.Round(AIT).ToString("#,##0");

                    //decimal totalDeposit = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("totalDeposit") == null ? 0 : row.Field<decimal>("totalDeposit"));

                    //loadGridView.FooterRow.Cells[13].Text = Math.Round(totalDeposit).ToString("#,##0");

                    //decimal ClosingCashinHand = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingCashinHand") == null ? 0 : row.Field<decimal>("ClosingCashinHand"));

                    //loadGridView.FooterRow.Cells[14].Text = Math.Round(ClosingCashinHand).ToString("#,##0");



                    //decimal ClosingMarketOutstanding = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingMarketOutstanding") == null ? 0 : row.Field<decimal>("ClosingMarketOutstanding"));

                    //loadGridView.FooterRow.Cells[15].Text = Math.Round(ClosingMarketOutstanding).ToString("#,##0");

                    //decimal ClosingTotalReceivable = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingTotalReceivable") == null ? 0 : row.Field<decimal>("ClosingTotalReceivable"));

                    //loadGridView.FooterRow.Cells[16].Text = Math.Round(ClosingTotalReceivable).ToString("#,##0");


                    //loadGridView.FooterRow.BackColor = System.Drawing.Color.Bisque;
                    //loadGridView.FooterRow.Font.Bold = true;
                    //loadGridView.FooterRow.HorizontalAlign = HorizontalAlign.Right;
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
            string attachment = "attachment; filename=Sales Return Report (SAP)_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt")+".xls";
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
   <h4>Sales Return Report (SAP) 	</h4>

</span>
 ";

            string SubTi = @"<span  style='text-align:center'>
<h5>Between: " + fromDateTextBox.Text +   toDateTextBox.Text + "   Reporting Date: "+DateTime.Now.ToString("dd-MMM-yyyy") + "</h5>  </span>";

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
        Response.Redirect("SalesReturnReportSAP.aspx");
    }
}