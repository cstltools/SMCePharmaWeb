using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_WhStockMonitoringReport : System.Web.UI.Page
{
    WhStockMonitoringReportBll aMonitoringReportBll  = new WhStockMonitoringReportBll();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadWhStokMonitoringInfo();
    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }


    protected void cancelButton_Click(object sender, EventArgs e)
    {

    }
    private void LoadWhStokMonitoringInfo()
    {
        if (Validation())
        {
            DataTable aDataTable = new DataTable();


            DateTime fromDate = Convert.ToDateTime(fromDateTextBox.Text);
            DateTime toDate = Convert.ToDateTime(toDateTextBox.Text);

            if (fromDate == DateTime.Parse("10/01/2018"))
            {
                fromDate=  fromDate.AddDays(1);
            }

            aDataTable = aMonitoringReportBll.LoadWhStokMonitoringInformation(fromDate, toDate);
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();

            decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("OpeningStockQty") == null ? 0 : row.Field<decimal>("OpeningStockQty"));

            loadGridView.FooterRow.Cells[2].Text = "Total";
            loadGridView.FooterRow.Cells[2].HorizontalAlign = HorizontalAlign.Right;
            loadGridView.FooterRow.Cells[3].Text = total.ToString("N2");



            decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("OpAmount") == null ? 0 : row.Field<decimal>("OpAmount"));

            loadGridView.FooterRow.Cells[4].Text = total2.ToString("N2");

            decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("StockInQty") == null ? 0 : row.Field<decimal>("StockInQty"));

            loadGridView.FooterRow.Cells[5].Text = total3.ToString();

            decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("IssueQty") == null ? 0 : row.Field<decimal>("IssueQty"));

            loadGridView.FooterRow.Cells[6].Text = total4.ToString();

            decimal total5 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("saleQty") == null ? 0 : row.Field<decimal>("saleQty"));

            loadGridView.FooterRow.Cells[7].Text = total5.ToString();

            decimal total6 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("saleAmount") == null ? 0 : row.Field<decimal>("saleAmount"));

            loadGridView.FooterRow.Cells[8].Text = total6.ToString("N2");

            decimal total7 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ClosingBal") == null ? 0 : row.Field<decimal>("ClosingBal"));

            loadGridView.FooterRow.Cells[9].Text = total7.ToString("N2");
        }
    }

    private bool Validation()
    {
        if (fromDateTextBox.Text == "")
        {
            ShowMessageBox("Please select from date!!!");
            return false;
        }

        if (toDateTextBox.Text == "")
        {
            ShowMessageBox("Please select to date!!!");
            return false;
        }

        return true;
    }

    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void excelButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            string fromDate = fromDateTextBox.Text;
            string toDate = toDateTextBox.Text;

            string url = "../SInventory_RPTVIEW/WhStockMonitoringReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }
}