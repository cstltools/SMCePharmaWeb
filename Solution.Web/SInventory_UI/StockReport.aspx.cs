using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_StockReport : System.Web.UI.Page
{
    DCStockReportBLL aDcStockReportBll=new DCStockReportBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserType"].ToString() != "")
            {
                if (Session["UserType"].ToString() == "Admin")
                {
                    aDcStockReportBll.LoadCompanyUnit(dcDropDownList1);
                }
                else
                {
                    string userId = Session["UserId"].ToString();
                    aDcStockReportBll.LoadCompanyUnit(dcDropDownList1);
                }
            }
            else
            {
                Response.Redirect("Login.aspx");
            }

            if (Session["CentralWareHouse"] != null && Session["CentralWareHouse"].ToString()=="True")
            {
                centalWHCheckBox.Enabled = true;
            }
        }
    }
    protected void centalWHCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        if (centalWHCheckBox.Checked == true)
        {
            DIVCH.Visible = true;
            DIVDC.Visible = false;
            //whDropDownList.SelectedValue = "";
            RequisitionBLL aRequisitionBll = new RequisitionBLL();
            aRequisitionBll.WareHouseLoad(whDropDownList);

        }
        if (centalWHCheckBox.Checked == false)
        {
            DIVCH.Visible = false;
            DIVDC.Visible = true;
            dcDropDownList1.SelectedValue = "";
        }
    }
    protected void whDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (nationalCheckBox.Checked == true)
        {
            Session["DC"] = "";
            Session["DC"] = 1;
            string ComUnitId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (centalWHCheckBox.Checked == false && nationalCheckBox.Checked == false && dcDropDownList1.SelectedValue != "")
        {
            //dc rpt
            Session["DC"] = "";
            Session["DC"] = 1;
            string ComUnitId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
                string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (whDropDownList.SelectedValue != "" && centalWHCheckBox.Checked == true)
        {
            //wh rpt
            Session["DC"] = "";
            Session["DC"] = 0;
            string ComUnitId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/DCStockReportViewer.aspx?comUnitId=" + ComUnitId;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void nationalCheckBox_CheckedChanged(object sender, EventArgs e)
    {

        if (nationalCheckBox.Checked)
        {
            dcDropDownList1.Enabled = false;
            centalWHCheckBox.Enabled = false;
            Session["DC"] = "0";
            dcDropDownList1.SelectedValue = string.Empty;
            
        }
        if (nationalCheckBox.Checked == false)
        {
            dcDropDownList1.Enabled = true;
            centalWHCheckBox.Enabled = true;
        }
    }
}