using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_SupplierInformation : System.Web.UI.Page
{
    SupplierInfoDal aCompanyInfoBll = new SupplierInfoDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            productidHiddenField.Value = Request.QueryString["SupplierId"];

            if (productidHiddenField.Value != "")
            {
                LoadDataForUpdate(Convert.ToInt32(productidHiddenField.Value));
            }

        }
    }

    private void LoadDataForUpdate(int supplierid)
    {
        DataTable aTable = aCompanyInfoBll.LoadSupplierInfoById(supplierid);

        if (aTable.Rows.Count > 0)
        {
            productidHiddenField.Value = supplierid.ToString(CultureInfo.InvariantCulture);
            companynameTextBox.Text = aTable.Rows[0]["SupplierName"].ToString();
            companyAddressTextBox.Text = aTable.Rows[0]["SupplierAddress"].ToString();
            contactTextBox.Text = aTable.Rows[0]["ContactNo"].ToString();
        }
        else
        {
            ShowMessageBox("No Data found !!!");
        }
    }


    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void Clear()
    {
        companynameTextBox.Text = string.Empty;      
        companyAddressTextBox.Text = string.Empty;
        contactTextBox.Text = string.Empty;
       
    }
    private bool Validation()
    {
        if (companynameTextBox.Text == "")
        {
            ShowMessageBox("Please Input Supplier Name!!");
            return false;
        }

        //if (cmpShortNameTextBox.Text == "")
        //{
        //    ShowMessageBox("Please Input Company Short Name!!");
        //    return false;
        //}

        if (companyAddressTextBox.Text == "")
        {
            ShowMessageBox("Please Input  Address!!");
            return false;
        }

        if (contactTextBox.Text == "")
        {
            ShowMessageBox("Please Input Contact Number!!");
            return false;
        }

        return true;
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {

            if (productidHiddenField.Value == "")
            {
                var aCompanyInfo = new SupplierInformation()
                {
                    SupplierName = companynameTextBox.Text.Trim(),
                    Address = companyAddressTextBox.Text.Trim(),
                    ContactNo = contactTextBox.Text.Trim(),
                    EntryBy = Session["LoginName"].ToString(),
                    EntryDate = DateTime.Now
                };

                if (aCompanyInfoBll.SaveCompanyInfoData(aCompanyInfo))
                {
                    ShowMessageBox("Data Save Successfully & Supplier name is :" + aCompanyInfo.SupplierName);
                    Clear();
                }
                else
                {
                    ShowMessageBox("Supplier already exist !!");
                }
            }

            if (productidHiddenField.Value != "")
            {
                var aCompanyInfo = new SupplierInformation()
                {
                    SupplierId = Convert.ToInt32(productidHiddenField.Value),
                    SupplierName = companynameTextBox.Text.Trim(),
                    Address = companyAddressTextBox.Text.Trim(),
                    ContactNo = contactTextBox.Text.Trim(),
                    UpdateBy = Session["LoginName"].ToString(),
                    UpdateDate = DateTime.Now
                };

                if (!aCompanyInfoBll.CheckDuplicate(aCompanyInfo))
                {
                    if (aCompanyInfoBll.UpdateCompanyInfoData(aCompanyInfo))
                    {
                        ShowMessageBox("Data Updated Successfully & Supplier name is: " + aCompanyInfo.SupplierName);
                        Clear();
                    }
                   
                }
                else
                {
                    ShowMessageBox("Supplier already exist !!");
                }
                
            }
            
        }
        else
        {
            ShowMessageBox("Company Code already exist");
        }
    }
    protected void CompanyListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("SupplierInfoView.aspx");
    }

    protected void clearButton_OnClick(object sender, EventArgs e)
    {
        Clear();
    }

    //protected void companynameTextBox_OnTextChanged(object sender, EventArgs e)
    //{
    //    DataTable companyInfo = aCompanyInfoBll.CheckCompanyInfoExistOrNot(companynameTextBox.Text.Trim());
    //    GotoPermissionSetUp(companyInfo, companynameTextBox,"Company Name already Exist !!!");

    //}

    private void GotoPermissionSetUp(DataTable aTable, TextBox textBox, string msg)
    {
        if (aTable.Rows.Count > 0)
        {
            textBox.Text = "";
            ShowMessageBox(msg);
        }
    }

    //protected void cmpShortNameTextBox_OnTextChanged(object sender, EventArgs e)
    //{
    //    DataTable companyInfo = aCompanyInfoBll.CheckCompanyShortNameExistOrNot(cmpShortNameTextBox.Text.Trim());
    //    GotoPermissionSetUp(companyInfo, cmpShortNameTextBox, "Company short Name already Exist !!!");
    //}

}