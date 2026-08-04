using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ChallanVIewEditNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            salesCenterInfoIdHiddenField.Value = Request.QueryString["ID"];
            ComUnitLoad(salesCenterInfoIdHiddenField.Value);
        }

    }
    ChallanReportViewBLL _companyUnitBll = new ChallanReportViewBLL();
    private void ComUnitLoad(string salesCenterId)
    {
        Requesition companyUnit = new Requesition();
        companyUnit = _companyUnitBll.SalesCenterEditLoad(salesCenterId);
        salesCenterInfoIdHiddenField.Value = companyUnit.ReqId.ToString();
        clnDateTextBox.Text = Convert.ToDateTime(companyUnit.IssuChalanDate).ToString("dd-MMM-yyyy");
        driverNameTextBox.Text = companyUnit.DriverName;
        truckNoTextBox.Text = companyUnit.TruckNo;
       
        //companyNameDropDownList.SelectedValue = companyUnit.CompanyId.ToString();
        //CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        //aMasterBll.LoadRegionname(regionDropDownList, companyNameDropDownList.SelectedValue);
        //regionDropDownList.SelectedValue = companyUnit.RegionId.ToString();

    }

    protected void bmitButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            Requesition aCompanyUnit = new Requesition()
            {
                ReqId = Convert.ToInt32(salesCenterInfoIdHiddenField.Value),
                IssuChalanDate = Convert.ToDateTime(clnDateTextBox.Text),
                DriverName = driverNameTextBox.Text,
                TruckNo = truckNoTextBox.Text
                //CompanyId = Convert.ToInt32(companyNameDropDownList.SelectedValue),
                //CompanyName = companyNameDropDownList.SelectedItem.Text,
                //RegionId = Convert.ToInt32(regionDropDownList.SelectedValue),
                //RegionName = regionDropDownList.SelectedItem.Text
            };
            

            if (!_companyUnitBll.UpdateDataForSalesCenter(aCompanyUnit))
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
    }

    private bool Validation()
    {
        if (clnDateTextBox.Text=="")
        {
            showMessageBox("Please Enter Challan Date!!");
            return false;
        }

        //if (truckNoTextBox.Text == "")
        //{
        //    showMessageBox("Please Enter Truck No. !!");
        //    return false;
        //}

        //if (driverNameTextBox.Text == "")
        //{
        //    showMessageBox("Please Enter Driver No.!!");
        //    return false;
        //}


        return true;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}