using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class HRM_UI_TDLUserView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    UserBLL aUserBll = new UserBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UserLoad();
        }


    }

    private void UserLoad()
    {
        aDataTable = aUserBll.LoadUserInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private void PopUp(string Id)
    {
        string url = "UserEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }


    protected void addImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("UserEntry.aspx");
    }
    protected void reloadLinkButton_Click(object sender, ImageClickEventArgs e)
    {
        UserLoad();
    }
    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string userId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(userId);
        }
        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string userId = loadGridView.DataKeys[rowindex][0].ToString();
            bool ststus = aUserBll.DeleteUserInfo(userId);
            if (ststus == true)
            {
                ShowMessageBox("User Delete Successfully");
                UserLoad();
            }
        }

    }
}