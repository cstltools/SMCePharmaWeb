using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_DepartmentView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    DepartmentBLL aDepartmentBll = new DepartmentBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DepartmentLoad();
        }
    }

    private void DepartmentLoad()
    {
        aDataTable = aDepartmentBll.LoadDepartment();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }


    protected void deptReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        DepartmentLoad();
    }
    protected void departmentNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DepartmentEntry.aspx");
    }
    private void PopUp(string Id)
    {
        string url = "DepartmentEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string departmentId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(departmentId);
        }

    }
}