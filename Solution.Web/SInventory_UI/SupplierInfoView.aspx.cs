using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_SupplierInfoView : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    SupplierInfoDal areaBll = new SupplierInfoDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AreaLoad();
        }
    }

    private void AreaLoad()
    {
        aDataTable = areaBll.LoadSupplierInfo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string areaId = loadGridView.DataKeys[rowindex][0].ToString();
            
            if (areaId != null)
            {

                Response.Redirect("SupplierInformation.aspx?SupplierId=" + areaId);
            }
        }
    }


    protected void areaInfoNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("SupplierInformation.aspx");
    }
    protected void areaReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        AreaLoad();
    }
}