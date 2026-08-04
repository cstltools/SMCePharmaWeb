using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ProductView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    ProductBLL aProductBLL = new ProductBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProductLoad();
        }
    }

    private void ProductLoad()
    {
        aDataTable = aProductBLL.LoadProduct();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private void PopUp(string Id)
    {
        string url = "ProductEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string productId = loadGridView.DataKeys[rowindex][0].ToString();

            string url = "ProductEntry.aspx?ID=" + productId;
            Response.Redirect(url);
        }
    }
    protected void miaTargetReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ProductLoad();
    }
    protected void miaTargetNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("ProductEntry.aspx");
    }

    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProductEntry.aspx");
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
}