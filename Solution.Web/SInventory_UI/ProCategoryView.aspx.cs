using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ProCategoryView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    ProductCategoriesBLL aProductCategoriesBll = new ProductCategoriesBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProCetegoryLoad();
        }
    }

    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    private void ProCetegoryLoad()
    {
        aDataTable = aProductCategoriesBll.LoadProductCategory();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void proCetegoryReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ProCetegoryLoad();
    }

    
    private void PopUp(string Id)
    {
        string url = "ProCategoryEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string CetegoryId = loadGridView.DataKeys[rowindex][0].ToString();

            string url = "ProCategoryEntry.aspx?ID=" + CetegoryId;
            Response.Redirect(url);
            //PopUp(CetegoryId);
        }
    }

    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProCategoryEntry.aspx");
    }
}