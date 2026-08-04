using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_AllSalesReport : System.Web.UI.Page
{
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
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
    }

    public string ReportParameter()
    {
        string parameter = "";
        if (rptTypeDropDownList.SelectedValue == "TW")
        {
            parameter =  " AND  A.AreaCode='" + areacodeTextBox.Text + "' AND CU.ComUnitId='" + dcDropDownList1.SelectedValue.Trim() + "' ";
            if (CheckBox1.Checked)
            {
                parameter =  " AND  A.AreaCode='" + areacodeTextBox.Text + "' ";
            }
        }
        if (rptTypeDropDownList.SelectedValue == "PW")
        {
            parameter =  " AND   ID.ProductCode='" + productCodeTextBox.Text + "' AND CU.ComUnitId='" + dcDropDownList1.SelectedValue.Trim() + "' ";
            if (CheckBox1.Checked)
            {
                parameter =  " AND  ID.ProductCode='" + productCodeTextBox.Text + "' ";
            }
        }
        if (rptTypeDropDownList.SelectedValue == "DW")
        {
            parameter =  " AND   DIS.DistrictCode='" + districtTextBox.Text + "' AND CU.ComUnitId='" + dcDropDownList1.SelectedValue.Trim() + "' ";
            if (CheckBox1.Checked)
            {
                parameter =  " AND  DIS.DistrictCode='" + districtTextBox.Text + "' ";
            }
        }
        if (rptTypeDropDownList.SelectedValue == "RW")
        {
            parameter =  " AND   R.RegionCode='" + regionTextBox.Text + "' AND CU.ComUnitId='" + dcDropDownList1.SelectedValue.Trim() + "' ";
            if (CheckBox1.Checked)
            {
                parameter =  " AND  R.RegionCode='" + regionTextBox.Text + "' ";
            }
        }
        return parameter;
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        Session["RptParam"] = ReportParameter();
        //if (rptTypeDropDownList.SelectedValue == "SCW")
        
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string product = productCodeTextBox.Text;
            int i = 1;
            string url = "../SInventory_RPTVIEW/MIOProductSalesreportViewer.aspx?rpttype=" + rptTypeDropDownList.SelectedValue + "&NationalReport=" + 1 + "&fromDate=" + fromDate + "&toDate=" + toDate + "&product=" + product;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
      
    }
    protected void CheckBox1_CheckedChanged1(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            dcDropDownList1.Enabled = false;
        }
        if (CheckBox1.Checked == false)
        {
            dcDropDownList1.Enabled = true;
        }
    }
    protected void rptTypeDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        Tr1.Visible = true;
        DIVDC.Visible = true;
        region.Visible = false;
        district.Visible = false;
        if (rptTypeDropDownList.SelectedValue == "SCW")
        {
            region.Visible = false;
            district.Visible = false;
            treitory.Visible = false;
            productcode.Visible = false;
        }
        if (rptTypeDropDownList.SelectedValue == "TW")
        {
            region.Visible = false;
            district.Visible = false;
            treitory.Visible = true;
            productcode.Visible = false;
        }
        if (rptTypeDropDownList.SelectedValue == "PW")
        {
            region.Visible = false;
            district.Visible = false;
            treitory.Visible = false;
            productcode.Visible = true;
        }
        if (rptTypeDropDownList.SelectedValue == "DW")
        {
            region.Visible = false;
            district.Visible = true;
            treitory.Visible = false;
            productcode.Visible = false;
        }
        if (rptTypeDropDownList.SelectedValue == "RW")
        {
            region.Visible = true;
            district.Visible = false;
            treitory.Visible = false;
            productcode.Visible = false;
        }

    }
}