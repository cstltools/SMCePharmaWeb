using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class HRM_UI_EmpGenInfView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    EmpGeneralInfoBLL aGeneralInfoBll = new EmpGeneralInfoBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EmpGenerInfoLoald();
        }
    }
    private void EmpGenerInfoLoald()
    {
        aDataTable = aGeneralInfoBll.LoadEmpGeneralInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string EmpInfoId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(EmpInfoId);
        }
    }
    private void PopUp(string Id)
    {
        string url = "EmpGeneralEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void companyInfoNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("EmpGeneralInfoEntry.aspx");
    }
    protected void companyinfoReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        EmpGenerInfoLoald();
    }
}