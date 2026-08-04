using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_OrderRequisitionView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetRequisitionView();
          
        }
    }
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("OrderRequisitionCreation.aspx");
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

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("WhFreezeStockRelease.aspx");
    }
    private void GetRequisitionView()
    {
        aDataTable = aRequisitionBll.GetRequisitionView();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void custCetegoryReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        GetRequisitionView();
    }

    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton) sender;
        GridViewRow currentRow = (GridViewRow) productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        aRequisitionBll.DeleteRequisition(loadGridView.DataKeys[rowindex][0].ToString());
        GetRequisitionView();

    }

    protected void custCetegoryAddImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("OrderRequisitionCreation.aspx");
    }


    protected void EditData_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        Response.Redirect("OrderRequisitionCreation.aspx?MasID=" + loadGridView.DataKeys[rowindex][0].ToString());
    }
}