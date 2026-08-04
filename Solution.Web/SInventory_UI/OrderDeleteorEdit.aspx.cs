using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_OrderDeleteorEdit : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();

        }
    }

    public void LoadDropDown()
    {
        
        try
        {

            using (DataTable dt = _dataLoad.GetOrderInvoiceIsZero())
            {
                ddlOrder.DataSource = dt;
                ddlOrder.DataValueField = "OrderId";
                ddlOrder.DataTextField = "OrderCode";
                ddlOrder.DataBind();
                ddlOrder.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlOrder.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }
    }
        protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void CustomerMasterLoad()
    {
        aDataTable = aCustomerMasterBLL.LoadOrderView(custcodenameTextBox.Text);
        if (aDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            showMessageBox("No Order Found!!");
        }
    }
    private void CustomerMasterLoad2()
    {
        aDataTable = aCustomerMasterBLL.LoadOrderView(custcodenameTextBox.Text);
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(customermasterid);
        }
        if (e.CommandName == "DelData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            bool sts=  aCustomerMasterBLL.DeleteRequisition(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
            if (sts==true)
            {
                CustomerMasterLoad2();
                showMessageBox("Delete Successfully");
            }
            else
            {
                showMessageBox("Cant delete!!Proforma Already Generated");
            }
           
        }
    }

    private void PopUp(string Id)
    {
        string url = "OrderEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void CustMasterNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CustMasterEntry.aspx");
    }
    protected void areaReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        CustomerMasterLoad();
    }

    protected void rptImageButton_Click(object sender, ImageClickEventArgs e)
    {
        string url = "../SInventory_RPTVIEW/CustomerMasterViewer.aspx";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        bool sts = aCustomerMasterBLL.DeleteRequisition(Convert.ToInt32(ddlOrder.SelectedValue));
        if (sts == true)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','OrderDeleteorEdit.aspx');", true);

         
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Can not delete!!Proforma Already Generated!" + "','Faild');", true); 
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("OrderDeleteorEdit.aspx");
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
}