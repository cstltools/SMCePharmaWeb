using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_InvoicePrintingList : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserType"].ToString() != "")
            {
                if (Session["UserType"].ToString() == "Admin")
                {
                    aRequisitionBll.DCLoad(dcDropDownList);
                }
                else
                {
                    string comUnit = Session["ComUnitId"].ToString();
                    aRequisitionBll.DCLoad(dcDropDownList, comUnit);
                }
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
    protected void printButton_Click(object sender, EventArgs e)
    {
        string invNoColl = "";
        bool checkedSelect = false;
        for (int i = 0; i < reportListGridView.Rows.Count; i++)
        {
            CheckBox aCheckBox = (CheckBox) reportListGridView.Rows[i].Cells[0].FindControl("printCheckBox");
            if (aCheckBox.Checked==true)
            {
                checkedSelect = true;
                invNoColl = invNoColl + reportListGridView.Rows[i].Cells[1].Text.Trim()+":";
            }
        }

        if (checkedSelect == false)
        {
            showMessageBox("Select First!!");
        }
        
        else
        {
            invNoColl = invNoColl.TrimEnd(':');
            string url = "../SInventory_RPTVIEW/InvoiceReportViewer.aspx?InvNo=" + Server.UrlEncode(invNoColl.Trim());
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }
    protected void searchButton_Click(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        if (dcDropDownList.SelectedValue != "" && dateTextBox.Text!="")
        {
            aDataTable = aInvoiceBll.AllInvoiceForPrintingBLL(dcDropDownList.SelectedValue, dateTextBox.Text.Trim());
            if (aDataTable.Rows.Count > 0)
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                reportListGridView.DataSource = aDataTable;
                reportListGridView.DataBind();
            }
            else
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!!");
            }
        }
        else
        {
            showMessageBox("Select DC & Date !!");
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