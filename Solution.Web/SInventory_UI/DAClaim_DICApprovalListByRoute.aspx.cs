using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.DataManager;

public partial class SInventory_UI_DAClaim_DICApprovalListByRoute : System.Web.UI.Page
{
    private readonly OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DAClaim_DICApprovalListByRoute.aspx");
    }

    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader && gv.Rows.Count > 0) || gv.ShowHeaderWhenEmpty)
        {
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + message + "');", true);
    }

    public void DropDownlist()
    {
        try
        {
            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());

            if (salesCenterDropDownList.Items.Count > 1)
            {
                salesCenterDropDownList.SelectedIndex = 1;
            }

            LoadRouteList();
        }
        catch
        {
            salesCenterDropDownList.Items.Clear();
            rootDropDownList.Items.Clear();
        }
    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadRouteList();
        ClearGrid();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView();
    }

    private void LoadRouteList()
    {
        rootDropDownList.Items.Clear();

        int comUnitId;
        if (!int.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId))
        {
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            return;
        }

        using (DataTable dt = GetDAClaimRouteList(comUnitId))
        {
            rootDropDownList.DataSource = dt;
            rootDropDownList.DataValueField = "DistributionRouteId";
            rootDropDownList.DataTextField = "DistributionRouteName";
            rootDropDownList.DataBind();
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            rootDropDownList.SelectedIndex = 0;
        }
    }

    public void GridView()
    {
        ClearGrid();

        int comUnitId;
        if (!int.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId))
        {
            ShowMessageBox("Please input Sales Center!");
            salesCenterDropDownList.Focus();
            return;
        }

        int routeId = 0;
        int.TryParse(rootDropDownList.SelectedValue, out routeId);

        using (DataTable aTable = GetDAClaimDICApprovalListByRoute(comUnitId, routeId))
        {
            daClaimGridView.DataSource = aTable;
            daClaimGridView.DataBind();
            lblCount.Text = "Total Record: " + aTable.Rows.Count;
        }
    }

    private void ClearGrid()
    {
        daClaimGridView.DataSource = null;
        daClaimGridView.DataBind();
        lblCount.Text = "Total Record: 0";
    }

    private DataTable GetDAClaimRouteList(int comUnitId)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
        parameters.Add(new SqlParameter("@ApprovalStatus", "Approved"));

        return GetDataTable("sp_Get_DAClaimDARouteList", parameters);
    }

    private DataTable GetDAClaimDICApprovalListByRoute(int comUnitId, int routeId)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
        parameters.Add(new SqlParameter("@RouteId", routeId));

        return GetDataTable("sp_Get_DAClaimDICApprovalListByRoute", parameters);
    }

    private DataTable GetDataTable(string storeProcedure, List<SqlParameter> parameters)
    {
        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            return accessManager.GetDataTable(storeProcedure, parameters);
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }
}
