using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_UI_TotalSummary : System.Web.UI.Page
{
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();
    CmnCrystaltoView aDal = new CmnCrystaltoView();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
        }
    }
    public void DropDownlist()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
        salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();
            
            //aDataTable = aSummaryBll.LoadSummaryBLL(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));


            aDataTable = aDal.BusinessSummaryReportDAl(Convert.ToDateTime(fromDateTextBox.Text.Trim()), Convert.ToDateTime(toDateTextBox.Text.Trim()));
            if (aDataTable.Rows.Count>0)
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();

                decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                loadGridView.FooterRow.Cells[1].Text = "Total";
                loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                loadGridView.FooterRow.Cells[2].Text = total.ToString();

                decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetProformaAmount") == null ? 0 : row.Field<decimal>("SumofNetProformaAmount"));
                
                loadGridView.FooterRow.Cells[3].Text = total2.ToString("N2");


                decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ProTpVat") == null ? 0 : row.Field<decimal>("ProTpVat"));

                loadGridView.FooterRow.Cells[4].Text = total3.ToString("N2");


                decimal total4 = aDataTable.AsEnumerable().Sum(  row => row.Field<int?>("NumberofInvoiceSold") == null ? 0 : row.Field<int>("NumberofInvoiceSold"));
              
                loadGridView.FooterRow.Cells[5].Text = total4.ToString();

                decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetSalesAmount") == null ? 0 : row.Field<decimal>("SumofNetSalesAmount"));
               
                loadGridView.FooterRow.Cells[6].Text = total5.ToString("N2");


                decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelTpVat") == null ? 0 : row.Field<decimal>("DelTpVat"));

                loadGridView.FooterRow.Cells[7].Text = total6.ToString("N2");

                decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofReturnInvoice") == null ? 0 : row.Field<int>("NumberofReturnInvoice"));
                
                loadGridView.FooterRow.Cells[8].Text = total7.ToString();

                decimal total8 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SumofNetReturnAmount") == null ? 0 : row.Field<decimal>("SumofNetReturnAmount"));
               
                loadGridView.FooterRow.Cells[9].Text = total8.ToString("N2");

                decimal total9 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("DelReTpVat") == null ? 0 : row.Field<decimal>("DelReTpVat"));

                loadGridView.FooterRow.Cells[10].Text = total9.ToString("N2");
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

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("totalsummary.aspx");
    }
}