using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ProTypeEntry : System.Web.UI.Page
{
    ProTypeBLL aProTypeBll = new ProTypeBLL();

    string Msg = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                typeIdHiddenField.Value = Request.QueryString["ID"];
                ProTypeLoad(typeIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }
    }

    private void ProTypeLoad(string ID)
    {
        ProType aProType = new ProType();
        aProType = aProTypeBll.ProTypeEditLoad(ID);
        proTypeNameTextBox.Text = aProType.ProTypeName;
    }

    private void Clear()
    {
        proTypeNameTextBox.Text = string.Empty;
        
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (proTypeNameTextBox.Text != "")
        {

            if (typeIdHiddenField.Value != "")
            {

                ProType aProType = new ProType()
                {
                    ProTypeId = Convert.ToInt32(typeIdHiddenField.Value),
                    ProTypeName = proTypeNameTextBox.Text,

                };
                ProTypeBLL aProTypeBll = new ProTypeBLL();
                if (!aProTypeBll.UpdateProTypeInfo(aProType))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProTypeView.aspx');", true);

                }

            }
            else { 
                ProType aProType= new ProType()
            {
                ProTypeName = proTypeNameTextBox.Text,
                
            };
            ProTypeBLL aProTypeBll = new ProTypeBLL();
            Msg = aProTypeBll.SaveProType(aProType);
            if (Msg == "Already Exist")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProTypeView.aspx');", true);
            }
            }
        }
        else
        {
            showMessageBox("Please fill out this field!! ");
            proTypeNameTextBox.Focus();
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProTypeView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProTypeEntry.aspx");
    }
}