using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_MiaInfoEdit : System.Web.UI.Page
{
    MIAInformationBLL aMIAInfoBLL = new MIAInformationBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            miaInfoIdHiddenField.Value = Request.QueryString["ID"];
            MiaInformationLoad(miaInfoIdHiddenField.Value);
            
        }
    }

    public void LoadDropDown()
    {
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
        aMIAInfoBLL.LoadManfac(manufacDropDownList);
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (refCodeTextBox.Text != "" && refNameTextBox.Text != ""  )
        {
            MiaInformation aMiaInformation = new MiaInformation()
            {
                MiaId = Convert.ToInt32(miaInfoIdHiddenField.Value),
                MiaCode = refCodeTextBox.Text,
                MiaName = refNameTextBox.Text,
                //AreaId = Convert.ToInt32(areaNameDropDownList.SelectedValue),
                //ManufacId = Convert.ToInt32(manufacDropDownList.SelectedValue)
               
            };
            MIAInformationBLL aMIAInfoBLL = new MIAInformationBLL();

            if (!aMIAInfoBLL.UpdateDataForMiaInformation(aMiaInformation))
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

    private void MiaInformationLoad(string miaId)
    {
        MiaInformation MiaInformation = new MiaInformation();
        MiaInformation = aMIAInfoBLL.MiaInformationEditLoad(miaId);
        refNameTextBox.Text = MiaInformation.MiaName;
        refCodeTextBox.Text = MiaInformation.MiaCode;
        //companyNameDropDownList.SelectedValue = MiaInformation.CompanyId.ToString();
        //CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        //aMasterBll.LoadRegionname(regionNameDropDownList, companyNameDropDownList.SelectedValue);
        //regionNameDropDownList.SelectedValue = MiaInformation.RegionId.ToString();
        //aCustomerMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);
        //comUnitNameDropDownList.SelectedValue = MiaInformation.ComUnitId.ToString();
        //aCustomerMasterBll.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);
        //districtNameDropDownList.SelectedValue = MiaInformation.DistrictId.ToString();
        //aCustomerMasterBll.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);
        //areaNameDropDownList.SelectedValue = MiaInformation.AreaId.ToString();
        //manufacDropDownList.SelectedValue = MiaInformation.ManufacId.ToString();

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

    protected void miaNameTextBox_TextChanged(object sender, EventArgs e)
    {

    }

    protected void miaCodeTextBox_TextChanged(object sender, EventArgs e)
    {

    }
    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadRegionname(regionNameDropDownList, companyNameDropDownList.SelectedValue);
    }   
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}