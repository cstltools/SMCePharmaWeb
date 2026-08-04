using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_DcOpeningStockReport : System.Web.UI.Page
{
    DcOpeningStockReportBll aDcOpeningStockReportBll = new DcOpeningStockReportBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }

    private void LoadDropDown()
    {
        aDcOpeningStockReportBll.DCLoad(dcDropDownList);
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void CheckBox1_CheckedChanged1(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            dcDropDownList.SelectedValue = "";
            dcDropDownList.Enabled = false;
        }
        if (CheckBox1.Checked == false)
        {
            dcDropDownList.Enabled = true;
        }
    }

    protected void viewRptButton_OnClick(object sender, EventArgs e)
    {
        if (CheckBox1.Checked || dcDropDownList.SelectedValue != "")
        {
            if (CheckBox1.Checked)
            {
                if (stockViewDateTextBox.Text != "")
                {
                    PopUpDcOpeningStockReport();
                }
                else
                {
                    ShowMessageBox("Please provide a date!!!");
                }
            }
            else
            {
                if (dcDropDownList.SelectedValue != "" && stockViewDateTextBox.Text != "")
                {
                    PopUpDcOpeningStockReport();
                }

                else
                {
                    ShowMessageBox("Please Select a Sales center and a Date!!!");
                }
            }
        }
        else
        {
            ShowMessageBox("Please select National or Sales center to view report !!!");
        }
    }

    private void PopUpDcOpeningStockReport()
    {
        string repType = "";

        if (CheckBox1.Checked)
        {
            repType = "national";
        }
        else if (dcDropDownList.SelectedValue != "")
        {
            repType = "other";

            Session["dcId"] = "";
            Session["dcId"] = dcDropDownList.SelectedValue;
        }

        string url = "../SInventory_RPTVIEW/DcOpeningStockReportViewer.aspx?reportType=" + repType + "&Date=" + stockViewDateTextBox.Text.Trim();
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

    }
}