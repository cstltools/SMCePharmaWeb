using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_TransferStockReceiveByDC : Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    ChalanBLL aChalanBll=new ChalanBLL();
    DataTable aDataTable = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserType"].ToString()!="")
            {
                if (Session["UserType"].ToString() == "Admin")
                {
                    aRequisitionBll.DCLoad(dcDropDownList);
                }
                else
                {
                    string comUnit = Session["ComUnitId"].ToString();
                    aRequisitionBll.DCLoad(dcDropDownList, Session["UserId"].ToString()); 
                }
            }
            else
            {
                Response.Redirect("Login.aspx");
            }  
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("TransferStockReceiveByDC.aspx");
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

    private void LoadGrid(string comUnitId)
    {
        aDataTable = aChalanBll.ChalanLoadInReceive(comUnitId);
        if (aDataTable.Rows.Count>0)
        {
            stockInTraGridView.DataSource = null;
            stockInTraGridView.DataBind();
            stockInTraGridView.DataSource = aDataTable;
            stockInTraGridView.DataBind();
        }
        else
        {
            stockInTraGridView.DataSource = null;
            stockInTraGridView.DataBind();
            showMessageBox("No Data Found!!");
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        if (dcDropDownList.SelectedValue != "")
        {
            LoadGrid(dcDropDownList.SelectedValue);
        }
        else
        {
            stockInTraGridView.DataSource = null;
            stockInTraGridView.DataBind();
        }
    }
}