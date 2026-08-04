using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CustomerMasterEdit : System.Web.UI.Page
{
    CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            custMastIdHiddenField.Value = Request.QueryString["ID"];
            CompanyInfoLoad(custMastIdHiddenField.Value);
        }
    }

    public void LoadDropDown()
    {
        CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
        aCustomerMasterBLL.LoadCategoryName(categoryNameDropDownList);
        aCustomerMasterBLL.LoadRegionname(regionNameDropDownList);
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
        if (paymentTypeDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Payment Type !!");
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
        return true;
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
             string[] CUnit = comUnitNameDropDownList.SelectedItem.Text.Split(':');
            string[] MarketName = marketNameDropDownList.SelectedItem.Text.Split(':');
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
                MarketName = MarketName[0],
                //marketNameDropDownList.SelectedItem.Text,
                MIACode = miaNameDropDownList.SelectedValue,
                MiaName = miaNameDropDownList.SelectedItem.Text,
                AreaCode = areaNameDropDownList.SelectedValue,
                DisCode = districtNameDropDownList.SelectedValue,
                FEName = feNameTextBox.Text,
                ComUnitCode = comUnitNameDropDownList.SelectedValue,
                ComUnitName = CUnit[0],
                RegionCode = regionNameDropDownList.SelectedValue,
                DZSMName = dzsmNameTextBox.Text,
                TermOfPayment = paymentTypeDropDownList.SelectedItem.Text,
            };
            CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
            DataTable dtcustomerProformaButNoDelevery = aCustomerMasterBLL.Customer(custMastIdHiddenField.Value);
            DataTable dtcustomerPaymentNotFull = aCustomerMasterBLL.CustomerPayment(custMastIdHiddenField.Value);
            DataTable dtcustomerOrderSubmitted = aCustomerMasterBLL.Customerorder(customerCodeTextBox.Text);
           // if (dtcustomerOrderSubmitted.Rows.Count < 1)
            //{
                if (dtcustomerProformaButNoDelevery.Rows.Count < 1)
                {
                    if (dtcustomerPaymentNotFull.Rows.Count < 1)
                    {
                        if (!aCustomerMasterBLL.UpdateDataForCustomerMaster(aCustomerMaster))
                        {
                            showMessageBox("Data Not Update!!!");
                        }
                        else
                        {
                            showMessageBox("Data Update Successfully!!! Please Reload");
                        }
                    }
                    else
                    {
                        showMessageBox("Payment Pending !!");
                    }
                }
                else
                {
                    showMessageBox("Delivery Pending !!");
                }
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
        aCustomerMaster = aCustomerMasterBLL.CustomerMasterEditLoad(custMastId);
        customernameTextBox.Text = aCustomerMaster.CustomerName;
        
        addressTextBox.Text = aCustomerMaster.Address;
        contactTextBox.Text = aCustomerMaster.CellNo;
        paymentTypeDropDownList.SelectedValue = aCustomerMaster.PaymentType;
        regionNameDropDownList.SelectedValue = aCustomerMaster.RegionCode.ToString();
        aCustomerMasterBLL.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);

        comUnitNameDropDownList.SelectedValue = aCustomerMaster.ComUnitCode.ToString();
        
        aCustomerMasterBLL.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);

        districtNameDropDownList.SelectedValue = aCustomerMaster.DisCode.ToString();
        aCustomerMasterBLL.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);

        areaNameDropDownList.SelectedValue = aCustomerMaster.AreaCode.ToString();
        aCustomerMasterBLL.LoadMiaName(miaNameDropDownList, areaNameDropDownList.SelectedValue);

        miaNameDropDownList.SelectedValue = aCustomerMaster.MIACode.ToString();

        aCustomerMasterBLL.LoadMarketName(marketNameDropDownList, miaNameDropDownList.SelectedValue);

        marketNameDropDownList.SelectedValue = aCustomerMaster.MarketCode.ToString();

        categoryNameDropDownList.SelectedValue = aCustomerMaster.CategoryId.ToString();
        customerCodeTextBox.Text = aCustomerMaster.CustomerCodeOld.ToString();
        addressTextBox2.Text = aCustomerMaster.Addrees2.ToString();
        cityTextBox.Text = aCustomerMaster.City.ToString();
        contactPersonTextBox.Text = aCustomerMaster.ConPerson.ToString();
        shippingConditionTextBox.Text = aCustomerMaster.ShippingCond.ToString();
        feNameTextBox.Text = aCustomerMaster.FEName.ToString();
        dzsmNameTextBox.Text = aCustomerMaster.DZSMName.ToString();
        paymentTypeDropDownList.SelectedValue = aCustomerMaster.TermOfPayment.ToString();
        customerCodeTextBox.Text = aCustomerMaster.CustomerCode;
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    protected void regionNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //aCustomerMasterBLL.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);
    }
    protected void areaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {

        //aCustomerMasterBLL.LoadMiaName(miaNameDropDownList, areaNameDropDownList.SelectedValue);
    }
    protected void comUnitNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //aCustomerMasterBLL.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);

    }
    protected void districtNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //aCustomerMasterBLL.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);
    }

    protected void miaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //aCustomerMasterBLL.LoadMarketName(marketNameDropDownList, miaNameDropDownList.SelectedValue);
    }
    
}