using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_MarketInfoEdit : System.Web.UI.Page
{
    MarketInfoBLL MarketInfoBLL = new MarketInfoBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AreaName();
            marketInfoIdHiddenField.Value = Request.QueryString["ID"];
            MarketInfoLoad(marketInfoIdHiddenField.Value);
           
        }

    }

    public void AreaName()
    {

        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (marketnameTextBox.Text != "" )
        {
            MarketInfo MarketInfo = new MarketInfo()
            {
                MarketId = Convert.ToInt32(marketInfoIdHiddenField.Value),
                MarketName = marketnameTextBox.Text,
                //MiaId = Convert.ToInt32(miaNameDropDownList.SelectedValue),
                MarketCode = marketCodeTextBox.Text,


            };
            MarketInfoBLL aMarketInfoBLL = new MarketInfoBLL();

            if (!aMarketInfoBLL.UpdateDataForMarketInfo(MarketInfo))
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

    private void MarketInfoLoad(string marketId)
    {
        MarketInfo MarketInfo = new MarketInfo();
        MarketInfo = MarketInfoBLL.MarketInfoEditLoad(marketId);
        marketnameTextBox.Text = MarketInfo.MarketName;
        //companyNameDropDownList.SelectedValue = MarketInfo.CompanyId.ToString();
        //CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        //aMasterBll.LoadRegionname(regionNameDropDownList, companyNameDropDownList.SelectedValue);
        //regionNameDropDownList.SelectedValue = MarketInfo.RegionId.ToString();
        //aCustomerMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);
        //comUnitNameDropDownList.SelectedValue = MarketInfo.ComUnitId.ToString();
        //aCustomerMasterBll.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);
        //districtNameDropDownList.SelectedValue = MarketInfo.DistrictId.ToString();
        //aCustomerMasterBll.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);
        //areaNameDropDownList.SelectedValue = MarketInfo.AreaId.ToString();
        //aCustomerMasterBll.LoadMiaName(miaNameDropDownList, areaNameDropDownList.SelectedValue);
        //miaNameDropDownList.SelectedValue = MarketInfo.MiaId.ToString();
        marketCodeTextBox.Text = MarketInfo.MarketCode;

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
        aCustomerMasterBll.LoadMiaName(miaNameDropDownList, areaNameDropDownList.SelectedValue);
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }
}