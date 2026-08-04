using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_ProformaPrintList : System.Web.UI.Page
{
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

    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        // Clear();
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
            ProformaPrintListDal aStockConditionFreezeBll = new ProformaPrintListDal();
            DataTable dt = new DataTable();
            dt = aStockConditionFreezeBll.LoadInvoice(GenerateParameterForInvoiceLoad());

            if (dt.Rows.Count > 0)
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

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
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

    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
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

    private string GenerateParameterForInvoiceLoad()
    {
        string parameter = "";

        if (InvoiceDateTextBox.Text != "")
        {
            parameter = parameter + " WHERE InvoiceDate BETWEEN '" + (InvoiceDateTextBox.Text.Trim()) + "'  AND '" + (InvoiceDateTextBox.Text.Trim()) + "'";
        }

        if (dcDropDownList1.SelectedValue != "")
        {
            parameter = parameter + " AND I.ComUnitId = '" + dcDropDownList1.SelectedValue + "'";
        }

        if (manufacturerDropDownList.SelectedValue != "")
        {
            parameter = parameter + " AND tblD.ManufacId = '" + manufacturerDropDownList.SelectedValue + "'";
        }

        if (MarketDropDownList1.SelectedValue != "")
        {
            parameter = parameter + " AND tblMarket.MarketId = '" + MarketDropDownList1.SelectedValue + "'";
        }



        return parameter;

    }

    private string GenerateParameter()
    {
        string pram = " WHERE IV.InvoiceNo IN (";


        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

            if (ChkBoxRows.Checked)
            {
                pram = pram + "'" +loadGridView.DataKeys[i]["InvoiceNo"] + "',";
            }
        }



        if (pram != "")
        {
            pram = pram.Substring(0, pram.Length - 1);
            pram = pram + ")";
        }
        else
        {
            pram = "";
        }
        return pram;
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

        string pram = "";
        pram = GenerateParameter();

        Session["paydetailId"] = "";
        Session["paydetailId"] = pram;


        string url = "../SInventory_RPTVIEW/ProformaReportPrintViewer.aspx" ;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
}