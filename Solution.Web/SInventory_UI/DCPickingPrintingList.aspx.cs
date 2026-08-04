using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_DCPickingPrintingList : System.Web.UI.Page
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
    protected void searchButton_Click(object sender, EventArgs e)
    {
        DataTable aTable = new DataTable();
        if (dateTextBox.Text!="" && dcDropDownList.SelectedValue!="")
        {
            aTable = aInvoiceBll.AllPickingForReportListBLL(dcDropDownList.SelectedValue,Convert.ToDateTime(dateTextBox.Text.Trim()));
            if (aTable.Rows.Count > 0)
            {
                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                reportListGridView.DataSource = aTable;
                reportListGridView.DataBind();
            }
            else
            {

                reportListGridView.DataSource = null;
                reportListGridView.DataBind();
                showMessageBox("No Data Found!");
            }
        }
        else
        {
            showMessageBox("Select Correctly!");
        }
    }
    protected void printButton_Click(object sender, EventArgs e)
    {
        int iRowIndex = (((Button)sender).Parent.Parent as GridViewRow).RowIndex;
        string pickNo = reportListGridView.Rows[iRowIndex].Cells[0].Text.Trim();

        string url = "../SInventory_RPTVIEW/DCPickingReportViewer.aspx?pickNo=" + pickNo;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}