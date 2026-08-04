using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_MiaTargetView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    MiaTargetBLL aMiaTargetBLL = new MiaTargetBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MIATargetInfoLoad();
        }
    }

    private void MIATargetInfoLoad()
    {
        aDataTable = aMiaTargetBLL.LoadMiaTarget();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private void PopUp(string Id)
    {
        string url = "MiaTargetEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string miaId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(miaId);
        }

    }
    protected void miaTargetReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        MIATargetInfoLoad();
    }
    protected void miaTargetNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("MiaTargetEntry.aspx");
    }
}