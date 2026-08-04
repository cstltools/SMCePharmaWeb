using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_AreaEdit : System.Web.UI.Page
{
    AreaBLL areaBLL = new AreaBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DistrictName();
            areaInfoIdHiddenField.Value = Request.QueryString["ID"];
            AreaInfoLoad(areaInfoIdHiddenField.Value);
        }
    }
    
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (areanameTextBox.Text != "" )
        {
            AreaInfo areaInfo = new AreaInfo()
            {
                AreaId = Convert.ToInt32(areaInfoIdHiddenField.Value),
                AreaCode = areaCodeTextBox.Text,
                AreaName = areanameTextBox.Text,
                //DistrictName = districtDropDownList.SelectedItem.Text,
                //DistrictId = Convert.ToInt32(districtDropDownList.SelectedValue),
            };
            AreaBLL aAreaBLL = new AreaBLL();

            if (!aAreaBLL.UpdateDataForAreaInfo(areaInfo))
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

    private void AreaInfoLoad(string areaId)
    {
        AreaInfo areaInfo = new AreaInfo();
        areaInfo = areaBLL.AreaInfoEditLoad(areaId);
        areanameTextBox.Text = areaInfo.AreaName;
        areaCodeTextBox.Text = areaInfo.AreaCode;
        //companyNameDropDownList.SelectedValue = areaInfo.CompanyId.ToString();
        //CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        //aMasterBll.LoadRegionname(regionDropDownList, companyNameDropDownList.SelectedValue);
        //regionDropDownList.SelectedValue = areaInfo.RegionId.ToString();
        //aMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionDropDownList.SelectedValue);
        //comUnitNameDropDownList.SelectedValue = areaInfo.ComUnitId.ToString();
        //aMasterBll.LoadDistrictName(districtDropDownList, comUnitNameDropDownList.SelectedValue);
        //districtDropDownList.SelectedValue = areaInfo.DistrictId.ToString();
        
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    public void DistrictName()
    {
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
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