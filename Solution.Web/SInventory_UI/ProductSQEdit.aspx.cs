using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Library.BLL.SInventory_BLL;

using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProductSQEdit : System.Web.UI.Page
{
    ProductSQBLL aProductSQBLL = new ProductSQBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();
            productSQIdHiddenField.Value = Request.QueryString["ID"];
            ProductSQLoad(productSQIdHiddenField.Value);
        }
    }
    public void DropDownList()
    {
        ProductSQBLL aProductSQBll = new ProductSQBLL();
        aProductSQBll.LoadIngrident(ingridentDropDownList);
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (productSQTextBox.Text != "")
        { 
            ProductSQ aProductSQ = new ProductSQ()
            {
                ProductBrandId = Convert.ToInt32(productSQIdHiddenField.Value),
                ProductSQName = productSQTextBox.Text,
                //IngridentsId = Convert.ToInt32(ingridentDropDownList.SelectedValue),
            };
            ProductSQBLL aProductSQBLL = new ProductSQBLL();

            if (!aProductSQBLL.UpdateProductSQInfo(aProductSQ))
            {
                showMessageBox("Data Not Update!!!");
                
            }
            else
            {
                showMessageBox("Data Update Successfully!!! Please Reload");
                
            }
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void ProductSQLoad(string id)
    {
        ProductSQ aProductSQ = new ProductSQ();
        aProductSQ = aProductSQBLL.ProductSQEditLoad(id);
        productSQTextBox.Text = aProductSQ.ProductSQName;
        ingridentDropDownList.SelectedValue = aProductSQ.IngridentsId.ToString();
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}