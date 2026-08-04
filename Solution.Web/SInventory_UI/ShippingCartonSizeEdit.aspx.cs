using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ShippingCartonSizeEdit : System.Web.UI.Page
{
    ShippingCartonSizeBLL aShippingCartonSizeBll = new ShippingCartonSizeBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //aShippingCartonSizeBll.LoadProduct(productNameDropDownList);
            shippingcartoonIdHiddenField.Value = Request.QueryString["ID"];
            ShippingCartonSizeLoad(shippingcartoonIdHiddenField.Value);
        }

    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        //if (productNameDropDownList.SelectedValue !=null)
       
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
                ShowMessageBox("Data Not Update!!!");
                
            }
            else
            {
                ShowMessageBox("Data Update Successfully!!! Please Reload");
               
            }
        }
        //else
        //{
        //    ShowMessageBox("Please input data in all Textbox");
        //}
    }

    private void ShippingCartonSizeLoad(string ID)
    {
        ShippingCartonSize aShippingCartonSize = new ShippingCartonSize();
        aShippingCartonSize = aShippingCartonSizeBll.ShippingCartonSizeEditLoad(ID);
        caseQtyTextBox.Text = aShippingCartonSize.CaseQty;
        pcsPerCaseTextBox.Text = aShippingCartonSize.PcsPerCase;
       // productNameDropDownList.SelectedValue = aShippingCartonSize.ProductCode;
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }

}