using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_WhOpeningStockReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }

    protected void viewRptButton_OnClick(object sender, EventArgs e)
    {
        if (stockViewDateTextBox.Text != "")
        {
            PopUpWhOpeningStockReport();
        }
        else
        {
            ShowMessageBox("Please enter a Date!!");
        }
    }

    private void PopUpWhOpeningStockReport()
    {
        
        string url = "../SInventory_RPTVIEW/WhOpeningStockReportViewer.aspx?Date=" + stockViewDateTextBox.Text.Trim();
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}