using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;

public partial class SubDepot_UI_SubdepotView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    SubDepotBLL aZoneInfoBLL = new SubDepotBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ZoneInfoLoad();
        }
    }

    private void ZoneInfoLoad()
    {
        aDataTable = aZoneInfoBLL.LoadZoneInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string zoneId = loadGridView.DataKeys[rowindex][0].ToString();
            Session["SubDepot"] = zoneId;
            Response.Redirect("SubdepotInfoEntry.aspx");
            //PopUp(zoneId);
        }
    }

    private void PopUp(string Id)
    {
        string url = "ZoneEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void regionNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("SubdepotInfoEntry.aspx");
    }
    protected void regionReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ZoneInfoLoad();
    }


    protected void viewLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubdepotInfoEntry.aspx");

    }
}