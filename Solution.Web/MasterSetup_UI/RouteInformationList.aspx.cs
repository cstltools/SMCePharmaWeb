using Library.DAL.MasterSetup_DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_RouteInformationList : System.Web.UI.Page
{
    private static RouteInformationDAL _RouteInformationDAL = new RouteInformationDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            LoadData();
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
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("RouteInformationEntry.aspx");
    }


    private void LoadData()
    {
        DataTable aDataTable = new DataTable();


        if (Session["RoleTypeId"].ToString() == "5")
        {
            aDataTable = _RouteInformationDAL.GetRouteInformationList("");

        }
        else
        {
            aDataTable = _RouteInformationDAL.GetRouteInformationList(" and A.DCId in(" + Session["DICUnitId"].ToString()+")");
             
        }


        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

            Response.Redirect("RouteInformationEntry.aspx?MID=" + unitPriceId);
        }

    }
}