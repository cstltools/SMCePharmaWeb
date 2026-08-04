using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_WHStockInList : System.Web.UI.Page
{
    WHStockListBLL aWhStockListBll=new WHStockListBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadGrid();
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
    public void LoadGrid()
    {
        DataTable dt = aWhStockListBll.LoadWHStock();
        loadGridView.DataSource = dt;
        loadGridView.DataBind();
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            //int rowindex = Convert.ToInt32(e.CommandArgument);
            //string id = loadGridView.DataKeys[rowindex][0].ToString();
            //Session["WHId"] = id;

        }
    }

    protected void HyperLink1_OnClick(object sender, EventArgs e)
    {
        LinkButton LinkButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)LinkButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        string id = loadGridView.DataKeys[rowindex][0].ToString();
        Session["WHId"] = id;
        Response.Redirect("WarehouseStockOut.aspx");

    }
}