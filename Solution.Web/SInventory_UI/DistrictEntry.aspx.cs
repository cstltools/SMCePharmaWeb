using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DistrictEntry : System.Web.UI.Page
{
    DistrictInfoBLL aDistrictInfoBll = new DistrictInfoBLL();
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
        districtCodeTextBox.Text = string.Empty;
        districtNameTextBox.Text = string.Empty;
        comUnitNameDropDownList.SelectedValue = null;
        regionDropDownList.SelectedValue = null;
        companyNameDropDownList.SelectedValue = null;

    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (districtNameTextBox.Text != "")
        {
            DistrictInfo aDistrictInfo = new DistrictInfo()
            {
                DistrictCode = districtCodeTextBox.Text,
                DistrictName = districtNameTextBox.Text,
                //ComUnitId = Convert.ToInt32(comUnitNameDropDownList.SelectedValue),
                
            };
            DistrictInfoBLL aDistrictInfoBll = new DistrictInfoBLL();
            MessageLabel.Text = aDistrictInfoBll.SaveDataForDistrictInfo(aDistrictInfo);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void DistrictInfoListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DistrictView.aspx");
    }
    protected void comUnitNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadRegionname(regionDropDownList, companyNameDropDownList.SelectedValue);
    }
    protected void regionDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionDropDownList.SelectedValue);
    }
}