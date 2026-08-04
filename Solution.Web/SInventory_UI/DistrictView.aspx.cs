using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_DistrictView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    DistrictInfoBLL aDistrictInfoBLL = new DistrictInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DistrictLoad();
        }
    }

    private void DistrictLoad()
    {
        aDataTable = aDistrictInfoBLL.LoadDistrictInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }


    protected void deptReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        DistrictLoad();
    }
    protected void departmentNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DistrictEntry.aspx");
    }
    private void PopUp(string Id)
    {
        string url = "DistrictEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string districtId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(districtId);
        }

    }
}