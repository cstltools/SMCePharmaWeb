using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProCategoryEntry : System.Web.UI.Page
{
    ProductCategoriesBLL aCategoryBLL = new ProductCategoriesBLL();

    string Msg = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                proCetegoryIdHiddenField.Value = Request.QueryString["ID"];
                EmpCategoryLoad(proCetegoryIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }

    }

    private void EmpCategoryLoad(string proCetegoryId)
    {
        ProductCategory aCategory = new ProductCategory();
        aCategory = aCategoryBLL.ProductCategoryEditLoad(proCetegoryId);
        proCategoryNameTextBox.Text = aCategory.CategoryName;
    }

    private void Clear()
    {
        proCategoryNameTextBox.Text = string.Empty;
    }
    public enum MessageType { Success, Error, Info, Warning };
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (proCategoryNameTextBox.Text != "")
        {

            if (proCetegoryIdHiddenField.Value != "")
            {
                ProductCategory aCategory = new ProductCategory()
                {
                    CategoryId = Convert.ToInt32(proCetegoryIdHiddenField.Value),
                    CategoryName = proCategoryNameTextBox.Text

                };
                ProductCategoriesBLL aCategoryBll = new ProductCategoriesBLL();

                if (!aCategoryBll.UpdateDataForProductCategory(aCategory))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);



                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProCategoryView.aspx');", true);

                }
            }
            else
            {
                ProductCategory aProductCategory = new ProductCategory()
                {
                    CategoryName = proCategoryNameTextBox.Text
                };
                ProductCategoriesBLL aProductCategoriesBll = new ProductCategoriesBLL();
                Msg = aProductCategoriesBll.SaveProductCategory(aProductCategory);

                if (Msg == "Already Exist")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProCategoryView.aspx');", true);
                }
            }
        
            //ScriptManager.RegisterStartupScript(this, this.GetType(),
            //             "alert",
            //             "alert('"+ MessageLabel.Text + "');window.location ='ProCategoryView.aspx';",
            //             true);
        }
        else
        {
            showMessageBox("Please fill out this field!! ");
            proCategoryNameTextBox.Focus();
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Verifies that the control is rendered */
    }


    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProCategoryView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProCategoryView.aspx");
    }
}