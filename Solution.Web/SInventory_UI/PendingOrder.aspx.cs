using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_PendingOrder : System.Web.UI.Page
{
    PendingOrderBll aOrderBll = new PendingOrderBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            //LoadPendingOrderInfo();
        }
    }

    private void LoadPendingOrderInfo()
    {
        DataTable aTable = new DataTable();
        aTable = aOrderBll.LoadPendingOrderInformation(salesCenterDropDownList.SelectedValue, fromDateTextBox.Text, toDateTextBox.Text);
        if (aTable.Rows.Count>0)
        {
        loadGridView.DataSource = aTable;
        loadGridView.DataBind();
        }
        else{
        loadGridView.DataSource = null;
        loadGridView.DataBind();
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "executeOrder")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string orderCode = loadGridView.DataKeys[rowindex][1].ToString();
            string msg = aOrderBll.LoadOrderExistOrNotInfo(orderCode);
            showMessageBox(msg);
            LoadPendingOrderInfo();
        }
    }

    protected void CustMasterReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        LoadPendingOrderInfo();
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        if (salesCenterDropDownList.SelectedValue != "" && fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            LoadPendingOrderInfo();
        }
        else
        {
            showMessageBox("Please Select sales Center and Date Range");
        }
    }
}