using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CustCategoryEdit : System.Web.UI.Page
{
    CustomerCategoryBLL aCategoryBLL = new CustomerCategoryBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            cusCetegoryIdHiddenField.Value = Request.QueryString["ID"];
            EmpCategoryLoad(cusCetegoryIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (custCetegoryNameTextBox.Text != "")
        {
            CustomerCategory aCategory = new CustomerCategory()
            {
                CategoryId = Convert.ToInt32(cusCetegoryIdHiddenField.Value),
                CategoryName = custCetegoryNameTextBox.Text

            };
            CustomerCategoryBLL aCategoryBll = new CustomerCategoryBLL();

            if (!aCategoryBll.UpdateDataForCusCategory(aCategory))
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
    private void EmpCategoryLoad(string custCetegoryId)
    {
        CustomerCategory aCategory = new CustomerCategory();
        aCategory = aCategoryBLL.CustCategoryInfoEditLoad(custCetegoryId);
        custCetegoryNameTextBox.Text = aCategory.CategoryName;
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}