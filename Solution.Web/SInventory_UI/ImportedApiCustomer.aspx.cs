using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ImportedApiCustomer : System.Web.UI.Page
{
    ImportedApiCustomerBll apiCustomerBll = new ImportedApiCustomerBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDownList();
            custMastIdHiddenField.Value = Request.QueryString["ID"];
            ApiCustomerInfoLoad(custMastIdHiddenField.Value);
        }
    }

    private void LoadDropDownList()
    {
        apiCustomerBll.LoadDistributionCenterName(comUnitNameDropDownList);
        apiCustomerBll.LoadDZSMInfo(regionNameDropDownList);
        apiCustomerBll.LoadFEInfo(districtNameDropDownList);
        apiCustomerBll.LoadTerritoryInfo(areaNameDropDownList);
        apiCustomerBll.LoadMiaInfo(miaNameDropDownList);
        apiCustomerBll.LoadMaketInfo(marketNameDropDownList);
    }


    private void ApiCustomerInfoLoad(string customerId)
    {
        CustomerMaster aCustomerMaster = new CustomerMaster();

        aCustomerMaster = apiCustomerBll.CustomerMasterEditLoad(customerId);
        customerCodeTextBox.Text = aCustomerMaster.CustomerCode;

        if (aCustomerMaster.CustomerName != "")
        {
            customernameTextBox.Text = aCustomerMaster.CustomerName;
        }

        if (aCustomerMaster.Address != "")
        {
            addressTextBox.Text = aCustomerMaster.Address;
        }


        if (aCustomerMaster.CellNo != "")
        {
            contactTextBox.Text = aCustomerMaster.CellNo;
        }

        if (aCustomerMaster.PaymentType != "")
        {
            paymentTypeDropDownList.SelectedValue = aCustomerMaster.PaymentType;
        }

        if (aCustomerMaster.RegionCode != "")
        {
            regionNameDropDownList.SelectedValue = aCustomerMaster.RegionCode;
        }


        if (aCustomerMaster.ComUnitCode != "")
        {
            comUnitNameDropDownList.SelectedValue = aCustomerMaster.ComUnitCode;
        }


        if (aCustomerMaster.DisCode != "")
        {
            districtNameDropDownList.SelectedValue = aCustomerMaster.DisCode;
        }

        if (aCustomerMaster.AreaCode != "")
        {
            areaNameDropDownList.SelectedValue = aCustomerMaster.AreaCode;
        }


        if (areaNameDropDownList.SelectedValue != "")
        {
            DataTable TeritoryDataTable = new DataTable();
            TeritoryDataTable = apiCustomerBll.LoadTeritoryName(areaNameDropDownList.SelectedValue);

            if (TeritoryDataTable.Rows.Count > 0)
            {
                territoryNameTextBox.Text = TeritoryDataTable.Rows[0].Field<String>("AreaName");
            }
        }


        if (aCustomerMaster.MIACode != "")
        {
            miaNameDropDownList.SelectedValue = aCustomerMaster.MIACode;
        }


        if (miaNameDropDownList.SelectedValue != "")
        {
            DataTable MiaDataTable = new DataTable();
            MiaDataTable = apiCustomerBll.LoadMiaName(miaNameDropDownList.SelectedValue);

            if (MiaDataTable.Rows.Count > 0)
            {
                mioNameTextBox.Text = MiaDataTable.Rows[0].Field<String>("MiaName");
            }
        }


        if (aCustomerMaster.MarketCode != "")
        {
            marketNameDropDownList.SelectedValue = aCustomerMaster.MarketCode;
        }


        if (marketNameDropDownList.SelectedValue != "")
        {
            DataTable marketDataTable = new DataTable();
            marketDataTable = apiCustomerBll.LoadMarketName(marketNameDropDownList.SelectedValue);

            if (marketDataTable.Rows.Count > 0)
            {
                marketNameTextBox.Text = marketDataTable.Rows[0].Field<String>("MarketName");
            }
        }

        if (aCustomerMaster.Addrees2 != "")
        {
            addressTextBox2.Text = aCustomerMaster.Addrees2;
        }

        if (aCustomerMaster.City != "")
        {
            cityTextBox.Text = aCustomerMaster.City;
        }


        if (aCustomerMaster.ConPerson != "")
        {
            contactPersonTextBox.Text = aCustomerMaster.ConPerson;
        }

        if (aCustomerMaster.FEName != "")
        {
            feNameTextBox.Text = aCustomerMaster.FEName;
        }

        if (aCustomerMaster.DZSMName != "")
        {
            dzsmNameTextBox.Text = aCustomerMaster.DZSMName;
        }


        if (aCustomerMaster.TermOfPayment != "")
        {
            paymentTypeDropDownList.SelectedValue = aCustomerMaster.TermOfPayment;
        }


        if (aCustomerMaster.FixedCustomer.ToString() != "")
        {
            fbDropDownList.SelectedValue = fbDropDownList.Items.FindByText(aCustomerMaster.FixedCustomer.ToString()).Value;
        }  
    }


    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }


    protected void regionNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = apiCustomerBll.LoadDZSMName(regionNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            dzsmNameTextBox.Text = aDataTable.Rows[0].Field<String>("RegionName");
        }

    }
    protected void areaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = apiCustomerBll.LoadTeritoryName(areaNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            territoryNameTextBox.Text = aDataTable.Rows[0].Field<String>("AreaName");
        }
    }
    protected void districtNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = apiCustomerBll.LoadFEName(districtNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            feNameTextBox.Text = aDataTable.Rows[0].Field<String>("DistrictName");
        }
    }

    protected void miaNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = apiCustomerBll.LoadMiaName(miaNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            mioNameTextBox.Text = aDataTable.Rows[0].Field<String>("MiaName");
        }
    }

    protected void marketNameDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable = apiCustomerBll.LoadMarketName(marketNameDropDownList.SelectedValue);

        if (aDataTable.Rows.Count > 0)
        {
            marketNameTextBox.Text = aDataTable.Rows[0].Field<String>("MarketName");
        }
    }


    private bool Validation()
    {
        if (customerCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Customer Code  !!");
            return false;
        }

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

        if (addressTextBox2.Text == "")
        {
            showMessageBox("Please Input Customer Address Second  !!");
            return false;
        }

        if (contactTextBox.Text == "")
        {
            showMessageBox("Please Input Contact Number!!");
            return false;
        }


        if (cityTextBox.Text == "")
        {
            showMessageBox("Please Input City name!!");
            return false;
        }

        if (contactPersonTextBox.Text == "")
        {
            showMessageBox("Please Input Contact person Name  !!");
            return false;
        }
        

        if (comUnitNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input DC  !!");
            return false;
        }


        if (regionNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please select DZSM Code  !!");
            return false;
        }

        if (dzsmNameTextBox.Text == "")
        {
            showMessageBox("Please Input DZSM Name  !!");
            return false;
        }

        if (districtNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input FE  !!");
            return false;
        }

        if (feNameTextBox.Text == "")
        {
            showMessageBox("Please Input FE Name  !!");
            return false;
        }

        if (areaNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input territory code  !!");
            return false;
        }

        if (territoryNameTextBox.Text == "")
        {
            showMessageBox("Please Input territory Name  !!");
            return false;
        }

        if (miaNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input MIO  !!");
            return false;
        }

        if (mioNameTextBox.Text == "")
        {
            showMessageBox("Please Input MIO Name  !!");
            return false;
        }

        if (marketNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input Market code !!");
            return false;
        }

        if (marketNameTextBox.Text == "")
        {
            showMessageBox("Please Input Market name !!");
            return false;
        }
      
        if (paymentTypeDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input payment type  !!");
            return false;
        }
        if (fbDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input Fixed Business  !!");
            return false;
        }

        return true;
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {

        if (Validation())
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
                Address = addressTextBox.Text,
                Addrees2 = addressTextBox2.Text,
                CellNo = contactTextBox.Text,
                City = cityTextBox.Text,
                ConPerson = contactPersonTextBox.Text,
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
                TermOfPayment = paymentTypeDropDownList.SelectedItem.Text,
                FixedCustomer = fixedCustomer,
            };

            if (apiCustomerBll.UpdateApiCustomerInfo(aCustomerMaster))
            {
                showMessageBox("Data Updated Successfully!!!");
            }
        }

        
    }
}