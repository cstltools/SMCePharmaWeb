using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_MiaInfoView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    MIAInformationBLL aMIAInformationBLL = new MIAInformationBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MIAInfoLoad();
        }
    }

    private void MIAInfoLoad()
    {
        aDataTable = aMIAInformationBLL.LoadMiaInformation();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private void PopUp(string Id)
    {
        string url = "MIAInfoEdit.aspx?ID=" + Id;
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
    protected void miaInfoReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        MIAInfoLoad();
    }
    protected void miaInfoNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("MIAInfoEntry.aspx");
    }
}