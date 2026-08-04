using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ShippingCartonSizeView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    ShippingCartonSizeBLL aShippingCartonSizeBll = new ShippingCartonSizeBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ShippingCartonSizeLoad();
        }
    }
    private void ShippingCartonSizeLoad()
    {
        aDataTable = aShippingCartonSizeBll.LoadShippingCartonSize();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
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
    protected void custCetegoryReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ShippingCartonSizeLoad();
    }

    protected void custCetegoryAddImageButton_Click(object sender, ImageClickEventArgs e)
    {
     
    }
    private void PopUp(string Id)
    {
        string url = "ShippingCartonSizeEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string custCetegoryId = loadGridView.DataKeys[rowindex][0].ToString();
            string url = "ShippingCartonSizeEntry.aspx?ID=" + custCetegoryId;
            Response.Redirect(url);
        }
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Response.Redirect("ShippingCartonSizeEntry.aspx");
    }
}