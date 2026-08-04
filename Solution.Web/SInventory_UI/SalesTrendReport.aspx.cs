using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_SalesTrendReport : System.Web.UI.Page
{
    SalesTrendReportBll aTrendReportBll = new SalesTrendReportBll();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        try
        {
            if (yearDropDownList.SelectedIndex != 0)
            {
                string fromDate = GenerateFromDate(yearDropDownList.SelectedValue);
                string toDate = GenerateToDate(yearDropDownList.SelectedValue);
                const string reportType = "CRP";

                PopUpTrendReport(fromDate, toDate, reportType);
            }
            else
            {
                ShowMessageBox("Please select a year!!!");
            }
        }
        catch (Exception)
        {
            
          
        }
      
    }

    

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (yearDropDownList.SelectedIndex != 0)
        {
            string fromDate = GenerateFromDate(yearDropDownList.SelectedValue);
            string toDate = GenerateToDate(yearDropDownList.SelectedValue);
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
        string url = "../SInventory_RPTVIEW/SalesTrendReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&rptType=" + reportType; ;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    private string GenerateToDate(string year)
    {
        string toDate = "31-Dec-" + year;
        return toDate;
    }

    private string GenerateFromDate(string year)
    {
        string fromDate = "01-Jan-" + year;
        return fromDate;
    }


}