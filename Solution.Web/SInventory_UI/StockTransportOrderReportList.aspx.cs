using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_StockTransportOrderReportList : System.Web.UI.Page
{
    DataTable aTable = new DataTable();
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void searchButton_Click(object sender, EventArgs e)
    {
        if (dateTextBox.Text!="")
        {
            aTable = aRequisitionBll.StockTransportOrderGridDataBLL(Convert.ToDateTime(dateTextBox.Text.Trim()));
            if (aTable.Rows.Count>0)
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                reportListGridView.DataSource = aTable;
                reportListGridView.DataBind();
            }
            else
            {

                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!");
            }

            
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void printButton_Click(object sender, EventArgs e)
    {
        int iRowIndex = (((Button)sender).Parent.Parent as GridViewRow).RowIndex;
        string reqId = reportListGridView.DataKeys[iRowIndex][0].ToString();

        string url = "../SInventory_RPTVIEW/StockTransfarOrderReportViewer.aspx?reqId=" + reqId;
       // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
}