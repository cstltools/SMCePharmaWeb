using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_DayWiseBusinessReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
          
        }
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (yearDropDownList.SelectedIndex == 0)
        {
            ShowMessageBox("Please select a year!!!");
            return false;
        }
        if (monthDropDownList.SelectedIndex == 0)
        {
            ShowMessageBox("Please select a month!!!");
            return false;
        }     

        return true;
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {

        if (Validation())
        {
            string fromDate = GenerateFromDate(monthDropDownList.SelectedValue,yearDropDownList.SelectedValue);
            string toDate = GenerateToDate(monthDropDownList.SelectedValue, yearDropDownList.SelectedValue);
            const string reportType = "CRP";

            PopUpTrendReport(fromDate, toDate, reportType);
        }

    }



    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (yearDropDownList.SelectedIndex == 0)
        {
            string fromDate = GenerateFromDate(monthDropDownList.SelectedValue, yearDropDownList.SelectedValue);
            string toDate = GenerateToDate(monthDropDownList.SelectedValue, yearDropDownList.SelectedValue);
            const string reportType = "excel";

            PopUpTrendReport(fromDate, toDate, reportType);
        }
        else
        {
            ShowMessageBox("Please select a year!!!");
        }
    }

    private void PopUpTrendReport(string fromDate, string toDate, string reportType)
    {
        string url = "../SInventory_RPTVIEW/DayWiseBusinessReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&rptType=" + reportType; ;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    
    private string GenerateFromDate(string month, string year)
    {
        string fromDate = "01-" + month + "-" + year;
        return fromDate;
    }

    private string GenerateToDate(string month, string year)
    {
        string toDate = "27-" + month + "-" + year;
        return toDate;
    }

}