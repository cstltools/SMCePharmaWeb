using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_AreaEntry : System.Web.UI.Page
{
    AreaBLL areaBll=new AreaBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DistrictName();
        }
    }
    private void Clear()
    {
        areaNameTextBox.Text = string.Empty;
        areaCodeTextBox.Text = string.Empty;
        districtDropDownList.SelectedValue = null;
        comUnitNameDropDownList.SelectedValue = null;
        regionDropDownList.SelectedValue = null;
        companyNameDropDownList.SelectedValue = null;
    }

    public void DistrictName()
    {
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (areaNameTextBox.Text != "" )
        {
            AreaInfo areaInfo = new AreaInfo()
            {
                AreaCode = areaCodeTextBox.Text,
                AreaName = areaNameTextBox.Text,
                //DistrictName = districtDropDownList.SelectedItem.Text,
                //DistrictId = Convert.ToInt32(districtDropDownList.SelectedValue) 
            };

            AreaBLL areaBll = new AreaBLL();
            MessageLabel.Text = areaBll.SaveArea(areaInfo);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    protected void areaImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("AreaView.aspx");
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
    protected void comUnitNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadDistrictName(districtDropDownList, comUnitNameDropDownList.SelectedValue);
    }
}