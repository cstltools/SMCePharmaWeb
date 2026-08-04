using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ProUnitPriceView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    UnitPriceBLL aUnitPriceBLL = new UnitPriceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UnitPriceLoad();
        }
    }

    private void UnitPriceLoad()
    {
        aDataTable = aUnitPriceBLL.LoadProductUnitPrice();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private void PopUp(string Id)
    {
        string url = "ProUnitPriceEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();
            Session["UnitPrice"] = unitPriceId;
            Response.Redirect("ProUnitPriceEntry.aspx");
        }

    }
    protected void unitPriceNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("ProUnitPriceEntry.aspx");
    }
    protected void unitPriceReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        UnitPriceLoad();
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
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProUnitPriceEntry.aspx");
    }
}