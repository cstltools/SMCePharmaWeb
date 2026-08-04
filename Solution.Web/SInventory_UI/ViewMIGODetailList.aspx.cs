using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ViewMIGODetailList : System.Web.UI.Page
{
    private DataTable aDataTable = new DataTable();
    private ExcelUpForMIGOBLL aExcelUpForMIGOBLL = new ExcelUpForMIGOBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            userIdHiddenField.Value = Session["MigoID"].ToString();
            MigoLoad();
            Session["MigoID"] = "";
        }
    }

    private void MigoLoad()
    {
        aDataTable = aExcelUpForMIGOBLL.LoadMigo(userIdHiddenField.Value);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

}