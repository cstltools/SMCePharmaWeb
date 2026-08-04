using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_StockRcvByWH : System.Web.UI.Page
{
    SCtoWHTransferDal aDal = new SCtoWHTransferDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadWarhehouse();
        }
    }

    private void LoadWarhehouse()
    {
        aDal.WareHouseLoad(dcDropDownList);
        dcDropDownList.SelectedValue = 1.ToString(CultureInfo.InvariantCulture);
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        DataTable aTable = new DataTable();

        aTable = aDal.GetWarehouseRcvStock(dcDropDownList.SelectedItem.Text.Split(':')[0]);
        stockInTraGridView.DataSource = aTable;
        stockInTraGridView.DataBind();
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

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("StockRcvByWH.aspx");
    }
}