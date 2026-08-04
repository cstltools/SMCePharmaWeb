using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockReceive : System.Web.UI.Page
{
    CentralStoreBLL _aCentralStoreBll = new CentralStoreBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           Date();
        }
    }
    public void Date()
    {
        receiveDateTextBox.Text = DateTime.Today.ToShortDateString();
    }

    private void GetProductInfo(string productCode)
    {
        if (!string.IsNullOrEmpty(productCode))
        {
            DataTable aDataTable = new DataTable();
            if (!string.IsNullOrEmpty(productCode))
            {
                aDataTable = _aCentralStoreBll.ProductInfo(productCode);
                if (aDataTable.Rows.Count > 0)
                {
                    productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                    packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
                    unitPriceTextBox.Text = aDataTable.Rows[0]["UnitPrice"].ToString();
                }
                else
                {
                    Clear();
                    MessageLabel.Text = "Product Information Not Found!!";
                }
            }
        }
    }
    private void Clear()
    {
        internalNoteNoTextBox.Text = string.Empty;
        productCodeTextBox.Text = string.Empty;
        productNameTextBox.Text = string.Empty;
        packSizeTextBox.Text = string.Empty;
        BatchNoTextBox.Text = string.Empty;
        quantityTextBox.Text = string.Empty;
        expDateTextBox.Text = string.Empty;
        receiveDateTextBox.Text = string.Empty;
        unitPriceTextBox.Text = string.Empty;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (productCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Product Code!!");
            return false;
        }
        if (BatchNoTextBox.Text == "")
        {
            showMessageBox("Please Input Batch!!");
            return false;
        }

        if (quantityTextBox.Text == "")
        {
            showMessageBox("Please Input Quantity!!");
            return false;
        }
        
        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation()==true)
        {
            List<CentralStore> aStockReceiveList=new List<CentralStore>();
            CentralStore aCentralStore = new CentralStore()
            {
                InternalNoteNo = internalNoteNoTextBox.Text,
                ProductCode = productCodeTextBox.Text,
                ProductName = productNameTextBox.Text,
                PackSize = packSizeTextBox.Text,
                BatchNo = BatchNoTextBox.Text,
                Quantity = Convert.ToDecimal(quantityTextBox.Text),
                ExpDate = Convert.ToDateTime(expDateTextBox.Text),
                ReceiveDate = Convert.ToDateTime(receiveDateTextBox.Text),
                StockInQty = Convert.ToDecimal(quantityTextBox.Text),
                UnitPrice = Convert.ToDecimal(unitPriceTextBox.Text)

            };
            aStockReceiveList.Add(aCentralStore);
            CurrentStock aCurrentStock = new CurrentStock()
            {
                ProductCode = productCodeTextBox.Text,
                ProductName = productNameTextBox.Text,
                PackSize = packSizeTextBox.Text,
                Quantity = Convert.ToDecimal(quantityTextBox.Text),
            };
            MessageLabel.Text = _aCentralStoreBll.SaveStockReceive(aCurrentStock, aStockReceiveList);
            
            Clear();
            Date();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void stockReceiveImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("StockReceiveView.aspx");
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string productCode = productCodeTextBox.Text.Trim();
        GetProductInfo(productCode);
        Date();
    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        string url = "../Report_UI/CurrentStockRpt.aspx";
        string fullURL = "window.open('" + url + "', '_blank', 'height=700,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
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
}