using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CompanyInfoEdit : System.Web.UI.Page
{
    CompanyInfoBLL aCompanyInfoBll = new CompanyInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            companyInfoIdHiddenField.Value = Request.QueryString["ID"];
            CompanyInfoLoad(companyInfoIdHiddenField.Value);
        }

    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (companyNameTextBox.Text != "" && addressNameTextBox.Text != "" && contactNoTextBox.Text != "" && faxNoTextBox.Text != "" && remarksTextBox.Text != "")
        {


            CompanyInformation aCompanyInfo = new CompanyInformation()
            {
                CompanyId = Convert.ToInt32(companyInfoIdHiddenField.Value),
                CompanyName = companyNameTextBox.Text,
                Address = addressNameTextBox.Text,
                ContactNo = contactNoTextBox.Text,
                FaxNo = faxNoTextBox.Text,
                Remarks = remarksTextBox.Text

            };
            CompanyInfoBLL aCompanyInfoBll = new CompanyInfoBLL();

            if (!aCompanyInfoBll.UpdateDataForCompanyInfo(aCompanyInfo))
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

    private void CompanyInfoLoad(string comapnyInfoId)
    {
        CompanyInformation aCompanyInfo = new CompanyInformation();
        aCompanyInfo = aCompanyInfoBll.CompanyInfoEditLoad(comapnyInfoId);
        companyNameTextBox.Text = aCompanyInfo.CompanyName;
        addressNameTextBox.Text = aCompanyInfo.Address;
        contactNoTextBox.Text = aCompanyInfo.ContactNo;
        faxNoTextBox.Text = aCompanyInfo.FaxNo;
        remarksTextBox.Text = aCompanyInfo.Remarks;

    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }
}