using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProductSQEntry : System.Web.UI.Page
{
    ProductSQBLL aProductSQBLL = new ProductSQBLL();

    string Msg = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            DropDownList();
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                productSQIdHiddenField.Value = Request.QueryString["ID"];
                ProductSQLoad(productSQIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }
       
    }

    private void ProductSQLoad(string id)
    {
        ProductSQ aProductSQ = new ProductSQ();
        aProductSQ = aProductSQBLL.ProductSQEditLoad(id);
        productSQTextBox.Text = aProductSQ.ProductSQName;
        ingridentDropDownList.SelectedValue = aProductSQ.IngridentsId.ToString();
    }

    public void DropDownList()
    {
        ProductSQBLL aProductSQBll = new ProductSQBLL();
        aProductSQBll.LoadIngrident(ingridentDropDownList);
    }
    private void Clear()
    {
        productSQTextBox.Text = string.Empty;
        ingridentDropDownList.SelectedValue = string.Empty;

    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (productSQTextBox.Text != "")
        {


            if (productSQIdHiddenField.Value != "")
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
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProductSQView.aspx');", true);

                }
            }
            else
            {
                ProductSQ aProductSQ = new ProductSQ()
                {
                    ProductSQName = productSQTextBox.Text,
                    //IngridentsId = Convert.ToInt32(ingridentDropDownList.SelectedValue)


                };
                ProductSQBLL aProductSQBll = new ProductSQBLL();
                Msg = aProductSQBll.SaveProductSQ(aProductSQ);
                if (Msg == "Already Exist")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProductSQView.aspx');", true);
                }
            }
        }
        else
        {
            showMessageBox("Please fill out this field!! ");
            productSQTextBox.Focus();
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
       
    }

    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProductSQView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        
        Response.Redirect("ProductSQEntry.aspx");

    }
}