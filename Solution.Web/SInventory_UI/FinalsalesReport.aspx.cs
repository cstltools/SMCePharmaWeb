using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_FinalsalesReport : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("FinalsalesReport.aspx");
    }
    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            //GridView HeaderGrid = (GridView)sender;
            //GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            //TableCell HeaderCell = new TableCell();

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            //HeaderCell.ColumnSpan = 0;
            //HeaderGridRow.Cells.Add(HeaderCell);

            ////HeaderCell = new TableCell();
            ////HeaderCell.Text = " ";
            ////HeaderCell.BackColor = Color.FromName("#F5F5F5");
            ////HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            ////HeaderCell.ColumnSpan = 1;

            ////HeaderGridRow.Cells.Add(HeaderCell);



            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Invoice";
            //HeaderCell.ColumnSpan = 4;
            //HeaderCell.BackColor = Color.DeepSkyBlue;
            //HeaderGridRow.Cells.Add(HeaderCell);


            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Return";
            //HeaderCell.ColumnSpan = 3;
            //HeaderCell.BackColor = Color.Red;
            //HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Sales";
            //HeaderCell.BackColor = Color.GreenYellow;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);



            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Collection";
            //HeaderCell.BackColor = Color.LightSeaGreen;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);


            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Receivable";
            //HeaderCell.BackColor = Color.Yellow;
            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);



            //loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

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

            aDataTable = aSummaryBll.FinalSales(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));
            if (aDataTable.Rows.Count > 0)
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();

                DataTable aDataTable2 = aSummaryBll.FinalSales2(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));



                BSPCustomerTextBox.Text = aDataTable2.Rows[0]["BSPCustomer"].ToString();
                BSPInvoiceTextBox1.Text = aDataTable2.Rows[0]["BSPInvoice"].ToString();
                GreencustomerTextBox2.Text = aDataTable2.Rows[0]["Greencustomer"].ToString();
                GreenInvoiceTextBox3.Text = aDataTable2.Rows[0]["GreenInvoice"].ToString();
                OthercustomerTextBox4.Text = aDataTable2.Rows[0]["Othercustomer"].ToString();
                OtherInvoiceTextBox5.Text = aDataTable2.Rows[0]["OtherInvoice"].ToString();

                txtBlueStar_P.Text = aDataTable2.Rows[0]["P_BlueStar"].ToString();
                txtGreenStar_P.Text = aDataTable2.Rows[0]["P_GreenStar"].ToString();
                txtPinkStar_P.Text = aDataTable2.Rows[0]["P_PinkStar"].ToString();
                txtOther_P.Text = aDataTable2.Rows[0]["P_OtherStar"].ToString();


                txtBlueStar_DCR.Text = aDataTable2.Rows[0]["D_BlueStar"].ToString();
                txtGreenStar_DCR.Text = aDataTable2.Rows[0]["D_GreenStar"].ToString();
                txtPinkStar_DCR.Text = aDataTable2.Rows[0]["D_PinkStar"].ToString();
                txtOtherStar_DCR.Text = aDataTable2.Rows[0]["D_OtherStar"].ToString();


                decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("BSP2019") == null ? 0 : row.Field<decimal>("BSP2019"));
                loadGridView.FooterRow.Cells[0].Text = "Total";
                loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                loadGridView.FooterRow.Cells[1].Text = Math.Round(total).ToString("#,##0");

                decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Green2019") == null ? 0 : row.Field<decimal>("Green2019"));

                loadGridView.FooterRow.Cells[2].Text = Math.Round(total2).ToString("#,##0");

                decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("OTHER2019") == null ? 0 : row.Field<decimal>("OTHER2019"));

                loadGridView.FooterRow.Cells[3].Text = Math.Round(total3).ToString("#,##0");


                //decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                //loadGridView.FooterRow.Cells[5].Text = Math.Round(total3).ToString("#,##0");


                //decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetInvoiceAmt") == null ? 0 : row.Field<decimal>("NetInvoiceAmt"));

                //loadGridView.FooterRow.Cells[6].Text = Math.Round(total4).ToString("#,##0");


                //decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));

                //loadGridView.FooterRow.Cells[8].Text = Math.Round(total5).ToString("#,##0");


                //decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                //loadGridView.FooterRow.Cells[9].Text = Math.Round(total6).ToString("#,##0");

                //decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetReturnAmt") == null ? 0 : row.Field<decimal>("NetReturnAmt"));

                //loadGridView.FooterRow.Cells[10].Text = Math.Round(total7).ToString("#,##0");

                //decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                //loadGridView.FooterRow.Cells[11].Text = Math.Round(total8).ToString("#,##0");

                //decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                //loadGridView.FooterRow.Cells[12].Text = Math.Round(total9).ToString("#,##0");

                //decimal total10 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                //loadGridView.FooterRow.Cells[13].Text = Math.Round(total10).ToString("#,##0");


                //decimal total11 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));

                //loadGridView.FooterRow.Cells[15].Text = Math.Round(total11).ToString("#,##0");

                //decimal total12 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                //loadGridView.FooterRow.Cells[16].Text = Math.Round(total12).ToString("#,##0");

                //decimal total13 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetSalesAmt") == null ? 0 : row.Field<decimal>("NetSalesAmt"));

                //loadGridView.FooterRow.Cells[17].Text = Math.Round(total13).ToString("#,##0");



                //decimal total14 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding1") == null ? 0 : row.Field<decimal>("Outstanding1"));

                //loadGridView.FooterRow.Cells[19].Text = Math.Round(total14).ToString("#,##0");

                //decimal total15 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("Outstanding2") == null ? 0 : row.Field<decimal>("Outstanding2"));

                //loadGridView.FooterRow.Cells[20].Text = Math.Round(total15).ToString("#,##0");

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
            string attachment = "attachment; filename=Final Sales Report" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt")+".xls";
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
           
            string headerTable = @"<span  style='text-align:center'><h3>  Final Sales Report   (Date Range : " + fromDateTextBox.Text + "- " + toDateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";
            HttpContext.Current.Response.Write(headerTable);
  
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }

}