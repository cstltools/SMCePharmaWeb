using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.DataManager;

public partial class SInventory_UI_ExpiryReturn_DAList : System.Web.UI.Page
{
    private const string ApprovalStatusPending = "Pending";
    private const string ApprovalStatusApproved = "Approved";
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
        Response.Redirect("ExpiryReturn_DAList.aspx");
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
        LoadApprovalStatusList();

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

    protected void expiryReturnGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
        {
            return;
        }

        DataRowView rowView = e.Row.DataItem as DataRowView;
        if (rowView == null)
        {
            return;
        }

        LinkButton goToApprovalButton = e.Row.FindControl("goToApprovalButton") as LinkButton;
        if (goToApprovalButton == null)
        {
            return;
        }

        if (IsApprovedStatus(GetString(rowView.Row, "ApprovalStatusWeb")))
        {
            goToApprovalButton.Text = "<i class=\"fa fa-eye\"></i> View";
            goToApprovalButton.CssClass = "btn btn-sm btn-outline-primary";
        }
        else
        {
            goToApprovalButton.Text = "<i class=\"fa fa-check-square\"></i> Go to Approval";
            goToApprovalButton.CssClass = "btn btn-sm btn-outline-info";
        }
    }

    protected void expiryReturnGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "GoApproval")
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            string expiryReturnId = expiryReturnGridView.DataKeys[rowIndex]["ExpiryReturnId"].ToString();
            Response.Redirect("ExpiryReturn_DAApproval.aspx?ExpiryReturnId=" + HttpUtility.UrlEncode(expiryReturnId));
        }
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

        using (DataTable dt = GetExpiryReturnRouteList(comUnitId))
        {
            rootDropDownList.DataSource = dt;
            rootDropDownList.DataValueField = "DistributionRouteId";
            rootDropDownList.DataTextField = "DistributionRouteName";
            rootDropDownList.DataBind();
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            rootDropDownList.SelectedIndex = 0;
        }
    }

    private void LoadApprovalStatusList()
    {
        approvalStatusDropDownList.Items.Clear();
        approvalStatusDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        approvalStatusDropDownList.Items.Add(new ListItem(ApprovalStatusPending, ApprovalStatusPending));
        approvalStatusDropDownList.Items.Add(new ListItem(ApprovalStatusApproved, ApprovalStatusApproved));
        approvalStatusDropDownList.SelectedIndex = 0;
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

        using (DataTable aTable = GetExpiryReturnList(comUnitId, routeId, approvalStatusDropDownList.SelectedValue))
        {
            expiryReturnGridView.DataSource = aTable;
            expiryReturnGridView.DataBind();
            lblCount.Text = "Total Record: " + aTable.Rows.Count;
        }
    }

    private void ClearGrid()
    {
        expiryReturnGridView.DataSource = null;
        expiryReturnGridView.DataBind();
        lblCount.Text = "Total Record: 0";
    }

    private DataTable GetExpiryReturnRouteList(int comUnitId)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));

        return GetDataTable("sp_Get_ExpiryReturnDARouteList", parameters);
    }

    private DataTable GetExpiryReturnList(int comUnitId, int routeId, string approvalStatus)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
        parameters.Add(new SqlParameter("@RouteId", routeId));
        parameters.Add(new SqlParameter("@ApprovalStatus", String.IsNullOrEmpty(approvalStatus) ? (object)DBNull.Value : approvalStatus));

        return GetDataTable("sp_Get_ExpiryReturnDAList", parameters);
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

    private static bool IsApprovedStatus(string approvalStatus)
    {
        return !String.IsNullOrEmpty(approvalStatus)
            && String.Equals(approvalStatus.Trim(), ApprovalStatusApproved, StringComparison.OrdinalIgnoreCase);
    }

    private static string GetString(DataRow row, string columnName)
    {
        if (!row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
        {
            return String.Empty;
        }

        return row[columnName].ToString();
    }
}
