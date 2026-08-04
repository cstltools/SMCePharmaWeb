using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_SCPickingGenerate : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");

            //  if (Session["UserId"].ToString() == "9" || Session["UserId"].ToString() == "11")
            {
                hiddiv.Visible = true;
            }
        }
    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.LoadmanufacturerName(manufacturerDropDownList);
      //  aOtherStockActionBLL.LoadTerritory(TERRITORYDropDownList1);
        aOtherStockActionBLL.DCLoad(dcDropDownList1, Session["UserId"].ToString());
        manufacturerDropDownList.SelectedIndex = 1;


        try
        {
            using (DataTable dt = _seedRepo.GetDistributionRouteList())
            {
                ddlRoute.DataSource = dt;
                ddlRoute.DataValueField = "DistributionRouteId";
                ddlRoute.DataTextField = "DistributionRouteName";
                ddlRoute.DataBind();
                ddlRoute.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlRoute.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[6].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("SCPickingGenerate.aspx");
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

        StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        aStockConditionFreezeBll.LoadPendingTerritory(TERRITORYDropDownList1, Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), (InvoiceDateTextBox.Text.Trim()));
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        //if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim() != "" )
        //{
        //    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        //    DataTable dt = new DataTable();
        //    dt = aStockConditionFreezeBll.LoadInvoice2(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()), (TERRITORYDropDownList1.SelectedItem.Text));
        //    loadGridView.DataSource = dt;
        //    loadGridView.DataBind();
        //}
        //if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue == "" && InvoiceDateTextBox.Text.Trim() != "" && TERRITORYDropDownList1.SelectedItem.Text != "")
        //{
        //    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        //    DataTable dt = new DataTable();
        //    dt = aStockConditionFreezeBll.LoadInvoice2(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), 0, Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()),(TERRITORYDropDownList1.SelectedItem.Text));
        //    loadGridView.DataSource = dt;
        //    loadGridView.DataBind();
        //}


        if (dcDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim() != "" && ddlRoute.SelectedValue != "")
        {
            StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
            DataTable dt = new DataTable();
            dt = aStockConditionFreezeBll.LoadInvoice2New(dcDropDownList1.SelectedValue, InvoiceDateTextBox.Text.Trim(), ddlRoute.SelectedValue);
            loadGridView.DataSource = dt;
            loadGridView.DataBind();
        }
        else
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select All Parameters!" + "','Faild');", true);

        }
    }

    public string GetParameter()
    {
        string parameter = " AND I.InvoiceId IN (";
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {

            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[6].FindControl("chkSelect");
            if (ChkBoxRows.Checked)
            {
                parameter = parameter + "'"+loadGridView.DataKeys[i][0].ToString() + "',";    
            }
        }
        parameter = parameter.TrimEnd(',');
        parameter = parameter + ")";
        return parameter;

    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void ViewButton_Click(object sender, EventArgs e)
    {
        int ch = 0;
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox cb = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");
            if (cb.Checked)
            {
                ch = ch + 1;
            }
        }

        if (ch>0)
        {
        Session["MrktRptParameter"] = GetParameter();
        Session["Market"] = "";
        Session["Manufac"] = "";
        Session["invoicedate"] = "";
        Session["Territory"] = "";
        Session["Route"] = ddlRoute.SelectedValue;
        Session["Market"] = MarketDropDownList1.SelectedValue;
            try
            {
                Session["Territory"] = TERRITORYDropDownList1.SelectedItem.Text;
            }
            catch(Exception ex)
            {

            }
            try
            {
                Session["Manufac"] = manufacturerDropDownList.SelectedValue;
            }
            catch (Exception ex)
            {

            }
            Session["invoicedate"] = InvoiceDateTextBox.Text.Trim();
        string url = "../SInventory_RPTVIEW/MarketwisePicking.aspx?SC=" + Server.UrlEncode(dcDropDownList1.SelectedValue);
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        else
        {
            showMessageBox("Please Select Invoice From List!!");
        }
        
    }
    protected void InvoiceDateTextBox_TextChanged(object sender, EventArgs e)
    {
        StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        aStockConditionFreezeBll.LoadPendingTerritory(TERRITORYDropDownList1, Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), (InvoiceDateTextBox.Text));
    }
}