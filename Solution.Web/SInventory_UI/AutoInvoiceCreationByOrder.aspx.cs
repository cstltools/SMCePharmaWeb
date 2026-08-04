using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_AutoInvoiceCreationByOrder : System.Web.UI.Page
{
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            salesCenterDropDownList_SelectedIndexChanged(sender, e);
            SessionChoose();
            if (Session["MarketId"] !=null)
            {
                marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                GridView();
                
            }
        }
    }

    public void DropDownlist()
    {
        aOrderInfoBll.LoadSC(salesCenterDropDownList,Session["UserId"].ToString());
        aOrderInfoBll.LoadManufac(manufacDropDownList);
        manufacDropDownList.SelectedIndex = 1;
        salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aOrderInfoBll.LoadMarketOrderWise(marketDropDownList,salesCenterDropDownList.SelectedValue);
        orderGridView.DataSource = null;
        orderGridView.DataBind();
    }
    protected void manufacDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        //orderGridView.DataSource = aTable;
        //orderGridView.DataBind();
    }
    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        //Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        //Response.Redirect("InvoiceCreationForCustomerByOrder.aspx");


        InvoiceBLL aInvoiceBll = new InvoiceBLL();
        int status = aInvoiceBll.SaveFullProformaInvoice(orderGridView.DataKeys[rowindex]["OrderId"].ToString(),
                Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
    }

    public void SessionChoose()
    {
        DataTable aTable = new DataTable();
        if (Session["MarketId"] !=null)
        {
            //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
            //Session["MarketId"].ToString());
            //if (aTable.Rows.Count>0)
            //{
            //    marketDropDownList.SelectedValue = Session["MarketId"].ToString();
            //}
            //else
            //{
            //    marketDropDownList.SelectedIndex = 0;
            //}
        }
        
    }

    public void GridView()
    {
        DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        //orderGridView.DataSource = aTable;
        //orderGridView.DataBind();
        //Session["MarketId"] = marketDropDownList.SelectedValue;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView();
    }
}