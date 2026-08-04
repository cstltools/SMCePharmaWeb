using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_ProductWiseNationalSalesReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (reportTypeDropDownList.SelectedValue == "NULL")
        {
            ShowMessageBox("Please Select a report type !!!");
            return false;
        }

        if (yearDropDownList.SelectedValue == "NULL")
        {
            ShowMessageBox("Please Select an year !!!");
            return false;
        }

        if (monthDropDownList.SelectedValue == "NULL")
        {
            ShowMessageBox("Please Select a month !!!");
            return false;
        }

        return true;
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            string fromDate = GenerateFromDate(monthDropDownList.SelectedValue, yearDropDownList.SelectedValue);

            Session["rpt"] = "";
            Session["rpt"] = "CRP";

            PopUpSalesReport(fromDate,reportTypeDropDownList.SelectedValue);
        }
        
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (Validation())
        {
            string fromDate = GenerateFromDate(monthDropDownList.SelectedValue, yearDropDownList.SelectedValue);
            PopUpSalesReport(fromDate, reportTypeDropDownList.SelectedValue);
        }
    }

    private string GenerateFromDate(string month, string year)
    {
        string fromDate = "01-" + month + "-" + year;
        return fromDate;
    }

    private void PopUpSalesReport(string fromDate, string reportType)
    {
        string url = "../SInventory_RPTVIEW/ProductWiseNationalSalesReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + "&rptType=" + reportType; ;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

}