using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProductEdit : System.Web.UI.Page
{
    ProductBLL ProductBLL = new ProductBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProductCategory();
            productIdHiddenField.Value = Request.QueryString["ID"];
            ProductEditLoad(productIdHiddenField.Value);
        }
    }
    public void LoadProductCategory()
    {
        ProductBLL.LoadProductCategory(categoryNameDropDownList);
        ProductBLL.LoadManufac(manufacDropDownList);
        ProductBLL.LoadPackSize(packSizeDropDownList);
        ProductBLL.LoadStockUOM(stockUOMDropDownList);
        ProductBLL.LoadType(typeDropDownList);
        ProductBLL.LoadShippingCartonSize(shippingCartonSizeDropDownList);
        ProductBLL.LoadProductSQ(productSQDropDownList);
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (productNameTextBox.Text != "" && categoryNameDropDownList.SelectedValue != "" && descriptionTextBox.Text != "" )
        {
            Product aProduct = new Product()
            {
                ProductId = Convert.ToInt32(productIdHiddenField.Value),
                ProductCode = productCodeTextBox.Text,
                ProductName = productNameTextBox.Text,
                Description = descriptionTextBox.Text,
                PackSize = packSizeDropDownList.SelectedItem.Text,
                CategoryId = Convert.ToInt32(categoryNameDropDownList.SelectedValue),
                CategoryName = categoryNameDropDownList.SelectedItem.Text,
                ManufacId = Convert.ToInt32(manufacDropDownList.SelectedValue),
                PackSizeId = Convert.ToInt32(packSizeDropDownList.SelectedValue),
                StockUOMId = Convert.ToInt32(stockUOMDropDownList.SelectedValue),
                ProTypeId = Convert.ToInt32(typeDropDownList.SelectedValue),
                ProductBrandId = Convert.ToInt32(productSQDropDownList.SelectedValue),
                CaseId = Convert.ToInt32(shippingCartonSizeDropDownList.SelectedValue),
            };
            
            ProductBLL aProductBLL = new ProductBLL();

            if (!aProductBLL.UpdateDataForProduct(aProduct))
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
    private void ProductEditLoad(string productId)
    {
        Product Product = new Product();
        Product = ProductBLL.ProductEditLoad(productId);
        productNameTextBox.Text = Product.ProductName;
        descriptionTextBox.Text = Product.Description;
        categoryNameDropDownList.SelectedValue = Product.CategoryId.ToString();
        manufacDropDownList.SelectedValue = Product.ManufacId.ToString();
        packSizeDropDownList.SelectedValue = Product.PackSizeId.ToString();
        typeDropDownList.SelectedValue = Product.ProTypeId.ToString();
        productSQDropDownList.SelectedValue = Product.ProductBrandId.ToString();
        shippingCartonSizeDropDownList.SelectedValue = Product.CaseId.ToString();
        stockUOMDropDownList.SelectedValue = Product.StockUOMId.ToString();
        productCodeTextBox.Text = Product.ProductCode;
    }
    
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}