using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ViewRequisitionForIssue : System.Web.UI.Page
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
        aDataTable = aRequisitionBll.GetAllNonSubmitReq();
        viewReqGridView.DataSource = aDataTable;
        viewReqGridView.DataBind();
    }
}