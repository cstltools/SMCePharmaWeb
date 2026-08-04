using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Library.BLL.SInventory_BLL;

using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_PackSizeEdit : System.Web.UI.Page
{
    PackSizeBLL aPackSizeBLL = new PackSizeBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            packSizeIdHiddenField.Value = Request.QueryString["ID"];
            PackSizeLoad(packSizeIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (packsizeNameTextBox.Text != "" )
        { 
            PackSize aPackSize = new PackSize()
            {
                PackSizeId = Convert.ToInt32(packSizeIdHiddenField.Value),
                PackSizeName = packsizeNameTextBox.Text                
            };
            PackSizeBLL aPackSizeBLL = new PackSizeBLL();

            if (!aPackSizeBLL.UpdatePackSizeInfo(aPackSize))
            {
                ShowMessageBox("Data Not Update!!!");
                
            }
            else
            {
                ShowMessageBox("Data Update Successfully!!! Please Reload");
            }
        }
        else
        {
            ShowMessageBox("Please input data in all Textbox");
        }
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void PackSizeLoad(string departmentId)
    {
        PackSize aPackSize = new PackSize();
        aPackSize = aPackSizeBLL.PackSizeEditLoad(departmentId);
        packsizeNameTextBox.Text = aPackSize.PackSizeName;    
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}