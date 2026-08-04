using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_CustomerMasterReport : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserType"].ToString() != "")
            {
                if (Session["UserType"].ToString() == "Admin")
                {
                   aCustomerMasterBll.LoadDcDropDownList(dcDropDownList);
                }
                else
                {
                    string comUnit = Session["ComUnitId"].ToString();
                    aCustomerMasterBll.LoadDcDropDownList(dcDropDownList, comUnit);
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
        aRequisitionBll.DCLoad(dcDropDownList);
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        //if (dcDropDownList.Text!="")
        {
            //if (CheckBox1.Checked)
            //{
            //    Session["AllCheck"] = "1";
            //}
            //else
            //{
            //    Session["AllCheck"] = "0";
            //}


            if (reportTypeDropDownList.SelectedValue != "NULL")
            {
                string rptType = reportTypeDropDownList.SelectedValue;

                string url = "../SInventory_RPTVIEW/CustomerMasterViewer.aspx?rptType=" + rptType;
                string fullURL =
                    "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url +
                    "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                ScriptManager.RegisterStartupScript(this, typeof (string), "OPEN_WINDOW", fullURL, true);
            }
            else
            {
                ShowMessageBox("Please Select a report type !!!!");
            }

                   
        }
        //else
        //{
        //    showMessageBox("Select DC.Name");
        //}
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            dcDropDownList.Enabled = false;    
        }
        else
        {
            dcDropDownList.Enabled = true;
        }
        
    }
}