using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_MonthlyWarehouseReportCW : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");

        }
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        ReportPopUp();
    }


    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void ReportPopUp()
    {

        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            string fromDate = fromDateTextBox.Text;
            string toDate = toDateTextBox.Text;

            string url = "../SInventory_RPTVIEW/CWMonthlyInventoryReport.aspx?fromDate=" + fromDate + "&toDate=" +
                         toDate;
            string fullURL =
                "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url +
                "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof (string), "OPEN_WINDOW", fullURL, true);
        }
        else
        {
        
        ShowMessageBox("Please Select date range!!!");}



    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("MonthlyWarehouseReportCW.aspx");
    }
}