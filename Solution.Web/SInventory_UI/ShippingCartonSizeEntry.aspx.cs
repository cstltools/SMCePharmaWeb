using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ShippingCartonSizeEntry : System.Web.UI.Page
{
    ShippingCartonSizeBLL aShippingCartonSizeBll = new ShippingCartonSizeBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                shippingcartoonIdHiddenField.Value = Request.QueryString["ID"];
                ShippingCartonSizeLoad(shippingcartoonIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }
    }

    private void ShippingCartonSizeLoad(string ID)
    {
        ShippingCartonSize aShippingCartonSize = new ShippingCartonSize();
        aShippingCartonSize = aShippingCartonSizeBll.ShippingCartonSizeEditLoad(ID);
        caseQtyTextBox.Text = aShippingCartonSize.CaseQty;
        pcsPerCaseTextBox.Text = aShippingCartonSize.PcsPerCase;
        // productNameDropDownList.SelectedValue = aShippingCartonSize.ProductCode;
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void Clear()
    {
        caseQtyTextBox.Text = string.Empty;
        pcsPerCaseTextBox.Text = string.Empty;
       // productNameDropDownList.SelectedIndex = 0;

    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (caseQtyTextBox.Text != "")
        {
            if (shippingcartoonIdHiddenField.Value != "")
            {
                ShippingCartonSize aShippingCartonSize = new ShippingCartonSize()
                {
                    CaseId = Convert.ToInt32(shippingcartoonIdHiddenField.Value),
                    // ProductCode = productNameDropDownList.SelectedValue,
                    CaseQty = caseQtyTextBox.Text,
                    PcsPerCase = pcsPerCaseTextBox.Text
                };
                ShippingCartonSizeBLL aShippingCartonSizeBll = new ShippingCartonSizeBLL();
                if (!aShippingCartonSizeBll.UpdateShippingCartonSizeInfo(aShippingCartonSize))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ShippingCartonSizeView.aspx');", true);

                }
            }
            else
            {
                ShippingCartonSize aShippingCartonSize = new ShippingCartonSize()
                {
                    //  ProductCode = productNameDropDownList.SelectedValue,
                    CaseQty = caseQtyTextBox.Text,
                    PcsPerCase = pcsPerCaseTextBox.Text,

                };
                ShippingCartonSizeBLL aShippingCartonSizeBll = new ShippingCartonSizeBLL();

                if (aShippingCartonSizeBll.SaveShippingCartonSize(aShippingCartonSize))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ShippingCartonSizeView.aspx');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }

            }
        }
        else
        {
            ShowMessageBox("Please input data in all Textbox");
        }
    }
    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ShippingCartonSizeView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ShippingCartonSizeEntry.aspx");
    }

}