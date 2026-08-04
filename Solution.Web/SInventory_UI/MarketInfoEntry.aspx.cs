using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.ReportSource;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_MarketInfoEntry : System.Web.UI.Page
{
    MarketInfoBLL aMarketInfoBll = new MarketInfoBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AreaName();
        }
    }
    private void Clear()
    {
        marketnameTextBox.Text = string.Empty;
        miaNameDropDownList.SelectedValue = null;
        areaNameDropDownList.SelectedValue = null;
        districtNameDropDownList.SelectedValue = null;
        comUnitNameDropDownList.SelectedValue = null;
        regionNameDropDownList.SelectedValue = null;
        companyNameDropDownList.SelectedValue = null;
        marketCodeTextBox.Text = string.Empty;
    }
    public void AreaName()
    {
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
    }
   
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (marketnameTextBox.Text != "")
        {
            MarketInfo aMarketInfo = new MarketInfo()
            {
                MarketName = marketnameTextBox.Text,
                MarketCode = marketCodeTextBox.Text,
                //MiaId = Convert.ToInt32(miaNameDropDownList.SelectedValue)
            };

            MarketInfoBLL aInfoBll=new MarketInfoBLL();
            MessageLabel.Text = aInfoBll.SaveMarket(aMarketInfo);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void areaImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("MarketInfoView.aspx");
    }
    
    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadRegionname(regionNameDropDownList, companyNameDropDownList.SelectedValue);
    }
    protected void regionNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustomerMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);
    }
    protected void comUnitNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustomerMasterBll.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);
    }
    protected void districtNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustomerMasterBll.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);
    }
    protected void areaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustomerMasterBll.LoadMiaName(miaNameDropDownList,areaNameDropDownList.SelectedValue);
    }
}