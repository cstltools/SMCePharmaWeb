using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ProductSQView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    ProductSQBLL aProductSQBLL = new ProductSQBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProductSQLoad();
        }
    }

    private void ProductSQLoad()
    {
        aDataTable = aProductSQBLL.LoadProductSQ();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }


    protected void deptReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ProductSQLoad();
    }
    
    private void PopUp(string Id)
    {
        string url = "ProductSQEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string departmentId = loadGridView.DataKeys[rowindex][0].ToString();

            string url = "ProductSQEntry.aspx?ID=" + departmentId;
            Response.Redirect(url);
          //  PopUp(departmentId);
        }

    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProductSQEntry.aspx");
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