using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CustMasterEntry : System.Web.UI.Page
{
    CustomerMasterInfoBll aMasterInfoBll = new CustomerMasterInfoBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            SetShipingCondition();
            SetDefaultType();
           // SetCustomerCode();
        }
    }

    private void SetDefaultType()
    {
        isActiveCheckBoxList.Checked = true;
    }

    private void SetCustomerCode()
    {
        DataTable customerData = new DataTable();
        customerData = aMasterInfoBll.LoadCustomerMasterId();
        Int32 custCode = 0;

        if (customerData.Rows.Count > 0)
        {
            custCode = Convert.ToInt32(customerData.Rows[0].Field<String>("CustomerCode")) + 1;
            customerCodeTextBox.Text = custCode.ToString();
        }
    }

    private void SetShipingCondition()
    {
        shippingConditionTextBox.Text = "N/A";
    }

    public void LoadDropDown()
    {
        aMasterInfoBll.LoadDistributionCenterName(comUnitNameDropDownList);
        aMasterInfoBll.LoadDZSMInfo(regionNameDropDownList);
        aMasterInfoBll.LoadFEInfo(districtNameDropDownList);
        aMasterInfoBll.LoadTerritoryInfo(areaNameDropDownList);
        aMasterInfoBll.LoadMiaInfo(miaNameDropDownList);
        aMasterInfoBll.LoadMaketInfo(marketNameDropDownList);
        aMasterInfoBll.LoadCategoryName(categoryNameDropDownList);
    }

    private void Clear()
    {
        customernameTextBox.Text = string.Empty;
        addressTextBox.Text = string.Empty;
        contactTextBox.Text = string.Empty;
        paymentTypeDropDownList.SelectedValue = null;
        marketNameDropDownList.SelectedValue = null;
        areaNameDropDownList.SelectedValue = null;
        comUnitNameDropDownList.SelectedValue = null;
        districtNameDropDownList.SelectedValue = null;
        regionNameDropDownList.SelectedValue = null;
        miaNameDropDownList.SelectedValue = null;
        categoryNameDropDownList.SelectedValue = null;
        customerCodeTextBox.Text = string.Empty;
        addressTextBox2.Text = string.Empty;
        cityTextBox.Text = string.Empty;
        contactPersonTextBox.Text = string.Empty;
        //shippingConditionTextBox.Text = string.Empty;
        feNameTextBox.Text = string.Empty;
        dzsmNameTextBox.Text = string.Empty;

        mioNameTextBox.Text = "";
        marketNameTextBox.Text = "";
        territoryNameTextBox.Text = "";

        SetShipingCondition();
        SetDefaultType();
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
        if (customernameTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Name!!");
            return false;
        }
        if (addressTextBox.Text == "")
        {
            showMessageBox("Please Input Address!!");
            return false;
        }

        if (contactTextBox.Text == "")
        {
            showMessageBox("Please Input Mobail Number!!");
            return false;
        }
        if (miaNameDropDownList.Text == "")
        {
            showMessageBox("Please chose Representitive Name !!");
            return false;
        }

        if (regionNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Region  !!");
            return false;
        }
        if (comUnitNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input DC  !!");
            return false;
        }
        if (districtNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input FE  !!");
            return false;
        }
        if (areaNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Area  !!");
            return false;
        }
        if (miaNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input MIO  !!");
            return false;
        }
        if (marketNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Market  !!");
            return false;
        }
        if (categoryNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Category  !!");
            return false;
        }
        if (customerCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Code  !!");
            return false;
        }
        if (customerCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Code  !!");
            return false;
        }
        if (customernameTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Name  !!");
            return false;
        }
        if (addressTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Address  !!");
            return false;
        }
        if (addressTextBox2.Text == "")
        {
            showMessageBox("Please Input Customer Address Second  !!");
            return false;
        }
        if (contactTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Contact No  !!");
            return false;
        }
        if (cityTextBox.Text == "")
        {
            showMessageBox("Please Input Customer City  !!");
            return false;
        }
        if (contactPersonTextBox.Text == "")
        {
            showMessageBox("Please Input Contact Person  !!");
            return false;
        }
        if (shippingConditionTextBox.Text == "")
        {
            showMessageBox("Please Input Shipping Condition  !!");
            return false;
        }
        if (feNameTextBox.Text == "")
        {
            showMessageBox("Please Input FE Name  !!");
            return false;
        }
        if (dzsmNameTextBox.Text == "")
        {
            showMessageBox("Please Input DZSM Name  !!");
            return false;
        }

        if (!isActiveCheckBoxList.Checked)
        {
            if (inActiveDateTextBox.Text == "")
            {
                showMessageBox("Please select inactive date !!");
                return false;
            }
        }
        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            string[] CUnit = comUnitNameDropDownList.SelectedItem.Text.Split(':');
            bool fixedCustomer = false;

            if (fbDropDownList.SelectedValue == "1")
            {
                fixedCustomer = true;
            }

            //string[] MarketName = marketNameDropDownList.SelectedItem.Text.Split(':');

            CustomerMaster aCompanyInfo = new CustomerMaster()
            {
                CustomerCode = customerCodeTextBox.Text,
                CustomerName = customernameTextBox.Text,

                CategoryId = Convert.ToInt32(categoryNameDropDownList.SelectedValue),
                Address = addressTextBox.Text,
                Addrees2 = addressTextBox2.Text,

                CellNo = contactTextBox.Text,
                City = cityTextBox.Text,

                ConPerson = contactPersonTextBox.Text,
                ShippingCond = shippingConditionTextBox.Text,

                MarketCode = marketNameDropDownList.SelectedValue,
                MarketName = marketNameTextBox.Text,

                MIACode = miaNameDropDownList.SelectedValue,
                MiaName = mioNameTextBox.Text,

                AreaCode = areaNameDropDownList.SelectedValue,

                DisCode = districtNameDropDownList.SelectedValue,
                FEName = feNameTextBox.Text,

                ComUnitCode = comUnitNameDropDownList.SelectedValue,
                ComUnitName = CUnit[0],

                RegionCode = regionNameDropDownList.SelectedValue,
                DZSMName = dzsmNameTextBox.Text,

                TermOfPayment = paymentTypeDropDownList.SelectedValue,
                FixedCustomer = fixedCustomer,

            };

            if (!isActiveCheckBoxList.Checked)
            {
                if (inActiveDateTextBox.Text != "")
                {
                    aCompanyInfo.InActiveDate = inActiveDateTextBox.Text;
                }
            }
           
            aCompanyInfo.IsActive = isActiveCheckBoxList.Checked;
            

            CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
            if (aMasterInfoBll.SaveCustMasterInfo(aCompanyInfo))
            {
                showMessageBox("Data Save Successfully Customer Master Code  is :  " + aCompanyInfo.CustomerCode + " And Customer Master Name is :" + aCompanyInfo.CustomerName);
                Clear();
                //SetCustomerCode();
            }
            else
            {
                showMessageBox(" Customer Code already exist");
            }
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }
    protected void custMasterListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CustomerMasterView.aspx");
    }
    protected void regionNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = aMasterInfoBll.LoadDZSMName(regionNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            dzsmNameTextBox.Text = aDataTable.Rows[0].Field<String>("RegionName");
        }
        
    }
    protected void areaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = aMasterInfoBll.LoadTeritoryName(areaNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            territoryNameTextBox.Text = aDataTable.Rows[0].Field<String>("AreaName");
        }
    }
    protected void districtNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = aMasterInfoBll.LoadFEName(districtNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            feNameTextBox.Text = aDataTable.Rows[0].Field<String>("DistrictName");
        }
    }

    protected void miaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = aMasterInfoBll.LoadMiaName(miaNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            mioNameTextBox.Text = aDataTable.Rows[0].Field<String>("MiaName");
        }
    }

    protected void marketNameDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = aMasterInfoBll.LoadMarketName(marketNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            marketNameTextBox.Text = aDataTable.Rows[0].Field<String>("MarketName");
        }
    }

    protected void isActiveCheckBoxList_OnCheckedChanged(object sender, EventArgs e)
    {
        if (!isActiveCheckBoxList.Checked)
        {
            inActiveDateTextBox.Enabled = true;
            imgDatse.Enabled = true;
        }
        else
        {
            inActiveDateTextBox.Text = "";
            inActiveDateTextBox.Enabled = false;
            imgDatse.Enabled = false;
        }
    }
}