using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Microsoft.VisualBasic;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class SubDepot_UI_TopSheetGenerate : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
  

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }

    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.LoadmanufacturerName(manufacturerDropDownList);
        aOtherStockActionBLL.DCLoad(dcDropDownList1, Session["UserId"].ToString());
        manufacturerDropDownList.SelectedIndex = 1;

        dcDropDownList1_SelectedIndexChanged(null, null);
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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim() != "")
        {
            StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
            DataTable dt = new DataTable();
            dt = aStockConditionFreezeBll.LoadInvoiceSubdeport(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()));

            if (dt.Rows.Count>0)
            {
                loadGridView.DataSource = dt;
            loadGridView.DataBind();



               

            }
            else
            {
                showMessageBox("No Data Found!!");
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
            
        }
        else
        {
            showMessageBox("Please Select all Parameters");
        }

    }
    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        LinkButton button = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        //Session["InvoiceNo"] = ""
        //Session["InvoiceNo"] = loadGridView.DataKeys[rowindex]["InvoiceNo"].ToString();


        string url = "../SInventory_RPTVIEW/SubDeportInvoiceReportViewer.aspx?InvNo=" + Server.UrlEncode(loadGridView.DataKeys[rowindex]["InvoiceNo"].ToString());
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

    }
    protected void opsheetButton_Click(object sender, EventArgs e)
    {
        Session["ProformaTopSheet"] = "";
        Session["ProformaTopSheet"] = 0;

        Session["dcDropDownList1"] = "";
        Session["manufacturerDropDownList"] = "";
        Session["MarketDropDownList1"] = "";
        Session["InvoiceDateTextBox"] = "";
        Session["dcDropDownList1"] = Convert.ToInt32(dcDropDownList1.SelectedValue);
        Session["manufacturerDropDownList"] = Convert.ToInt32(manufacturerDropDownList.SelectedValue);
        Session["MarketDropDownList1"] = Convert.ToInt32(MarketDropDownList1.SelectedValue);
        Session["InvoiceDateTextBox"] = Convert.ToDateTime(InvoiceDateTextBox.Text.Trim());
        string url = "../SInventory_RPTVIEW/SubdeportTopSheetReportViewer.aspx?InvNo=" + Server.UrlEncode(Session["InvoiceDateTextBox"].ToString());
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        try
        {
            Session["ProformaTopSheet"] = "";
            Session["ProformaTopSheet"] = 1;

            Session["dcDropDownList1"] = "";
            Session["manufacturerDropDownList"] = "";
            Session["MarketDropDownList1"] = "";
            Session["InvoiceDateTextBox"] = "";
            Session["dcDropDownList1"] = Convert.ToInt32(dcDropDownList1.SelectedValue);
            Session["manufacturerDropDownList"] = Convert.ToInt32(manufacturerDropDownList.SelectedValue);
            Session["MarketDropDownList1"] = Convert.ToInt32(MarketDropDownList1.SelectedValue);
            Session["InvoiceDateTextBox"] = Convert.ToDateTime(InvoiceDateTextBox.Text.Trim());
          


                    string url = "../SInventory_RPTVIEW/SubdeportTopSheetReportViewer.aspx?InvNo=" + Server.UrlEncode(Session["InvoiceDateTextBox"].ToString());
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        catch
        {
            showMessageBox("Please Select all Parameters");

        }
    }



}