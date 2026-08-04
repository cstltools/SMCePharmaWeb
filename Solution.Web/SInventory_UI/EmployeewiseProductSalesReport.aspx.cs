using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_EmployeewiseProductSalesReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        const string reportType = "CRP";
        PopUpMonitoringReport(reportType);
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        const string reportType = "excel";
        PopUpMonitoringReport(reportType);
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void PopUpMonitoringReport(string rptType)
    {
        string url = "../SInventory_RPTVIEW/EmployeewiseProductSalesReportViewer.aspx?rptType=" + rptType;
        string fullURL ="var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url +
            "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
}