using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CustMasterEdit : System.Web.UI.Page
{

    CustomerMasterInfoBll aMasterInfoBll = new CustomerMasterInfoBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            SetShipingCondition();
            custMastIdHiddenField.Value = Request.QueryString["ID"];
            CompanyInfoLoad(custMastIdHiddenField.Value);
        }
    }

    private void SetShipingCondition()
    {
        shippingConditionTextBox.Text = "N/A";
    }

    private void LoadDropDown()
    {
        aMasterInfoBll.LoadDistributionCenterName(comUnitNameDropDownList);
        aMasterInfoBll.LoadDZSMInfo(regionNameDropDownList);
        aMasterInfoBll.LoadFEInfo(districtNameDropDownList);
        aMasterInfoBll.LoadTerritoryInfo(areaNameDropDownList);
        aMasterInfoBll.LoadMiaInfo(miaNameDropDownList);
        aMasterInfoBll.LoadMaketInfo(marketNameDropDownList);
        aMasterInfoBll.LoadCategoryName(categoryNameDropDownList);
    }

    private void showMessageBox(string message)
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
        //if (paymentTypeDropDownList.SelectedIndex == 0)
        //{
        //    showMessageBox("Please Input Payment Type !!");
        //    return false;
        //}
        //if (regionNameDropDownList.SelectedIndex == 0)
        //{
        //    showMessageBox("Please Input Region  !!");
        //    return false;
        //}
        if (comUnitNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input DC  !!");
            return false;
        }
        if (districtNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input FE  !!");
            return false;
        }
        if (areaNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input Area  !!");
            return false;
        }
        if (miaNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input MIO  !!");
            return false;
        }
        if (marketNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input Market  !!");
            return false;
        }
        if (categoryNameDropDownList.SelectedValue == "")
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

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
             string[] CUnit = comUnitNameDropDownList.SelectedItem.Text.Split(':');
            //string[] MarketName = marketNameDropDownList.SelectedItem.Text.Split(':');

             bool fixedCustomer = false;

             if (fbDropDownList.SelectedValue == "1")
             {
                 fixedCustomer = true;
             }

            CustomerMaster aCustomerMaster = new CustomerMaster()
            {
                CustomerMasterId = Convert.ToInt32(custMastIdHiddenField.Value),
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
            //CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();


            if (!isActiveCheckBoxList.Checked)
            {
                if (inActiveDateTextBox.Text != "")
                {
                    aCustomerMaster.InActiveDate = inActiveDateTextBox.Text;
                }
            }

            aCustomerMaster.IsActive = isActiveCheckBoxList.Checked;

            DataTable dtcustomerProformaButNoDelevery = aMasterInfoBll.Customer(custMastIdHiddenField.Value);
            DataTable dtcustomerPaymentNotFull = aMasterInfoBll.CustomerPayment(custMastIdHiddenField.Value);

            //DataTable dtcustomerOrderSubmitted = aCustomerMasterBLL.Customerorder(customerCodeTextBox.Text);
           // if (dtcustomerOrderSubmitted.Rows.Count < 1)
            //{
                //if (dtcustomerProformaButNoDelevery.Rows.Count < 1)
                //{
                //    if (dtcustomerPaymentNotFull.Rows.Count < 1)
                //    {
                        if (!aMasterInfoBll.UpdateDataForCustomerMaster(aCustomerMaster))
                        {
                            showMessageBox("Data Not Update!!!");
                        }
                        else
                        {
                            showMessageBox("Data Update Successfully!!! Please Reload");
                        }
                //    }
                //    else
                //    {
                //        showMessageBox("Payment Pending !!");
                //    }
                //}
                //else
                //{
                //    showMessageBox("Delivery Pending !!");
                //}
            //}
            //else
            //{
            //    showMessageBox("New Order is Submitted For this Customer !!");
            //}
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }

    private void CompanyInfoLoad(string custMastId)
    {
        CustomerMaster aCustomerMaster = new CustomerMaster();

        aCustomerMaster = aMasterInfoBll.CustomerMasterEditLoad(custMastId);
        customernameTextBox.Text = aCustomerMaster.CustomerName;

        isActiveCheckBoxList.Checked = aCustomerMaster.IsActive;

        if (aCustomerMaster.InActiveDate != null)
        {
            inActiveDateTextBox.Text = aCustomerMaster.InActiveDate;
        }

        isActiveCheckBoxList_OnCheckedChanged(null,null);
        
        addressTextBox.Text = aCustomerMaster.Address;
        contactTextBox.Text = aCustomerMaster.CellNo;
        paymentTypeDropDownList.SelectedValue = aCustomerMaster.PaymentType;

        regionNameDropDownList.SelectedValue = aCustomerMaster.RegionCode;
        
        //aCustomerMasterBLL.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);

        comUnitNameDropDownList.SelectedValue = aCustomerMaster.ComUnitCode;
        
        //aCustomerMasterBLL.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);

        districtNameDropDownList.SelectedValue = aCustomerMaster.DisCode;
        
        //aCustomerMasterBLL.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);

        areaNameDropDownList.SelectedValue = aCustomerMaster.AreaCode;

        DataTable TeritoryDataTable = new DataTable();
        TeritoryDataTable = aMasterInfoBll.LoadTeritoryName(areaNameDropDownList.SelectedValue);

        if (TeritoryDataTable.Rows.Count > 0)
        {
            territoryNameTextBox.Text = TeritoryDataTable.Rows[0].Field<String>("AreaName");
        }
        //aCustomerMasterBLL.LoadMiaName(miaNameDropDownList, areaNameDropDownList.SelectedValue);

        miaNameDropDownList.SelectedValue = aCustomerMaster.MIACode;

        DataTable MiaDataTable = new DataTable();
        MiaDataTable = aMasterInfoBll.LoadMiaName(miaNameDropDownList.SelectedValue);

        if (MiaDataTable.Rows.Count > 0)
        {
            mioNameTextBox.Text = MiaDataTable.Rows[0].Field<String>("MiaName");
        }

        //aCustomerMasterBLL.LoadMarketName(marketNameDropDownList, miaNameDropDownList.SelectedValue);

        marketNameDropDownList.SelectedValue = aCustomerMaster.MarketCode;
        DataTable marketDataTable = new DataTable();
        marketDataTable = aMasterInfoBll.LoadMarketName(marketNameDropDownList.SelectedValue);

        if (marketDataTable.Rows.Count > 0)
        {
            marketNameTextBox.Text = marketDataTable.Rows[0].Field<String>("MarketName");
        }

        categoryNameDropDownList.SelectedValue = aCustomerMaster.CategoryId.ToString();
        customerCodeTextBox.Text = aCustomerMaster.CustomerCodeOld;
        addressTextBox2.Text = aCustomerMaster.Addrees2;
        cityTextBox.Text = aCustomerMaster.City;
        contactPersonTextBox.Text = aCustomerMaster.ConPerson;
        shippingConditionTextBox.Text = aCustomerMaster.ShippingCond;
        feNameTextBox.Text = aCustomerMaster.FEName;
        dzsmNameTextBox.Text = aCustomerMaster.DZSMName;
        paymentTypeDropDownList.SelectedValue = aCustomerMaster.TermOfPayment;
        customerCodeTextBox.Text = aCustomerMaster.CustomerCode;
        fbDropDownList.SelectedValue = fbDropDownList.Items.FindByText(aCustomerMaster.FixedCustomer.ToString()).Value;
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
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