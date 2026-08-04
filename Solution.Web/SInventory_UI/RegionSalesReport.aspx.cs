using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ComUnitSalesReport : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    RegionSalesReportBLL aRegionSalesReportBll = new RegionSalesReportBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserType"].ToString() != "")
            {
                if (Session["UserType"].ToString() == "Admin")
                {
                    aRegionSalesReportBll.LoadRegion(regionDropDownList);
                }
                else
                {
                    string region = Session["RegionId"].ToString();
                    aRegionSalesReportBll.LoadRegion(regionDropDownList, region);
                }
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
    public  void LoadDC()
    {
        aRequisitionBll.DCLoad(regionDropDownList);
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (fromDateTextBox.Text!="")
        {
            if (toDateTextBox.Text == "")
            {
                toDateTextBox.Text = fromDateTextBox.Text;
            }
                string fromDate = fromDateTextBox.Text;
                string toDate = toDateTextBox.Text;
                string RegionId = regionDropDownList.SelectedValue;

                string url = "../SInventory_RPTVIEW/RegionSalesReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&RegionId=" + RegionId;
                string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
           
        }
        else
        {
            showMessageBox("Select From Date");
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}