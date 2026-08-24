using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Order Payment Approval worklist - MenuId 383 of the shared approval framework.
///
/// Built to the same shape as Approval_UI/CustomerApproveList.aspx: one flat grid, inline
/// Approve / Reject, market-structure filter on top. Two things are done differently, on
/// purpose:
///
///   1. Whether a row is actionable comes from the CanAct column the list proc computes
///      server-side, not from comparing a HiddenField to Session["RoleTypeId"]. A hidden
///      field is client data; on a money approval it is not a control.
///   2. No role id appears in this file. Which role acts at which step is configured on
///      UserPermission/ApprovalStepMap.aspx and applied by the stored procedures.
///
/// sp_Save_OrderPaymentAppLog re-checks the caller's role, turn and market scope on every
/// action, so hiding a button here is convenience, never enforcement.
/// </summary>
public partial class Approval_UI_OrderPaymentApprovalList : System.Web.UI.Page
{
    private CommonDataLoad _CmnLoad = new CommonDataLoad();
    private OrderPaymentApprovalService _service = new OrderPaymentApprovalService();

    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect;

    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = IVMarketStructure.FindControl("TeritorySelect") as DropDownList;

        try
        {
            if (Session["UserId"] == null || Session["RoleTypeId"] == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                UserPersmissionValidation();
                lblMyRole.Text = Session["RoleTypeName"] == null
                    ? String.Empty
                    : "Role: " + Session["RoleTypeName"];
                LoadData();
            }
        }
        catch (Exception)
        {
            Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
        }
    }

    /// <summary>Menu-level permission check, same as the other Approval_UI pages.</summary>
    public void UserPersmissionValidation()
    {
        if (Session["UserRoleID"] != null && Session["UserRoleID"].ToString() == "2")
        {
            return;
        }

        try
        {
            string filepath = Path.GetDirectoryName(Request.Path);
            filepath = filepath.TrimStart('\\');
            filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);

            DataTable dtuserpermission = _CmnLoad.GetPermissionForUserRole(filepath);
            if (dtuserpermission == null || dtuserpermission.Rows.Count == 0)
            {
                Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
            }
        }
        catch (Exception)
        {
            Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
        }
    }

    private void LoadData()
    {
        int userId = Convert.ToInt32(Session["UserId"]);

        DataTable dt = _service.GetList(
            userId,
            ddlStatus.SelectedValue,
            ParseDate(txtFromDate.Text),
            ParseDate(txtToDate.Text),
            ParseInt(GroupSelect),
            ParseInt(ZoneSelect),
            ParseInt(AreaSelect),
            ParseInt(TeritorySelect),
            null);

        loadGridView.DataSource = dt;
        loadGridView.DataBind();
    }

    /// <summary>
    /// Show the action buttons only on rows the list proc marked actionable for this user;
    /// everything else gets the framework's "Waiting for Another Approver" badge.
    /// </summary>
    protected void loadGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
        {
            return;
        }

        bool canAct = Convert.ToBoolean(loadGridView.DataKeys[e.Row.RowIndex]["CanAct"]);
        string status = Convert.ToString(loadGridView.DataKeys[e.Row.RowIndex]["Status"]);

        LinkButton lbApprove = (LinkButton)e.Row.FindControl("lbApprove");
        LinkButton lbReject = (LinkButton)e.Row.FindControl("lbReject");
        TextBox txtRemarks = (TextBox)e.Row.FindControl("txtRemarks");
        Label lbMsg = (Label)e.Row.FindControl("lbMsg");

        if (canAct)
        {
            return;
        }

        if (lbApprove != null) lbApprove.Visible = false;
        if (lbReject != null) lbReject.Visible = false;
        if (txtRemarks != null) txtRemarks.Visible = false;

        if (lbMsg != null)
        {
            if (OrderPaymentApprovalStatus.IsLive(status))
            {
                lbMsg.Text = "Waiting for Another Approver";
                lbMsg.CssClass = "badge bg-warning";
            }
            else
            {
                lbMsg.Text = status;
                lbMsg.CssClass = String.Equals(status, OrderPaymentApprovalStatus.Accepted,
                                               StringComparison.OrdinalIgnoreCase)
                    ? "badge bg-success"
                    : "badge bg-danger";
            }
        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ApproveData" && e.CommandName != "RejectData" && e.CommandName != "ShowHistory")
        {
            return;
        }

        int rowIndex;
        if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out rowIndex)
            || rowIndex < 0 || rowIndex >= loadGridView.Rows.Count)
        {
            ShowFailed("Invalid row.");
            return;
        }

        int orderId = Convert.ToInt32(loadGridView.DataKeys[rowIndex]["OrderId"]);
        int userId = Convert.ToInt32(Session["UserId"]);

        if (e.CommandName == "ShowHistory")
        {
            ShowHistory(orderId, Convert.ToString(loadGridView.Rows[rowIndex].Cells[1].Text));
            return;
        }

        TextBox txtRemarks = (TextBox)loadGridView.Rows[rowIndex].FindControl("txtRemarks");
        string remarks = txtRemarks == null ? null : txtRemarks.Text.Trim();

        string result = e.CommandName == "ApproveData"
            ? _service.Approve(orderId, userId, remarks)
            : _service.Reject(orderId, userId, remarks);

        if (result == OrderPaymentApprovalService.Success)
        {
            ShowSuccess("Operation successful!");
            pnlHistory.Visible = false;
            LoadData();
        }
        else
        {
            // The message is the proc's own RAISERROR text - already worded for the user
            // ("You are not the approver for this stage.", "This request is outside your
            // market.", "Someone else has just acted on this request. Please refresh.").
            ShowFailed(result);
        }
    }

    private void ShowHistory(int orderId, string orderCode)
    {
        lblHistoryOrder.Text = orderCode;
        gvHistory.DataSource = _service.GetHistory(orderId);
        gvHistory.DataBind();
        pnlHistory.Visible = true;
    }

    protected void btnCloseHistory_Click(object sender, EventArgs e)
    {
        pnlHistory.Visible = false;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        pnlHistory.Visible = false;
        LoadData();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("OrderPaymentApprovalList.aspx");
    }

    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if ((gv.ShowHeader && gv.Rows.Count > 0) || gv.ShowHeaderWhenEmpty)
        {
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    private static DateTime? ParseDate(string text)
    {
        DateTime value;
        return DateTime.TryParse(text, out value) ? (DateTime?)value : null;
    }

    private static int? ParseInt(DropDownList list)
    {
        int value;
        if (list == null || String.IsNullOrEmpty(list.SelectedValue))
        {
            return null;
        }
        return Int32.TryParse(list.SelectedValue, out value) ? (int?)value : null;
    }

    private void ShowSuccess(string message)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
            "ShowSuccesalert('" + HttpUtility.JavaScriptStringEncode(message) + "','Success');", true);
    }

    private void ShowFailed(string message)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
            "faildalert('" + HttpUtility.JavaScriptStringEncode(message) + "','Failed');", true);
    }
}
