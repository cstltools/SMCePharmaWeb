using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Microsoft.VisualBasic;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_TopSheetGenerate : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    ProformaOrInvoiceReturnBLL aIn = new ProformaOrInvoiceReturnBLL();

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
        aOtherStockActionBLL.DCLoad(dcDropDownList1, Session["UserId"].ToString());
        manufacturerDropDownList.SelectedIndex = 1;

        dcDropDownList1_SelectedIndexChanged(null, null);
        // aOtherStockActionBLL.LoadTerritory(TERRITORYDropDownList1);

    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
        }
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadMarket(MarketDropDownList1, dcDropDownList1.SelectedValue);
        loadGridView.DataSource = null;
        loadGridView.DataBind();

        try
        {
            using (DataTable dt = _seedRepo.GetDistributionRouteListByDCID(dcDropDownList1.SelectedValue))
            {
                ddlRoute.DataSource = dt;
                ddlRoute.DataValueField = "RouteInformationMasterId";
                ddlRoute.DataTextField = "RouteName";
                ddlRoute.DataBind();
                ddlRoute.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlRoute.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        ////if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim() != "")
        //{
        //    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        //    DataTable dt = new DataTable();
        //    dt = aStockConditionFreezeBll.LoadInvoice2(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()),TERRITORYDropDownList1.SelectedItem.Text);

        //    if (dt.Rows.Count>0)
        //    {
        //        loadGridView.DataSource = dt;
        //    loadGridView.DataBind();
        //    }
        //    else
        //    {
        //        showMessageBox("No Data Found!!");
        //        loadGridView.DataSource = null;
        //        loadGridView.DataBind();
        //    }
            
        //}
        ////else
        ////{
        ////    showMessageBox("Please Select all Parameters");
        ////}
        /// 
        //if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue != "" && InvoiceDateTextBox.Text.Trim() != "")
        //{
        //    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        //    DataTable dt = new DataTable();
        //    dt = aStockConditionFreezeBll.LoadInvoice2(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()), (TERRITORYDropDownList1.SelectedValue));
        //    loadGridView.DataSource = dt;
        //    loadGridView.DataBind();
        //}
        //if (dcDropDownList1.SelectedValue != "" && manufacturerDropDownList.SelectedValue != "" && MarketDropDownList1.SelectedValue == "" && InvoiceDateTextBox.Text.Trim() != "" && TERRITORYDropDownList1.SelectedItem.Text != "")
        //{
        //    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        //    DataTable dt = new DataTable();
        //    dt = aStockConditionFreezeBll.LoadInvoice2(Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), 0, Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()), (TERRITORYDropDownList1.SelectedItem.Text));
        //    loadGridView.DataSource = dt;
        //    loadGridView.DataBind();
        //}

        if (dcDropDownList1.SelectedValue != "" &&  InvoiceDateTextBox.Text.Trim() != "" && ddlRoute.SelectedValue != "")
        {
            StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
            DataTable dt = new DataTable();
            dt = aStockConditionFreezeBll.LoadInvoice2New(dcDropDownList1.SelectedValue, InvoiceDateTextBox.Text.Trim(), ddlRoute.SelectedValue);
            loadGridView.DataSource = dt;
            loadGridView.DataBind();
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {


                HiddenField hfOrderId = (HiddenField)loadGridView.Rows[i].FindControl("hfOrderId");
                HiddenField hfInvoiceId = (HiddenField)loadGridView.Rows[i].FindControl("hfInvoiceId");
                HiddenField hfInvoiceNo = (HiddenField)loadGridView.Rows[i].FindControl("hfInvoiceNo");

                DataTable dtMarket = _dataLoad.Check_anomalyInvoiceDetails(hfInvoiceId.Value.ToString(), hfOrderId.Value.ToString());

                if (dtMarket.Rows.Count > 0)
                {
                    aIn.DeleteProforma(hfInvoiceNo.Value.ToString().Trim());


                }
            }

            if (dt.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " No Data Found!" + "','Faild');", true);
            }
        }
        else
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select All Parameters!" + "','Faild');", true);
            
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


        string url = "../SInventory_RPTVIEW/InvoiceReportViewer.aspx?InvNo=" + Server.UrlEncode(loadGridView.DataKeys[rowindex]["InvoiceNo"].ToString());
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
        string url = "../SInventory_RPTVIEW/TopSheetReportViewer.aspx?InvNo=" + Server.UrlEncode(Session["InvoiceDateTextBox"].ToString());
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        txtDeliveryMan.CssClass = "form-control form-control-sm";

        if (txtDeliveryMan.Text == "")
        {
            txtDeliveryMan.ToolTip = "please fill out this field";
            txtDeliveryMan.CssClass = "form-control form-control-sm is-invalid";
            txtDeliveryMan.Focus();
            
        }
        else
        {
            try
            {
                Session["ProformaTopSheet"] = "";
                Session["ProformaTopSheet"] = 1;
                Session["Terr"] = "";
                Session["dcDropDownList1"] = "";
                Session["manufacturerDropDownList"] = "";
                Session["MarketDropDownList1"] = "";
                Session["InvoiceDateTextBox"] = "";
                Session["dcDropDownList1"] = Convert.ToInt32(dcDropDownList1.SelectedValue);
                Session["Route"] = Convert.ToInt32(ddlRoute.SelectedValue);
                try
                {
                    Session["MarketDropDownList1"] = Convert.ToInt32(MarketDropDownList1.SelectedValue);
                }
                catch (Exception)
                {

                    Session["MarketDropDownList1"] = 0;
                }
                int pk = _seedRepo.Save_TopSheetGenReportCodeInfo(Session["UserId"].ToString(), txtDeliveryMan.Text.Trim());

                string Code = "";
                if (pk > 0)
                {

                    try
                    {
                        using (DataTable dt = _seedRepo.GetTopSheetCodeSetupById(pk.ToString()))
                        {
                            Code = dt.Rows[0]["TopSheetGenCode"].ToString();
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }

                string InvoiId = "";
                for (int i = 0; i < loadGridView.Rows.Count; i++)
                {

                    CheckBox chkSelect = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");
                    HiddenField hfInvoiceId = (HiddenField)loadGridView.Rows[i].FindControl("hfInvoiceId");

                    if (chkSelect.Checked)
                    {
                        InvoiId = InvoiId + hfInvoiceId.Value + ',';

                    }
                }

                InvoiId = InvoiId.TrimEnd(',');

                //Session["Terr"] = (TERRITORYDropDownList1.SelectedItem.Text);


                if (InvoiId != "")
                {

                    Session["InvoiceDateTextBox"] = Convert.ToDateTime(InvoiceDateTextBox.Text.Trim());
                    string url = "../SInventory_RPTVIEW/TopSheetReportViewer.aspx?InvNo=" + InvoiId + "&Code=" + Code;
                    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
                    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
                    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select at Least one row from Table!" + "','Faild');", true);

                }
            }
            catch (Exception)
            {
            }
        }
      

    }
    protected void InvoiceDateTextBox_TextChanged(object sender, EventArgs e)
    {
        //StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
        //aStockConditionFreezeBll.LoadPendingTerritory(TERRITORYDropDownList1, Convert.ToInt32(dcDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue), Convert.ToInt32(MarketDropDownList1.SelectedValue), (InvoiceDateTextBox.Text.Trim()));
    }

    protected void lblInvoice_Click(object sender, EventArgs e)
    {
        try
        {
            Session["paydetailId"] = null;

        string InvoiId = "";
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {

            CheckBox chkSelect = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");
            HiddenField hfInvoiceId = (HiddenField)loadGridView.Rows[i].FindControl("hfInvoiceId");

            if (chkSelect.Checked)
            {
                InvoiId = InvoiId + hfInvoiceId.Value + ',';

            }
        }

        InvoiId = InvoiId.TrimEnd(',');
        if (InvoiId != "")
        {
            string url = "../SInventory_RPTVIEW/ProformaReportPrintViewer.aspx?InvNo=" + InvoiId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select at Least one row from Table!" + "','Faild');", true);

        }

        }
        catch (Exception)
        {
        }
    }
}