using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_RegionView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    RegionInfoBLL aRegionInfoBLL = new RegionInfoBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RegionInfoLoad();
        }
    }

    private void RegionInfoLoad()
    {
        aDataTable = aRegionInfoBLL.LoadRegionInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string regionId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(regionId);
        }
    }

    private void PopUp(string Id)
    {
        string url = "RegionEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void regionNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("RegionEntry.aspx");
    }
    protected void regionReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        RegionInfoLoad();
    }
    
}