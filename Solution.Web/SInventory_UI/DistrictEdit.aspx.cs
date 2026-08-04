using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DistrictEdit : System.Web.UI.Page
{
    DistrictInfoBLL aDistrictInfoBLL = new DistrictInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            districtIdHiddenField.Value = Request.QueryString["ID"];
            DistrictLoad(districtIdHiddenField.Value);
        }
    }
    public void LoadDropDown()
    {
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
       
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (districtNameTextBox.Text != "")
        {
            DistrictInfo aDistrictInfo = new DistrictInfo()
            {
                DistrictId = Convert.ToInt32(districtIdHiddenField.Value),
                DistrictCode = districtCodeTextBox.Text,
                DistrictName = districtNameTextBox.Text,
                //ComUnitId = Convert.ToInt32(comUnitNameDropDownList.SelectedValue),
            };
            DistrictInfoBLL aDistrictInfoBLL = new DistrictInfoBLL();

            if (!aDistrictInfoBLL.UpdateDataForDistrictInfo(aDistrictInfo))
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

    private void DistrictLoad(string DistrictInfoId)
    {
        DistrictInfo aDistrictInfo = new DistrictInfo();
        aDistrictInfo = aDistrictInfoBLL.DistrictInfoEditLoad(DistrictInfoId);
        districtNameTextBox.Text = aDistrictInfo.DistrictName;
        districtCodeTextBox.Text = aDistrictInfo.DistrictCode;
        //companyNameDropDownList.SelectedValue = aDistrictInfo.CompanyId.ToString();
        //CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        //aMasterBll.LoadRegionname(regionDropDownList, companyNameDropDownList.SelectedValue);
        //regionDropDownList.SelectedValue = aDistrictInfo.RegionId.ToString();
        //aMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionDropDownList.SelectedValue);
        //comUnitNameDropDownList.SelectedValue = aDistrictInfo.ComUnitId.ToString();
        
        

    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
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