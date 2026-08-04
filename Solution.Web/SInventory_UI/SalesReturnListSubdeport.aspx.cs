using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_SalesReturnListSubdeport : System.Web.UI.Page
{
    ReturnInvoiceBLL aReturnInvoiceBll = new ReturnInvoiceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RequisitionBLL aRequisitionBll = new RequisitionBLL();
            aRequisitionBll.DCLoad(salesCenterDropDownList);
        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            aReturnInvoiceBll.DeleteData(loadGridView.DataKeys[rowindex][0].ToString());
            ShowMessageBox("Data Deleted !!!");
            LoadDataa();
        }

        if (e.CommandName == "reportData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            var I = (loadGridView.DataKeys[rowindex][0].ToString());

            string url = "../SInventory_RPTVIEW/ReturnInvoiceReportViewer2.aspx?InvNo=" +
                    Server.UrlEncode(I);
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" +
                             url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    public void LoadDataa()
    {
        DataTable dtdata = aReturnInvoiceBll.LoadSalesReuturnInvoiceSub(fromDateTextBox.Text, toDateTextBox.Text, salesCenterDropDownList.SelectedValue);
       
        if (dtdata.Rows.Count > 0)
        {
            loadGridView.DataSource = dtdata;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }

    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        LoadDataa();
    }

    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("SalesReturnSubDeport.aspx");
    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("SalesReturnListSubdeport.aspx");
    }
}