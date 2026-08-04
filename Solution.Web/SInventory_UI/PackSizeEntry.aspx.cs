using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_PackSizeEntry : System.Web.UI.Page
{
    PackSizeBLL aPackSizeBLL = new PackSizeBLL();

    string Msg = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                packSizeIdHiddenField.Value = Request.QueryString["ID"];
                PackSizeLoad(packSizeIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }
    }

    private void PackSizeLoad(string departmentId)
    {
        PackSize aPackSize = new PackSize();
        aPackSize = aPackSizeBLL.PackSizeEditLoad(departmentId);
        packsizeNameTextBox.Text = aPackSize.PackSizeName;
    }

    private void Clear()
    {
        packsizeNameTextBox.Text = string.Empty;
        
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (packsizeNameTextBox.Text != "" )
        {


            if (packSizeIdHiddenField.Value != "")
            {
                PackSize aPackSize = new PackSize()
                {
                    PackSizeId = Convert.ToInt32(packSizeIdHiddenField.Value),
                    PackSizeName = packsizeNameTextBox.Text
                };
                PackSizeBLL aPackSizeBLL = new PackSizeBLL();

                if (!aPackSizeBLL.UpdatePackSizeInfo(aPackSize))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','PackSizeView.aspx');", true);
                }
            }
            else
            {
                PackSize aPackSize = new PackSize()
                {
                    PackSizeName = packsizeNameTextBox.Text,

                };
                PackSizeBLL aPackSizeBll = new PackSizeBLL();
                Msg = aPackSizeBll.SavePackSize(aPackSize);

                if (Msg == "Already Exist")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','PackSizeView.aspx');", true);
                }
            }

        }
        else
        {
            showMessageBox("Please input data in all Textbox");
            packsizeNameTextBox.Focus();
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
        Response.Redirect("PackSizeView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        
        Response.Redirect("PackSizeEntry.aspx");

    }
}