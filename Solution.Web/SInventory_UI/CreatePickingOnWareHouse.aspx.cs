using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_CreatePickingOnWareHouse : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadGrid();
        }
    }
    private void LoadGrid()
    {
        aDataTable = aRequisitionBll.GetAllNonPickReq();
        viewReqGridView.DataSource = aDataTable;
        viewReqGridView.DataBind();
    }
    protected void ListImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ChallanReportView.aspx");
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