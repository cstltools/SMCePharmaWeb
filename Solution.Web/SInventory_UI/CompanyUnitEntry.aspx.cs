using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CompanyUnitEntry : System.Web.UI.Page
{
    CompanyUnitBLL aCompanyUnitBll = new CompanyUnitBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }
    public void LoadDropDown()
    {
        
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();
        
        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
    }
    private void Clear()
    {
        salesCenternameTextBox.Text = string.Empty;
        regionDropDownList.SelectedValue = null;
        addressTextBox.Text = string.Empty;
        phoneNoTextBox.Text = string.Empty;
        mobileNoTextBox.Text = string.Empty;
        faxNoTextBox.Text = string.Empty;
        companyNameDropDownList.SelectedValue = null;
        comUnitCodeTextBox.Text = string.Empty;

    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (salesCenternameTextBox.Text == "")
        {
            showMessageBox("Please Input Sales Center Name!!");
            return false;
        }
        if (addressTextBox.Text == "")
        {
            showMessageBox("Please Input Address!!");
            return false;
        }
        if (phoneNoTextBox.Text == "")
        {
            showMessageBox("Please Input Phone No!!");
            return false;
        }
        if (mobileNoTextBox.Text == "")
        {
            showMessageBox("Please Input Mobile No!!");
            return false;
        }

        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            CompanyUnit aCompanyUnit = new CompanyUnit()
            {
                ComUnitCode = comUnitCodeTextBox.Text,
                ComUnitName = salesCenternameTextBox.Text,
                Address = addressTextBox.Text,
                PhoneNo = phoneNoTextBox.Text,
                MobileNo = mobileNoTextBox.Text,
                FaxNo = faxNoTextBox.Text,
                //CompanyId = Convert.ToInt32(companyNameDropDownList.SelectedValue),
                //CompanyName = companyNameDropDownList.SelectedItem.Text,
                //RegionId = Convert.ToInt32(regionDropDownList.SelectedValue),
                //RegionName = regionDropDownList.SelectedItem.Text
            };

            CompanyUnitBLL aCompanyUnitBll = new CompanyUnitBLL();
            if (aCompanyUnitBll.SaveSalesCenter(aCompanyUnit))
            {
                showMessageBox("Data Save Successfully  CompanyUnit Code  is :  " + aCompanyUnit.ComUnitCode + " And  CompanyUnit Name is :" + aCompanyUnit.ComUnitName);
                Clear(); 
            }  
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }
    
    protected void unitViewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CompanyUnitView.aspx");
    }
    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadRegionname(regionDropDownList,companyNameDropDownList.SelectedValue);
    }
}