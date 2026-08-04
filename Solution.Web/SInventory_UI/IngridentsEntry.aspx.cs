using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_IngridentsEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    private void Clear()
    {
        ingridentTextBox.Text = string.Empty;
        ingridentRadioButtonList.Items[0].Selected = false;
        ingridentRadioButtonList.Items[1].Selected = false;


    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (ingridentTextBox.Text != "")
        {
            Ingridents aIngridents= new Ingridents()
            {
                IngridentsName = ingridentTextBox.Text,
                IngridentsType = ingridentRadioButtonList.SelectedItem.Text
                
            };
            IngridentsBLL aIngridentsBll = new IngridentsBLL();
            MessageLabel.Text = aIngridentsBll.SaveIngridents(aIngridents);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void ListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("IngridentsView.aspx");
    }
}