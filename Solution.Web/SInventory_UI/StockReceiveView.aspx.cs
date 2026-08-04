using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_RegionView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    CentralStoreBLL aCentralStoreBll = new CentralStoreBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadStockReceive();
        }
    }

    private void LoadStockReceive()
    {
        aDataTable = aCentralStoreBll.LoadstockReceive();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
    }

    

    protected void NewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("StockReceive.aspx");
    }
    protected void ReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {

    }
}