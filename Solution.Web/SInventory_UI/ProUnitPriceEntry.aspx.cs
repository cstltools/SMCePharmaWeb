using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_ProUnitPriceEntry : System.Web.UI.Page
{
    UnitPriceBLL aUnitPriceBLL = new UnitPriceBLL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                using (DataTable dt = _seedRepo.GetProductNameList())
                {
                    ddlProductName.DataSource = dt;
                    ddlProductName.DataValueField = "ProductId";
                    ddlProductName.DataTextField = "ProductName";
                    ddlProductName.DataBind();
                    ddlProductName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlProductName.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            if (Session["UnitPrice"] !=null)
            {
                unitPriceIdHiddenField.Value = Session["UnitPrice"].ToString();
                ProductEditLoad(unitPriceIdHiddenField.Value);
                Session["UnitPrice"] = null;
            }
        }
    }

    private void GetProductInfo(string productCode)
    {
        if (!string.IsNullOrEmpty(productCode))
        {
            DataTable aDataTable = new DataTable();
            if (!string.IsNullOrEmpty(productCode))
            {
                aDataTable = aUnitPriceBLL.ProductInfo(productCode);
                if (aDataTable.Rows.Count > 0)
                {
                    productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                    packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
                    productCodeTextBox.Text = aDataTable.Rows[0]["ProductCode"].ToString();
                    productIdHiddenField.Value = aDataTable.Rows[0]["ProductId"].ToString();
                }
                else
                {

                    showMessageBox("Product Information Not Found!!");
                }
            }
        }
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
        productCodeTextBox.Text = string.Empty;
        productNameTextBox.Text = string.Empty;
        packSizeTextBox.Text = string.Empty;
        costPriceTextBox.Text = string.Empty;
        unitPriceTextBox.Text = string.Empty;
        productIdHiddenField.Value = null;
        vatperTextBox.Text = string.Empty;
        vatAmountTextBox.Text = string.Empty;
        RadioButtonList1.Items[0].Selected = false;
        RadioButtonList1.Items[1].Selected = false;
        @new.Visible = false;
        unitPriceIdHiddenField.Value = string.Empty;
        activeDtTextBox.Text = string.Empty;
        inactiveTextBox.Text = string.Empty;
        newCostPriceTextBox.Text = string.Empty;
        newUnitPriceTextBox.Text = string.Empty;
        newactiveDtTextBox.Text = string.Empty;
        newvatAmountTextBox.Text = string.Empty;
        newvatPerceTextBox.Text = string.Empty;
    }

    

    private bool Validation()
    {

        if (ddlProductName.SelectedValue == "")
        {
            showMessageBox("Please Select Product!!");
            ddlProductName.Focus();
            return false;
        }
        if (productCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Product Code!!");
            productCodeTextBox.Focus();
            return false;
        }
        if (costPriceTextBox.Text == "")
        {
            showMessageBox("Please Input Cost Price!!");
            costPriceTextBox.Focus();
            return false;
        }

        if (unitPriceTextBox.Text == "")
        {
            showMessageBox("Please Input Unit Price!!");
            unitPriceTextBox.Focus();

            return false;
        }

        if (vatperTextBox.Text == "")
        {
            showMessageBox("Please Input Vat!!");
            vatperTextBox.Focus();

            return false;
        }

        if (vatAmountTextBox.Text == "")
        {
            showMessageBox("Please Input Vat Amount!!");
            vatAmountTextBox.Focus();

            return false;
        }

        if (txtMRP.Text == "")
        {
            showMessageBox("Please Input MRP!!");
            txtMRP.Focus();

            return false;
        }

        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            if (unitPriceIdHiddenField.Value == null || string.IsNullOrEmpty(unitPriceIdHiddenField.Value))
            {


                ProductUnitPrice aProductUnitPrice = new ProductUnitPrice()
                {
                    ProductCode = productCodeTextBox.Text,
                    ProductName = productNameTextBox.Text,
                    PackSize = packSizeTextBox.Text,
                    CostPrice = Convert.ToDecimal(costPriceTextBox.Text),
                    UnitPrice = Convert.ToDecimal(unitPriceTextBox.Text),
                    ProductId = Convert.ToInt32(productIdHiddenField.Value),
                    VATPercentage = Convert.ToDecimal(vatperTextBox.Text),
                    VATAmountPerUnit = Convert.ToDecimal(vatAmountTextBox.Text),
                    MRPPrice = Convert.ToDecimal(txtMRP.Text),
                    IsActive = true,
                    ActiveDate = Convert.ToDateTime(activeDtTextBox.Text),

                };

                UnitPriceBLL aUnitPriceBLL = new UnitPriceBLL();
                if (aUnitPriceBLL.SaveUnitPrice(aProductUnitPrice))
                {
                    showMessageBox("Data Save Successfully  Product Name  is :  " + aProductUnitPrice.ProductName +
                                   " And  Product Price is :" + aProductUnitPrice.UnitPrice);
                    Clear();
                }
                else
                {
                    showMessageBox("Product Price Already Exist !!");
                }
            }
            else
            {
                aUnitPriceBLL.UpdateActive(Convert.ToDateTime(inactiveTextBox.Text), unitPriceIdHiddenField.Value);
                ProductUnitPrice aProductUnitPrice = new ProductUnitPrice()
                {
                    ProductCode = productCodeTextBox.Text,
                    ProductName = productNameTextBox.Text,
                    PackSize = packSizeTextBox.Text,
                    CostPrice = Convert.ToDecimal(newCostPriceTextBox.Text),
                    UnitPrice = Convert.ToDecimal(newUnitPriceTextBox.Text),
                    ProductId = Convert.ToInt32(productIdHiddenField.Value),
                    VATPercentage = Convert.ToDecimal(newvatPerceTextBox.Text),
                    VATAmountPerUnit = Convert.ToDecimal(newvatAmountTextBox.Text),
                    MRPPrice = Convert.ToDecimal(txtMRP.Text),

                    IsActive = true,
                    ActiveDate = Convert.ToDateTime(newactiveDtTextBox.Text),

                };

                
                if (aUnitPriceBLL.SaveUnitPriceEdit(aProductUnitPrice))
                {
                    showMessageBox("Data Save Successfully  Product Name  is :  " + aProductUnitPrice.ProductName +
                                   " And  Product Price is :" + aProductUnitPrice.UnitPrice);
                    Clear();
                }
                else
                {
                    showMessageBox("Product Price Already Exist !!");
                }

            }
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }

    private void ProductEditLoad(string productId)
    {
        ProductUnitPrice aProductUnitPrice = new ProductUnitPrice();
        aProductUnitPrice = aUnitPriceBLL.ProductUnitPriceEditLoad(productId);
        ddlProductName.SelectedValue= Convert.ToString(aProductUnitPrice.ProductId);
        //ddlProductName_SelectedIndexChanged(null, null);
        productCodeTextBox.Text = aProductUnitPrice.ProductCode;
        productNameTextBox.Text = aProductUnitPrice.ProductName;
        packSizeTextBox.Text = aProductUnitPrice.PackSize;
        costPriceTextBox.Text = aProductUnitPrice.CostPrice.ToString();
        unitPriceTextBox.Text = aProductUnitPrice.UnitPrice.ToString();
        productIdHiddenField.Value = aProductUnitPrice.ProductId.ToString();
        vatperTextBox.Text = aProductUnitPrice.VATPercentage.ToString();
        vatAmountTextBox.Text = aProductUnitPrice.VATAmountPerUnit.ToString();
        txtMRP.Text = aProductUnitPrice.MRPPrice.ToString();
        activeDtTextBox.Text = aProductUnitPrice.ActiveDate.ToString("dd-MMM-yyyy");

        if (aProductUnitPrice.IsActive)
        {
            RadioButtonList1.Items[0].Selected = true;
        }
        else
        {
            RadioButtonList1.Items[1].Selected = true;

        }
    }
    
    protected void productImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("ProUnitPriceView.aspx");
    }

    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProUnitPriceView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProUnitPriceEntry.aspx");
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string productCode = productCodeTextBox.Text.Trim();
        GetProductInfo(productCode);
        
    }
    protected void productNameTextBox_TextChanged(object sender, EventArgs e)
    {
        string productName = productNameTextBox.Text.Trim();
        if (!string.IsNullOrEmpty(productName))
        {
            if (productName.Contains(':'))
            {
                string[] productInfo = productName.Split(':');
                productCodeTextBox.Text = productInfo[0];
                string productCode = productCodeTextBox.Text.Trim();
                GetProductInfo(productCode);
            }
        }
    }
    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList1.Items[1].Selected==true)
        {
            if (!string.IsNullOrEmpty(unitPriceIdHiddenField.Value))
            {
                @new.Visible = true;    
            }
            else
            {
                RadioButtonList1.Items[0].Selected = false;
                RadioButtonList1.Items[1].Selected = false;

                showMessageBox("Use Edit Mode to use that function ");
                
            }
            
        }
        else
        {
            @new.Visible = false;
        }
    }

    protected void ddlProductName_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (ddlProductName.SelectedValue != "")
        {
            GetProductInfo(ddlProductName.SelectedValue);
        }
        
    }
}