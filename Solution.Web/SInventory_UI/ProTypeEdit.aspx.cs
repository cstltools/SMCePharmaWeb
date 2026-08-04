using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProTypeEdit : System.Web.UI.Page
{
    ProTypeBLL aProTypeBll = new ProTypeBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            typeIdHiddenField.Value = Request.QueryString["ID"];
            ProTypeLoad(typeIdHiddenField.Value);
        }

    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (typeTextBox.Text != "" )
        {
            ProType aProType = new ProType()
            {
                ProTypeId = Convert.ToInt32(typeIdHiddenField.Value),
                ProTypeName = typeTextBox.Text,
                
            };
            ProTypeBLL aProTypeBll = new ProTypeBLL();
            if (!aProTypeBll.UpdateProTypeInfo(aProType))
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

    private void ProTypeLoad(string ID)
    {
        ProType aProType = new ProType();
        aProType = aProTypeBll.ProTypeEditLoad(ID);
        typeTextBox.Text = aProType.ProTypeName;
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }

}