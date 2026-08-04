using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CountryStockEntry : System.Web.UI.Page
{
    DCStoreBLL _aDCStoreReceiveBll = new DCStoreBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           Date();
        }
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
        if (chalanNoDateTextBox.Text == "")
        {
            showMessageBox("Please Input Company Name!!");
            return false;
        }

        if (chalanDateTextBox.Text == "")
        {
            showMessageBox("Please Input Company Address!!");
            return false;
        }
        if (productCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        if (productNameTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        if (packSizeTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        if (receiveDateTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        if (BatchNoTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        if (quantityTextBox.Text == "")
        {
            showMessageBox("Please Input Company Contact Number!!");
            return false;
        }
        return true;
    }
    public void Date()
    {
        receiveDateTextBox.Text = DateTime.Today.ToShortDateString();
    }
   
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {
        string productCode = productCodeTextBox.Text.Trim();
        DataTable aDataTable=new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            aDataTable = _aDCStoreReceiveBll.ProductInfo(productCode);
            if (aDataTable.Rows.Count > 0)
            {
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
                Date();
            }
            else
            {
                ClearAll();
                showMessageBox("Employee Information Not Found!!");
            }
        }
        Date();
    }
    
    protected void stockGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            //int rowCount = 0;
            int deletingIndex = Convert.ToInt32(e.CommandArgument);
            List<DCStore> aDCStoreList = new List<DCStore>();
            DCStore aDcStore;

            int StockId = Convert.ToInt32(stockGridView.DataKeys[deletingIndex][0].ToString());
            if (stockGridView.Rows.Count > 0)
            {
                for (int i = 0; i < stockGridView.Rows.Count; i++)
                {
                    if (StockId != Convert.ToInt32(stockGridView.DataKeys[i][0].ToString()))
                    {
                        //rowCount = stockGridView.Rows.Count + 1;
                        aDcStore = new DCStore()
                        {
                            //StockId = Convert.ToInt32(stockGridView.DataKeys[i][0].ToString()),
                            //ProductCode = stockGridView.Rows[i].Cells[0].Text,
                            //ProductName = stockGridView.Rows[i].Cells[1].Text,
                            //PackSize = stockGridView.Rows[i].Cells[2].Text,
                            //BatchNo = stockGridView.Rows[i].Cells[3].Text,
                            //Quantity = Convert.ToDecimal(stockGridView.Rows[i].Cells[4].Text.Trim()),
                            //ExpDate = Convert.ToDateTime(stockGridView.Rows[i].Cells[5].Text),
                        };
                        aDCStoreList.Add(aDcStore);
                    }
                }
            }

            stockGridView.DataSource = null;
            stockGridView.DataBind();
            stockGridView.DataSource = aDCStoreList;
            stockGridView.DataBind();
        }
    }
    protected void addToListButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
        int rowCount = 1;
        List<DCStore> aDCStoreList = new List<DCStore>();
        DCStore aStockReceive;

        if (stockGridView.Rows.Count > 0)
        {
            for (int i = 0; i < stockGridView.Rows.Count; i++)
            {
                aStockReceive = new DCStore()
                {
                    StockId = Convert.ToInt32(stockGridView.DataKeys[i][0].ToString()),
                    ProductCode = stockGridView.Rows[i].Cells[0].Text,
                    ProductName = stockGridView.Rows[i].Cells[1].Text,
                    PackSize = stockGridView.Rows[i].Cells[2].Text,
                    BatchNo = stockGridView.Rows[i].Cells[3].Text,
                    Quantity = Convert.ToDecimal(stockGridView.Rows[i].Cells[4].Text.Trim()),
                    ExpDate = Convert.ToDateTime(stockGridView.Rows[i].Cells[5].Text),

                };
                aDCStoreList.Add(aStockReceive);   
            }
        }

        if (stockGridView.Rows.Count > 0)
        {
            rowCount = (from item in aDCStoreList
                        select item.StockId).Max();
            rowCount += 1;
        }
       
        
        aStockReceive = new DCStore()
        {
            StockId=rowCount,
            ProductCode = productCodeTextBox.Text,
            ProductName = productNameTextBox.Text,
            PackSize = packSizeTextBox.Text,
            BatchNo = BatchNoTextBox.Text,
            Quantity = Convert.ToDecimal(quantityTextBox.Text),
            ExpDate = Convert.ToDateTime(expDateTextBox.Text)
        };

        aDCStoreList.Add(aStockReceive);

        stockGridView.DataSource = null;
        stockGridView.DataBind();
        stockGridView.DataSource = aDCStoreList;
        stockGridView.DataBind();
        }
        else
        {
           showMessageBox("Please input Data in texbox");
        }
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        List<DCStore> aDCStoreList = new List<DCStore>();
        List<CurrentStock> aCurrentStockList = new List<CurrentStock>();
        DCStore aStockReceive;
        CurrentStock aCurrentStock;
        for (int i = 0; i < stockGridView.Rows.Count; i++)
        {
            aCurrentStock = new CurrentStock()
                         {
                             
                             ProductCode = stockGridView.Rows[i].Cells[0].Text,
                             ProductName = stockGridView.Rows[i].Cells[1].Text,
                             PackSize = stockGridView.Rows[i].Cells[2].Text,
                             Quantity = Convert.ToDecimal(stockGridView.Rows[i].Cells[4].Text.Trim()),

                         };
            aCurrentStockList.Add(aCurrentStock);
        }

        for (int i = 0; i < stockGridView.Rows.Count; i++)
        {
            aStockReceive = new DCStore()
            {
                ProductCode = stockGridView.Rows[i].Cells[0].Text,
                ProductName = stockGridView.Rows[i].Cells[1].Text,
                PackSize = stockGridView.Rows[i].Cells[2].Text,
                BatchNo = stockGridView.Rows[i].Cells[3].Text,
                Quantity = Convert.ToDecimal(stockGridView.Rows[i].Cells[4].Text.Trim()),
                ExpDate = Convert.ToDateTime(stockGridView.Rows[i].Cells[5].Text),
                ChalanDate = Convert.ToDateTime(chalanDateTextBox.Text),
                ChalanNo = chalanNoDateTextBox.Text,
                ReceiveDate = Convert.ToDateTime(receiveDateTextBox.Text)


            };
            aDCStoreList.Add(aStockReceive);
        }
        if (_aDCStoreReceiveBll.SaveDhakaStock(aCurrentStockList, aDCStoreList))
        {
            showMessageBox("Data Save successfully");
        }
       
        ClearAll();
    }
    private void ClearAll()
    {
        productCodeTextBox.Text = string.Empty;
        productNameTextBox.Text = string.Empty;
        packSizeTextBox.Text = string.Empty;
        BatchNoTextBox.Text = string.Empty;
        quantityTextBox.Text = string.Empty;
        expDateTextBox.Text = string.Empty;
        receiveDateTextBox.Text = string.Empty;
        chalanDateTextBox.Text = string.Empty;
        chalanNoDateTextBox.Text = string.Empty;
        stockGridView.DataSource = null;
        stockGridView.DataBind();
    }
    
    protected void reportImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("../Report_UI/CountryStockRpt.aspx");
    }
    protected void stockReceiveImageButton_Click(object sender, ImageClickEventArgs e)
    {

    }
}