using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SubDepot_UI_SCPickingGenerate : System.Web.UI.Page
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
        if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim()!="")
        {
            StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
            DataTable dt = new DataTable();
            dt = aStockConditionFreezeBll.LoadInvoiceSubdeport(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()));
            loadGridView.DataSource = dt;
            loadGridView.DataBind();
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
        Session["Market"] = MarketDropDownList1.SelectedValue;
        Session["Manufac"] = manufacturerDropDownList.SelectedValue;
        Session["invoicedate"] = InvoiceDateTextBox.Text.Trim();
        string url = "../SInventory_RPTVIEW/SubdeportMarketwisePicking.aspx?SC=" + Server.UrlEncode(dcDropDownList1.SelectedValue);
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        else
        {
            showMessageBox("Please Select Invoice From List!!");
        }
        
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("SCPickingGenerate.aspx");
    }
}