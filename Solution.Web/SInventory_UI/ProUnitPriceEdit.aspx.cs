using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProUnitPriceEdit : System.Web.UI.Page
{
    UnitPriceBLL UnitPriceBLL = new UnitPriceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            unitPriceIdHiddenField.Value = Request.QueryString["ID"];
            ProductEditLoad(unitPriceIdHiddenField.Value);
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (costPriceTextBox.Text != "" && productCodeTextBox.Text != "" && productNameTextBox.Text != "" && packSizeTextBox.Text != "")
        {
            ProductUnitPrice aProductUnitPrice = new ProductUnitPrice()
            {
                UnitPriceId = Convert.ToInt32(unitPriceIdHiddenField.Value),
                CostPrice = Convert.ToDecimal(unitPriceTextBox.Text),
                UnitPrice = Convert.ToDecimal(unitPriceTextBox.Text),
                ProductCode = productCodeTextBox.Text,
                ProductName = productNameTextBox.Text,
                PackSize = packSizeTextBox.Text,
                ProductId = Convert.ToInt32(productIdHiddenField.Value),
                VATPercentage = Convert.ToDecimal(vatperTextBox.Text),
                VATAmountPerUnit = Convert.ToDecimal(vatAmountTextBox.Text),
            };

            UnitPriceBLL aUnitPriceBLL = new UnitPriceBLL();

            if (!aUnitPriceBLL.UpdateDataForProductUnitPrice(aProductUnitPrice))
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
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    private void ProductEditLoad(string productId)
    {
        ProductUnitPrice aProductUnitPrice = new ProductUnitPrice();
        aProductUnitPrice = UnitPriceBLL.ProductUnitPriceEditLoad(productId);
        productCodeTextBox.Text = aProductUnitPrice.ProductCode;
        productNameTextBox.Text = aProductUnitPrice.ProductName;
        packSizeTextBox.Text = aProductUnitPrice.PackSize;
        costPriceTextBox.Text = aProductUnitPrice.CostPrice.ToString();
        unitPriceTextBox.Text = aProductUnitPrice.UnitPrice.ToString();
        productIdHiddenField.Value = aProductUnitPrice.ProductId.ToString();
        vatperTextBox.Text = aProductUnitPrice.VATPercentage.ToString();
        vatAmountTextBox.Text = aProductUnitPrice.VATAmountPerUnit.ToString();
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string productCode = productCodeTextBox.Text.Trim();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            aDataTable = UnitPriceBLL.ProductInfo(productCode);
            if (aDataTable.Rows.Count > 0)
            {
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
                productIdHiddenField.Value = aDataTable.Rows[0]["ProductId"].ToString();
            }
            else
            {
                
                MessageLabel.Text = "Employee Information Not Found!!";
            }
        }
    }
}