using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Policy;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProductBonusEntry : System.Web.UI.Page
{
    ProductDiscountBLL aProductDiscountBll=new ProductDiscountBLL();
    private CustPaymentBLL aCustPaymentBll = new CustPaymentBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();
        }
    }
    private void Clear()
    {
        productCodeTextBox.Text = string.Empty;
        customerTextBox.Text = string.Empty;
        discountPerTextBox.Text = string.Empty;
        activeDtTextBox.Text = string.Empty;
        inactiveDtTextBox.Text = string.Empty;
        customerNameTextBox1.Text = string.Empty;
         productNameTextBox2.Text = string.Empty;
        MessageLabel.Text = "";
    }

    public void DropDownList()
    {
        
        //aProductDiscountBll.LoadSalesCenter(salesCenterDropDownList);   
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        //if (productCodeTextBox.Text != "" && customerTextBox.Text != "" && activeDtTextBox.Text != "" && inactiveDtTextBox.Text != ""
        //    && discountPerTextBox.Text != "")
        //{
        //    CustomerMaster aCustomerMaster;
        //    ProductDiscount aProductDiscount= new ProductDiscount()
        //    {
        //        ProductCode = productCodeTextBox.Text.Trim(),
        //        CustomerMasterId = CustomerId(out aCustomerMaster),
        //        DiscountPercentage=Convert.ToDecimal(discountPerTextBox.Text),
        //        Status = "Active",
        //        ActiveDate = Convert.ToDateTime(activeDtTextBox.Text),
        //        InactiveDate = Convert.ToDateTime(inactiveDtTextBox.Text),
        //    };
        //    if (aProductDiscountBll.SaveProductDiscount(aProductDiscount))
        //    {
        //        MessageLabel.Text = "Data Saved Successfully";
        //    }
        //    Clear();
        //}
        //else
        //{
        //    MessageLabel.Text = "Please input data in all Textbox";
        //}
    }
    protected void customerTextBox_TextChanged(object sender, EventArgs e)
    {
        CustomerMaster aCustomerMaster = new CustomerMaster();
        aCustomerMaster = aCustPaymentBll.DetailCustomerLoad(customerTextBox.Text.Trim());
        customerNameTextBox1.Text = aCustomerMaster.CustomerName;

    }
    private int CustomerId(out CustomerMaster aCustomerMaster)
    {
        int CustomerID = 0;
        aCustomerMaster = new CustomerMaster();
        aCustomerMaster = aCustPaymentBll.CustomerLoad(customerTextBox.Text.Trim());
        CustomerID = aCustomerMaster.CustomerMasterId;
        return CustomerID;
    }
  
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        Product aProduct = new Product();
        aProduct = aCustPaymentBll.DetailProductLoad(productCodeTextBox.Text.Trim());
        productNameTextBox2.Text = aProduct.ProductName;
    }
}