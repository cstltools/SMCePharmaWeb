using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ViewOrderDetailList : System.Web.UI.Page
{
    private DataTable aDataTable = new DataTable();
    ExcelUpForOrderListBLL aExcelUpForMIGOBLL = new ExcelUpForOrderListBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            userIdHiddenField.Value = Session["OrderID"].ToString();
            Load();
            Session["OrderID"] = "";
        }
    }
    private void Load()
    {
        aDataTable = aExcelUpForMIGOBLL.LoadOrder(userIdHiddenField.Value);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }
}