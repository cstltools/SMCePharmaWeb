using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Library.BLL.SInventory_BLL;

using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockUOMEdit : System.Web.UI.Page
{
    StockUOMBLL aStockUOMBLL = new StockUOMBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            stockUOMIdHiddenField.Value = Request.QueryString["ID"];
            StockUOMLoad(stockUOMIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (stockUOMNameTextBox.Text != "" )
        { 
            StockUOM aStockUOM = new StockUOM()
            {
                StockUOMId = Convert.ToInt32(stockUOMIdHiddenField.Value),
                StockUOMName = stockUOMNameTextBox.Text                
            };
            StockUOMBLL aStockUOMBLL = new StockUOMBLL();

            if (!aStockUOMBLL.UpdateStockUOMInfo(aStockUOM))
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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void StockUOMLoad(string id)
    {
        StockUOM aStockUOM = new StockUOM();
        aStockUOM = aStockUOMBLL.StockUOMEditLoad(id);
        stockUOMNameTextBox.Text = aStockUOM.StockUOMName;    
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}