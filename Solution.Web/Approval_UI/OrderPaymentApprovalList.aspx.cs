using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

/// <summary>
/// AM / DZSM / NSM worklist for the Order Payment Approval workflow.
///
/// One page serves all three levels: what a user sees and may do comes from
/// sp_OrderPaymentApproval_GetList / _GetDetail, which scope every row to the caller's own
/// role and employee id. The buttons below are convenience only - sp_OrderPaymentApproval_Act
/// re-verifies role, assignment, state transition and the payment schedule on every action,
/// so hiding or showing a control here changes nothing about what is actually permitted.
/// </summary>
public partial class Approval_UI_OrderPaymentApprovalList : System.Web.UI.Page
{
    private OrderPaymentApprovalService _service = new OrderPaymentApprovalService();
    private CommonDataLoad _cmnLoad = new CommonDataLoad();

    private const string ScheduleStateKey = "OPA_ScheduleDraft";
    private const string CurrentIdKey = "OPA_CurrentId";

    private int CurrentApprovalId
    {
        get { return ViewState[CurrentIdKey] == null ? 0 : (int)ViewState[CurrentIdKey]; }
        set { ViewState[CurrentIdKey] = value; }
    }

    private DataTable ScheduleDraft
    {
        get { return ViewState[ScheduleStateKey] as DataTable; }
        set { ViewState[ScheduleStateKey] = value; }
    }

    private int CurrentUserId
    {
        get
        {
            int userId;
            if (Session["UserId"] == null || !Int32.TryParse(Session["UserId"].ToString(), out userId))
            {
                return 0;
            }
            return userId;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (CurrentUserId == 0)
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            UserPermissionValidation();
            lblMyRole.Text = Session["RoleTypeName"] == null ? String.Empty : "Role: " + Session["RoleTypeName"];
            LoadList();
        }
    }

