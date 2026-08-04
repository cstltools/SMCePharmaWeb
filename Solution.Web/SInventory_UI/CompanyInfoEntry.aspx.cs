using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CompanyInfoEntry : System.Web.UI.Page
{
    CompanyInfoBLL aCompanyInfoBll = new CompanyInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void Clear()
    {
        companynameTextBox.Text = string.Empty;
        companyAddressTextBox.Text = string.Empty;
        contactTextBox.Text = string.Empty;
        faxNoTextBox.Text = string.Empty;
        remarksTextBox.Text = string.Empty;
    }
    private bool Validation()
    {
        if (companynameTextBox.Text == "")
        {
            showMessageBox("Please Input Company Name!!");
            return false;
        }

        if (companyAddressTextBox.Text == "")
        {
            showMessageBox("Please Input Company Address!!");
            return false;
        }
        if (contactTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        return true;
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            CompanyInformation aCompanyInfo = new CompanyInformation()
            {
                CompanyName = companynameTextBox.Text,
                Address = companyAddressTextBox.Text,
                ContactNo = contactTextBox.Text,
                FaxNo = faxNoTextBox.Text,
                Remarks = remarksTextBox.Text,
            };

            CompanyInfoBLL aCompanyInfoBll = new CompanyInfoBLL();
            if (aCompanyInfoBll.SaveCompanyInfoData(aCompanyInfo))
            {
                showMessageBox("Data Save Successfully Company Code  is :  " + aCompanyInfo.CompanyCode + " And CompanyName is :" + aCompanyInfo.CompanyName);
                Clear();
            }
        }
        else
        {
            showMessageBox("Company Name already exist");
        }
    }
    protected void CompanyListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CompanyInfoView.aspx");
    }
}