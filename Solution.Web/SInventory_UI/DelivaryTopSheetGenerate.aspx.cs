using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_DelivaryTopSheetGenerate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.LoadmanufacturerName(manufacturerDropDownList);
        aOtherStockActionBLL.DCLoad(dcDropDownList1, Session["UserId"].ToString());

    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadMarket(MarketDropDownList1, dcDropDownList1.SelectedValue);
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }
    protected void manufacturerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }
    protected void MarketDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim() != "")
        {

            DateTime dateAndTime = Convert.ToDateTime(InvoiceDateTextBox.Text.Trim());
            string dateAndTime2 = (dateAndTime.ToString("MM/dd/yyyy"));


            OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
            StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
            DataTable dt = new DataTable();
            dt = aOrderInfoBll.LoadInvoice((dcDropDownList1.SelectedValue), (manufacturerDropDownList.SelectedValue), (MarketDropDownList1.SelectedValue), Convert.ToDateTime(dateAndTime2));
            loadGridView.DataSource = dt;
            loadGridView.DataBind();
        }

    }
    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        //Session["InvoiceNo"] = ""
        //Session["InvoiceNo"] = loadGridView.DataKeys[rowindex]["InvoiceNo"].ToString();


        string url = "../SInventory_RPTVIEW/DelivaryInvoiceReturnViewer.aspx?InvNo=" + Server.UrlEncode(loadGridView.DataKeys[rowindex]["DelivaryInvoiceNo"].ToString());
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

    }
    protected void opsheetButton_Click(object sender, EventArgs e)
    {
        Session["comunitId"] = dcDropDownList1.SelectedValue;
        Session["manufId"] = manufacturerDropDownList.SelectedValue;
        Session["marketId"] = MarketDropDownList1.SelectedValue;
        Session["invdate"] = InvoiceDateTextBox.Text;

        string url = "../SInventory_RPTVIEW/DelivaryTopSheetInvoiceReturnViewer.aspx?InvNo=" ;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    //protected void areaDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
    //    aOrderInfoBll.LoadMarketbyArea(MarketDropDownList1,areaDropDownList.SelectedValue);
    //    loadGridView.DataSource = null;
    //    loadGridView.DataBind();
    //}
}