using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_AreaView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    AreaBLL areaBll = new AreaBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AreaLoad();
        }
    }

    private void AreaLoad()
    {
        aDataTable = areaBll.LoadAreaInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string areaId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(areaId);
        }
    }

    private void PopUp(string Id)
    {
        string url = "AreaEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void areaInfoNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("AreaEntry.aspx");
    }
    protected void areaReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        AreaLoad();
    }
}