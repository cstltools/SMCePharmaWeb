using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockUOMEntry : System.Web.UI.Page
{
    string Msg = "";
    StockUOMBLL aStockUOMBLL = new StockUOMBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                stockUOMIdHiddenField.Value = Request.QueryString["ID"];
                StockUOMLoad(stockUOMIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }
    }
    private void StockUOMLoad(string id)
    {
        StockUOM aStockUOM = new StockUOM();
        aStockUOM = aStockUOMBLL.StockUOMEditLoad(id);
        stockUOMNameTextBox.Text = aStockUOM.StockUOMName;
    }
    private void Clear()
    {
        stockUOMNameTextBox.Text = string.Empty;
        
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (stockUOMNameTextBox.Text != "")
        {
            if (stockUOMIdHiddenField.Value != "")
            {
                StockUOM aStockUOM = new StockUOM()
                {
                    StockUOMId = Convert.ToInt32(stockUOMIdHiddenField.Value),
                    StockUOMName = stockUOMNameTextBox.Text
                };
                StockUOMBLL aStockUOMBLL = new StockUOMBLL();

                if (!aStockUOMBLL.UpdateStockUOMInfo(aStockUOM))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','StockUOMView.aspx');", true);

                }
            }
            else
            {
                StockUOM aStockUOM = new StockUOM()
                {
                    StockUOMName = stockUOMNameTextBox.Text,

                };
                StockUOMBLL aStockUOMBll = new StockUOMBLL();
                Msg = aStockUOMBll.SaveStockUOM(aStockUOM);
                if (Msg == "Already Exist")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','StockUOMView.aspx');", true);
                }
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
    protected void ListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("StockUOMView.aspx");
    }

    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("StockUOMView.aspx");

    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("StockUOMEntry.aspx");
    }
}