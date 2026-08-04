using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_DS;

public partial class SInventory_UI_SubdeportMonthlyInventoryReport : System.Web.UI.Page
{

    AreaWiseMonthlyInventoryReportBll areaWise = new AreaWiseMonthlyInventoryReportBll();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdownList();
        }
    }

    private void LoadDropdownList()
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadSC(branchDropDownList, Session["UserId"].ToString());
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    private void ReportPopUp()
    {
        //if (branchDropDownList.SelectedValue != "")
        {
            if (fromDateTextBox.Text != "" && todateTextBox.Text != "")
            {
                var fromDate = Convert.ToDateTime(fromDateTextBox.Text.Trim());
                var toDate = Convert.ToDateTime(todateTextBox.Text.Trim());
                var branchId = (branchDropDownList.SelectedValue);
                var national = CheckBox1.Checked;

                var url = "../SInventory_RPTVIEW/SubdeportAreaWiseMonthlySalesReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&branchId=" + branchId + "&national=" + national;
                var fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
            }
            else
            {
                ShowMessageBox("Please Select adate range!!");
            }
        }
        //else
        //{
        //    ShowMessageBox("Please Select a branch!!");
        //}

        
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        ReportPopUp();
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            branch.Visible = false;    
        }
        else
        {
            branch.Visible = true;
        }
        
    }
}