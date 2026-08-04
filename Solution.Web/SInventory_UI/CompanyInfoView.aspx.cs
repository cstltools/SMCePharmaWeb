using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_CompanyInfoView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    CompanyInfoBLL aCompanyInfoBll = new CompanyInfoBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CompanyInfoLoad();
        }
    }

    private void CompanyInfoLoad()
    {
        aDataTable = aCompanyInfoBll.LoadCompanyInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string companyInfoId = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(companyInfoId);
        }
    }

    private void PopUp(string Id)
    {
        string url = "CompanyInfoEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void companyInfoNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CompanyInfoEntry.aspx");
    }
    protected void companyinfoReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        CompanyInfoLoad();
    }

}