using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_OrderEdit : System.Web.UI.Page
{
    CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            custMastIdHiddenField.Value = Request.QueryString["ID"];
            LoadDropDown();
        }
    }

    public void LoadDropDown()
    {

        CustomerMasterDAL aMasterBll = new CustomerMasterDAL();
        aMasterBll.LoadCompanyUnitbyID(comUnitNameDropDownList, comUnitNameDropDownList.SelectedValue);
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
        if (comUnitNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Input Distribution Center Name !!");
            return false;
        }
        return true;
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            string[] DC = comUnitNameDropDownList.SelectedItem.Text.Split(':');
            OrderInfoMaster aOrderInfoMaster = new OrderInfoMaster();
            {
                aOrderInfoMaster.OrderId = Convert.ToInt32(custMastIdHiddenField.Value);
                aOrderInfoMaster.ComUnitId = Convert.ToInt32(comUnitNameDropDownList.SelectedValue);
                aOrderInfoMaster.ComUnitCode = DC[1];
                aOrderInfoMaster.ComUnitName = DC[0];
            };
            OrderListBLL aOrderListBLL = new OrderListBLL();
            aOrderListBLL.UpdateDataForCompanyInfo(aOrderInfoMaster);
            showMessageBox("Updated!!");
            comUnitNameDropDownList.SelectedValue = string.Empty;

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

        comUnitNameDropDownList.SelectedValue = aCustomerMaster.ComUnitCode.ToString();
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