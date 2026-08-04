using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_SalesCenterEdit : System.Web.UI.Page
{
    CompanyUnitBLL _companyUnitBll = new CompanyUnitBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            salesCenterInfoIdHiddenField.Value = Request.QueryString["ID"];
            ComUnitLoad(salesCenterInfoIdHiddenField.Value); 
        }
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (salesCenternameTextBox.Text != ""  && phoneNoTextBox.Text != "" && mobileNoTextBox.Text != "" && faxNoTextBox.Text != "")
        {
            CompanyUnit aCompanyUnit = new CompanyUnit()
            {
                ComUnitId = Convert.ToInt32(salesCenterInfoIdHiddenField.Value),
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

            if (!aCompanyUnitBll.UpdateDataForSalesCenter(aCompanyUnit))
            {
                MessageLabel.Text = "Data Not Update!!!";
                MessageLabel.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                MessageLabel.Text = "Data Update Successfully!!! Please Reload";
                MessageLabel.ForeColor = System.Drawing.Color.Green;
            }
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    private void ComUnitLoad(string salesCenterId)
    {
        CompanyUnit companyUnit = new CompanyUnit();
        companyUnit = _companyUnitBll.SalesCenterEditLoad(salesCenterId);
        salesCenternameTextBox.Text = companyUnit.ComUnitName;
        comUnitCodeTextBox.Text = companyUnit.ComUnitCode;
        addressTextBox.Text = companyUnit.Address;
        phoneNoTextBox.Text = companyUnit.PhoneNo;
        mobileNoTextBox.Text = companyUnit.MobileNo;
        faxNoTextBox.Text = companyUnit.FaxNo;
        //companyNameDropDownList.SelectedValue = companyUnit.CompanyId.ToString();
        //CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        //aMasterBll.LoadRegionname(regionDropDownList, companyNameDropDownList.SelectedValue);
        //regionDropDownList.SelectedValue = companyUnit.RegionId.ToString();

    }
    
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    public void LoadDropDown()
    {
        
        _companyUnitBll.LoadCompanyName(companyNameDropDownList);
    }
    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadRegionname(regionDropDownList, companyNameDropDownList.SelectedValue);
    }
}