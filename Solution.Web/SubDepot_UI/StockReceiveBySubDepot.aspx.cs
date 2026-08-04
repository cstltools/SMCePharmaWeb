using System;
using System.Data;
using System.Web.UI;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;

public partial class SubDepot_UI_StockReceiveBySubDepot : Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    SubDepotChalanBLL aChalanBll = new SubDepotChalanBLL();
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
            LoadGrid(subdeportDropDownList1.SelectedValue);
        }
        else
        {
            stockInTraGridView.DataSource = null;
            stockInTraGridView.DataBind();
        }
    }

    protected void subdeportDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
      
    }
    protected void dcDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aRequisitionBll.SubdeportLoad(subdeportDropDownList1, dcDropDownList.SelectedValue);
    }
}