using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_AdjustmentEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {

    }


    protected void viewLinkButton_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("AdjustmentTypeView.aspx");
    }
    private void Clear()
    {
        empCategoryNameTextBox.Text = string.Empty;
    }
    CustomerCategoryDAL aCustomerCategoryDAL = new CustomerCategoryDAL();
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (empCategoryNameTextBox.Text != "")
        {
            CustomerCategory aCustomerCategory = new CustomerCategory()
            {
                CategoryName = empCategoryNameTextBox.Text
            };
            CustomerCategoryBLL aCategoryBll = new CustomerCategoryBLL();
            aCustomerCategoryDAL.SaveAdjustment(aCustomerCategory);
            MessageLabel.Text = "Data Save Successfully";
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void EmpCetegoryListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("AdjustmentTypeView.aspx");
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("AdjustmentEntry.aspx");

    }
}