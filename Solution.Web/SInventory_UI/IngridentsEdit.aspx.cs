using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Library.BLL.SInventory_BLL;

using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_IngridentsEdit : System.Web.UI.Page
{
    IngridentsBLL aIngridentsBll = new IngridentsBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ingridentsIdHiddenField.Value = Request.QueryString["ID"];
            IngridentsLoad(ingridentsIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (ingridentTextBox.Text != "" )
        { 
            Ingridents aIngridents = new Ingridents()
            {
                IngridentsId = Convert.ToInt32(ingridentsIdHiddenField.Value),
                IngridentsName = ingridentTextBox.Text,
                IngridentsType = ingridentRadioButtonList.SelectedItem.Text,
                
            };
            IngridentsBLL aIngridentsBll = new IngridentsBLL();

            if (!aIngridentsBll.UpdateIngridentsInfo(aIngridents))
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


    private void IngridentsLoad(string id)
    {
        Ingridents aIngridents = new Ingridents();
        aIngridents = aIngridentsBll.IngridentsEditLoad(id);
        ingridentTextBox.Text = aIngridents.IngridentsName;
        for (int i = 0; i < ingridentRadioButtonList.Items.Count; i++)
        {
            
            if (ingridentRadioButtonList.Items[i].Text == aIngridents.IngridentsType)
            {
                ingridentRadioButtonList.Items[i].Selected = true;
            }
    
        }
        
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}