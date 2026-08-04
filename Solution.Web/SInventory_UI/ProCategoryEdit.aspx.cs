using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProCategoryEdit : System.Web.UI.Page
{
    ProductCategoriesBLL aCategoryBLL = new ProductCategoriesBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            proCetegoryIdHiddenField.Value = Request.QueryString["ID"];
            EmpCategoryLoad(proCetegoryIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (proCetegoryNameTextBox.Text != "")
        {
            ProductCategory aCategory = new ProductCategory()
            {
                CategoryId = Convert.ToInt32(proCetegoryIdHiddenField.Value),
                CategoryName = proCetegoryNameTextBox.Text

            };
            ProductCategoriesBLL aCategoryBll = new ProductCategoriesBLL();

            if (!aCategoryBll.UpdateDataForProductCategory(aCategory))
            {
                ShowMessageBox("Data Not Update!!!");
                
            }
            else
            {
                ShowMessageBox("Data Update Successfully!!! Please Reload");
                
            }
        }
        else
        {
            ShowMessageBox("Please input data in all Textbox");
        }
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void EmpCategoryLoad(string proCetegoryId)
    {
        ProductCategory aCategory = new ProductCategory();
        aCategory = aCategoryBLL.ProductCategoryEditLoad(proCetegoryId);
        proCetegoryNameTextBox.Text = aCategory.CategoryName;
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}