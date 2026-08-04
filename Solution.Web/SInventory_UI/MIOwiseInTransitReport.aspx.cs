using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_MIOwiseInTransitReport : System.Web.UI.Page
{

    private CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
       // aOtherStockActionBLL.DCLoad(dcDropDownList1);
        aOtherStockActionBLL.LoadSC(dcDropDownList1, Session["UserId"].ToString());
        //aOtherStockActionBLL.LoadMIOMIOreceivable(mioDropDownList);

        try
        {
            
            using (DataTable dt = _dataLoad.GetTerritory_All())
            {
                marketDropDownList.DataSource = dt;
                marketDropDownList.DataValueField = "TerritoryId";
                marketDropDownList.DataTextField = "TerritoryName";
                marketDropDownList.DataBind();
                marketDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                marketDropDownList.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }

        try
        {
       
            using (DataTable dt = _dataLoad.GetMIOEmployee_AllWithOutParm())
            {
                mioDropDownList.DataSource = dt;
                mioDropDownList.DataValueField = "EmpInfoId";
                mioDropDownList.DataTextField = "EmployeeName";
                mioDropDownList.DataBind();
                mioDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                mioDropDownList.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }
    }


    private string Parm()
    {
        string param = "";

        if (CheckBox1.Checked)
        {

        }
        else
        {
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND mas.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }
        }
        if (mioDropDownList.SelectedValue != "")
        {
            param = param + " AND mas.MIOId='" + mioDropDownList.SelectedValue + "' ";
        }


        if (marketDropDownList.SelectedValue != "")
        {
            param = param + " AND mas.TerritoryId='" + marketDropDownList.SelectedValue + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


        if (InvoiceDateTextBox.Text == "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + "10-Mar-2000" + "' AND '" + todateTextBox.Text + "' ";
        }

        return param;
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
         
            Session["Excel"] = "";
            Session["Excel"] = "N";
        Session["Param"] = Parm();
            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/MIOwiseInTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate ;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
       


    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        //OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

        //aOrderInfoBll.LoadMarketOrderWiseALl(marketDropDownList, dcDropDownList1.SelectedValue);
        
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            dcDropDownList1.Enabled = false;
            dcDropDownList1.SelectedValue = string.Empty;
        }
        if (CheckBox1.Checked==false)
        {
            dcDropDownList1.Enabled = true;

        }
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        {
            if (todateTextBox.Text == "")
            {
                InvoiceDateTextBox.Text = todateTextBox.Text;
            }

            Session["Excel"] = "";
            Session["Excel"] = "Y";

            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string districtId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            Session["Excel"] = "";
            Session["Excel"] = "Y";

            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("InTransitReport.aspx");
    }
}