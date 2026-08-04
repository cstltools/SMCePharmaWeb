using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_MiaInfoEntry : System.Web.UI.Page
{
    MIAInformationBLL aMiaInfoBll =new MIAInformationBLL();
    CustomerMasterBLL aCustomerMasterBll =new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }
    private void GetMiaInfo(string MiaCode)
    {
        if (!string.IsNullOrEmpty(MiaCode))
        {
            DataTable aDataTable = new DataTable();
            if (!string.IsNullOrEmpty(MiaCode))
            {
                aDataTable = aMiaInfoBll.EmpInfo(MiaCode);
                if (aDataTable.Rows.Count > 0)
                {
                    miaNameTextBox.Text = aDataTable.Rows[0]["EmpName"].ToString();
                }
                else
                {
                    Clear();
                    MessageLabel.Text = "Mia Information Not Found!!";
                }
            }
        }
    }


    public void LoadDropDown()
    {
        RegionInfoBLL aRegionInfoBll = new RegionInfoBLL();

        aRegionInfoBll.CompanyNameLoad(companyNameDropDownList);
        aMiaInfoBll.LoadManfac(manufacDropDownList);
        aCustomerMasterBll.LoadAreaName2(areaNameDropDownList);

    }
    private void Clear()
    {
        miaCodeTextBox.Text = string.Empty;
        miaNameTextBox.Text = string.Empty;
        regionNameDropDownList.Text = string.Empty;
        comUnitNameDropDownList.Text = string.Empty;
        districtNameDropDownList.Text = string.Empty;
        areaNameDropDownList.Text = string.Empty;
        companyNameDropDownList.SelectedValue = null;
        manufacDropDownList.SelectedValue = null;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (miaCodeTextBox.Text != "" && miaNameTextBox.Text != "" && areaNameDropDownList.SelectedValue != "")
        {
            MiaInformation aMiaInformation = new MiaInformation()
            {
                MiaCode = miaCodeTextBox.Text,
                MiaName = miaNameTextBox.Text,
               AreaId = Convert.ToInt32(areaNameDropDownList.SelectedValue)
            };

            MIAInformationBLL aMiaInfoBll = new MIAInformationBLL();
            MessageLabel.Text = aMiaInfoBll.SaveMiaInfo(aMiaInformation);
            bool x=  aMiaInfoBll.UpdateMIOCUstomer(areaNameDropDownList.SelectedItem.Text, miaCodeTextBox.Text,miaNameTextBox.Text);
            if (x == true)
            {
                Clear();
            }
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    protected void miaImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("MiaInfoView.aspx");
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
}