    /// <summary>Same menu-permission gate the other Approval_UI pages use.</summary>
    private void UserPermissionValidation()
    {
        if (Session["UserRoleID"] == null || Session["UserRoleID"].ToString() == "2")
        {
            return;
        }

        try
        {
            string filepath = Path.GetDirectoryName(Request.Path);
            filepath = filepath.TrimStart('\\');
            filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);

            DataTable permissions = _cmnLoad.GetPermissionForUserRole(filepath);
            if (permissions == null || permissions.Rows.Count == 0)
            {
                Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
            }
        }
        catch (Exception)
        {
            Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
        }
    }

    private void LoadList()
    {
        int statusFilter;
        if (!Int32.TryParse(ddlStatus.SelectedValue, out statusFilter))
        {
            statusFilter = -1;
        }

        gvApprovalList.DataSource = _service.GetList(CurrentUserId, statusFilter,
                                                     ParseDate(txtFromDate.Text), ParseDate(txtToDate.Text));
        gvApprovalList.DataBind();
    }

    /// <summary>
    /// pickadate posts its display text (default "d mmmm, yyyy"), so accept the same format
    /// list SInventory_UI/InvoiceCreationByOrder_daaw.aspx.cs accepts, then fall back to the
    /// current culture.
    /// </summary>
    private static readonly string[] DateFormats =
    {
        "dd-MMM-yyyy", "d-MMM-yyyy",
        "dd MMM, yyyy", "d MMM, yyyy",
        "dd MMMM, yyyy", "d MMMM, yyyy",
        "dd MMM yyyy", "d MMM yyyy",
        "M/d/yyyy", "MM/dd/yyyy",
        "yyyy-MM-dd"
    };

    private static bool TryParseDate(string value, out DateTime dateValue)
    {
        dateValue = DateTime.MinValue;
        if (String.IsNullOrEmpty(value))
        {
            return false;
        }

        value = value.Trim();

        return DateTime.TryParseExact(value, DateFormats, CultureInfo.InvariantCulture,
                                      DateTimeStyles.None, out dateValue)
            || DateTime.TryParse(value, out dateValue);
    }

    private static DateTime? ParseDate(string value)
    {
        DateTime parsed;
        return TryParseDate(value, out parsed) ? (DateTime?)parsed : null;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        CloseDetail();
        LoadList();
    }

    protected void gvApprovalList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "OpenDetail")
        {
            return;
        }

        int approvalId;
        if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out approvalId))
        {
            return;
        }

        CurrentApprovalId = approvalId;
        ScheduleDraft = null;
        LoadDetail();
    }

    private void LoadDetail()
    {
        DataSet ds = _service.GetDetail(CurrentApprovalId, CurrentUserId);

        // The repository returns null only when the procedure refused the caller, so keep
        // that message for that case alone - reporting a data-shape problem as an
        // authorization failure sends whoever debugs it down the wrong path.
        if (ds == null)
        {
            CloseDetail();
            ShowFailedAlert("You are not authorized to view this approval request.");
            return;
        }

        if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
        {
            CloseDetail();
            ShowFailedAlert("This approval request could not be loaded.");
            return;
        }

        DataTable scheduleTable = ds.Tables.Count > 1 ? ds.Tables[1] : new DataTable();
        DataTable historyTable = ds.Tables.Count > 2 ? ds.Tables[2] : new DataTable();

        DataRow header = ds.Tables[0].Rows[0];
        int status = Convert.ToInt32(header["ApprovalStatus"]);
        bool canAct = Convert.ToBoolean(header["CanAct"]);

        lblOrderCode.Text = Convert.ToString(header["OrderCode"]);
        lblStatusBadge.Text = Convert.ToString(header["ApprovalStatusName"]);
        lblCustomer.Text = Convert.ToString(header["CustomerCode"]) + " - " + Convert.ToString(header["CustomerName"]);
        lblOrderValue.Text = Convert.ToDecimal(header["OrderGrossValue"]).ToString("N2");
        lblTotalDue.Text = Convert.ToDecimal(header["TotalDueAmount"]).ToString("N2");
        lblBlockReason.Text = Convert.ToString(header["BlockReason"]);

        decimal scheduled = 0;
        foreach (DataRow row in scheduleTable.Rows)
        {
            scheduled += Convert.ToDecimal(row["PaymentAmount"]);
        }
        lblScheduled.Text = scheduled.ToString("N2");

        // The AM step is the only one that authors the payment plan (VR-OPA-16).
        bool isScheduleEditable = canAct && status == OrderPaymentApprovalStatus.PendingAM;

        pnlScheduleEditor.Visible = isScheduleEditable;
        pnlScheduleView.Visible = !isScheduleEditable;

        if (isScheduleEditable)
        {
            if (ScheduleDraft == null)
            {
                ScheduleDraft = BuildDraftFrom(scheduleTable);
            }
            BindScheduleEditor();
        }
        else
        {
            gvScheduleView.DataSource = scheduleTable;
            gvScheduleView.DataBind();
        }

        gvHistory.DataSource = historyTable;
        gvHistory.DataBind();

        pnlActions.Visible = canAct;
        txtRemarks.Text = String.Empty;
        pnlDetail.Visible = true;
    }

    /// <summary>Seeds the editor with the existing plan, or one empty row for a fresh one.</summary>
    private static DataTable BuildDraftFrom(DataTable existingSchedule)
    {
        DataTable draft = NewDraftTable();

        if (existingSchedule != null && existingSchedule.Rows.Count > 0)
        {
            foreach (DataRow row in existingSchedule.Rows)
            {
                draft.Rows.Add(Convert.ToDateTime(row["PaymentDate"]).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
                               Convert.ToDecimal(row["PaymentAmount"]).ToString("0.00", CultureInfo.InvariantCulture));
            }
        }
        else
        {
            draft.Rows.Add(String.Empty, String.Empty);
        }

        return draft;
    }

    private static DataTable NewDraftTable()
    {
        DataTable draft = new DataTable();
        draft.Columns.Add("PaymentDate", typeof(string));
        draft.Columns.Add("PaymentAmount", typeof(string));
        return draft;
    }

    private void BindScheduleEditor()
    {
        gvScheduleEdit.DataSource = ScheduleDraft;
        gvScheduleEdit.DataBind();
    }

    protected void gvScheduleEdit_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
        {
            return;
        }

        DataRowView drv = (DataRowView)e.Row.DataItem;
        TextBox txtDate = (TextBox)e.Row.FindControl("txtPaymentDate");
        TextBox txtAmount = (TextBox)e.Row.FindControl("txtPaymentAmount");

        if (txtDate != null) txtDate.Text = Convert.ToString(drv["PaymentDate"]);
        if (txtAmount != null) txtAmount.Text = Convert.ToString(drv["PaymentAmount"]);
    }

    /// <summary>Pulls what the user currently has typed back into the ViewState draft.</summary>
    private void HarvestScheduleEditor()
    {
        DataTable draft = NewDraftTable();

        foreach (GridViewRow row in gvScheduleEdit.Rows)
        {
            if (row.RowType != DataControlRowType.DataRow)
            {
                continue;
            }

            TextBox txtDate = (TextBox)row.FindControl("txtPaymentDate");
            TextBox txtAmount = (TextBox)row.FindControl("txtPaymentAmount");

            draft.Rows.Add(txtDate == null ? String.Empty : txtDate.Text.Trim(),
                           txtAmount == null ? String.Empty : txtAmount.Text.Trim());
        }

        ScheduleDraft = draft;
    }

    protected void btnAddRow_Click(object sender, EventArgs e)
    {
        HarvestScheduleEditor();
        DataTable draft = ScheduleDraft ?? NewDraftTable();
        draft.Rows.Add(String.Empty, String.Empty);
        ScheduleDraft = draft;
        BindScheduleEditor();
    }

    protected void gvScheduleEdit_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "RemoveRow")
        {
            return;
        }

        int index;
        if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out index))
        {
            return;
        }

        HarvestScheduleEditor();
        DataTable draft = ScheduleDraft;
        if (draft != null && index >= 0 && index < draft.Rows.Count)
        {
            draft.Rows.RemoveAt(index);
            if (draft.Rows.Count == 0)
            {
                draft.Rows.Add(String.Empty, String.Empty);
            }
            ScheduleDraft = draft;
        }
        BindScheduleEditor();
    }

    protected void btnApprove_Click(object sender, EventArgs e)
    {
        if (CurrentApprovalId == 0)
        {
            return;
        }

        List<PaymentScheduleRow> schedule = null;

        if (pnlScheduleEditor.Visible)
        {
            HarvestScheduleEditor();

            string parseError;
            schedule = ParseSchedule(ScheduleDraft, out parseError);
            if (parseError != null)
            {
                BindScheduleEditor();
                ShowFailedAlert(parseError);
                return;
            }
        }

        string result = _service.Approve(CurrentApprovalId, CurrentUserId, txtRemarks.Text.Trim(), schedule);

        if (result == OrderPaymentApprovalService.Success)
        {
            ScheduleDraft = null;
            ShowSuccessAlert("Approved successfully.");
            LoadList();
            LoadDetail();
        }
        else
        {
            if (pnlScheduleEditor.Visible)
            {
                BindScheduleEditor();
            }
            ShowFailedAlert(result);
        }
    }

    protected void btnReject_Click(object sender, EventArgs e)
    {
        if (CurrentApprovalId == 0)
        {
            return;
        }

        string result = _service.Reject(CurrentApprovalId, CurrentUserId, txtRemarks.Text.Trim());

        if (result == OrderPaymentApprovalService.Success)
        {
            ScheduleDraft = null;
            ShowSuccessAlert("Request rejected.");
            LoadList();
            LoadDetail();
        }
        else
        {
            ShowFailedAlert(result);
        }
    }

    /// <summary>
    /// Type conversion only. The business rules on the schedule (sum equals total due,
    /// dates today-or-later, unique, ascending) are enforced by sp_OrderPaymentApproval_Act;
    /// this just turns text into typed rows and reports what could not be read.
    /// </summary>
    private static List<PaymentScheduleRow> ParseSchedule(DataTable draft, out string error)
    {
        error = null;
        List<PaymentScheduleRow> rows = new List<PaymentScheduleRow>();

        if (draft == null || draft.Rows.Count == 0)
        {
            error = "Payment schedule must contain at least one instalment.";
            return null;
        }

        int lineNo = 0;
        foreach (DataRow row in draft.Rows)
        {
            lineNo++;
            string dateText = Convert.ToString(row["PaymentDate"]).Trim();
            string amountText = Convert.ToString(row["PaymentAmount"]).Trim();

            if (dateText.Length == 0 && amountText.Length == 0)
            {
                continue;   // untouched blank row the user added and did not fill
            }

            DateTime paymentDate;
            if (!TryParseDate(dateText, out paymentDate))
            {
                error = "Instalment " + lineNo + ": payment date is not a valid date.";
                return null;
            }

            decimal amount;
            if (!Decimal.TryParse(amountText, NumberStyles.Any, CultureInfo.InvariantCulture, out amount))
            {
                error = "Instalment " + lineNo + ": payment amount is not a valid number.";
                return null;
            }

            rows.Add(new PaymentScheduleRow
            {
                PaymentNo = rows.Count + 1,
                PaymentDate = paymentDate.Date,
                PaymentAmount = amount
            });
        }

        if (rows.Count == 0)
        {
            error = "Payment schedule must contain at least one instalment.";
            return null;
        }

        return rows;
    }

    protected void btnCloseDetail_Click(object sender, EventArgs e)
    {
        CloseDetail();
    }

    private void CloseDetail()
    {
        CurrentApprovalId = 0;
        ScheduleDraft = null;
        pnlDetail.Visible = false;
        pnlActions.Visible = false;
        pnlScheduleEditor.Visible = false;
        pnlScheduleView.Visible = false;
    }

    private void ShowSuccessAlert(string message)
    {
        RegisterClientAlert("ShowSuccesalert", message, "Success");
    }

    private void ShowFailedAlert(string message)
    {
        RegisterClientAlert("faildalert", message, "Faild");
    }

    private void RegisterClientAlert(string functionName, string message, string type)
    {
        string safeMessage = HttpUtility.JavaScriptStringEncode(message ?? String.Empty);
        string safeType = HttpUtility.JavaScriptStringEncode(type);
        string script = String.Format(
            "if (typeof {0} === 'function') {{ {0}('{1}','{2}'); }} else {{ alert('{1}'); }}",
            functionName, safeMessage, safeType);

        ScriptManager.RegisterStartupScript(this, GetType(), functionName + Guid.NewGuid().ToString("N"), script, true);
    }
}
