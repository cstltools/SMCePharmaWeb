using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.DataManager;
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_UI_DAExpenseClaimApprovalList : System.Web.UI.Page
{
    private const string ApprovalStatusApproved = "Approved";
    private const string ApprovalStatusDisApproved = "DisApproved";
    private readonly OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadSalesCenters();
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DAExpenseClaimApprovalList.aspx");
    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadRouteList();
        ClearGrid();
    }

    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadDAList();
        ClearGrid();
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        LoadExpenseClaims();
    }

    protected void expenseClaimGridView_PreRender(object sender, EventArgs e)
    {
        GridView gridView = (GridView)sender;
        if ((gridView.ShowHeader && gridView.Rows.Count > 0) || gridView.ShowHeaderWhenEmpty)
        {
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    protected void expenseClaimGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ApproveClaim" && e.CommandName != "DisApproveClaim")
        {
            return;
        }

        int rowIndex;
        if (!Int32.TryParse(e.CommandArgument.ToString(), out rowIndex))
        {
            ShowMessageBox("Invalid row!");
            return;
        }

        int expenseClaimId;
        if (!Int32.TryParse(expenseClaimGridView.DataKeys[rowIndex]["ExpenseClaimID"].ToString(), out expenseClaimId))
        {
            ShowMessageBox("Invalid expense claim ID!");
            return;
        }

        string approvalStatus = e.CommandName == "ApproveClaim"
            ? ApprovalStatusApproved
            : ApprovalStatusDisApproved;

        try
        {
            int affectedRows = UpdateDAExpenseClaimApprovalStatus(expenseClaimId, approvalStatus, GetLoginUserId(), GetLoginName());
            if (affectedRows <= 0)
            {
                ShowMessageBox("This DA expense claim was not updated. It may already be approved or disapproved.");
                LoadExpenseClaims();
                return;
            }

            ShowMessageBox("Operation successful!");
            LoadExpenseClaims();
        }
        catch (Exception ex)
        {
            ShowMessageBox(ex.Message);
        }
    }

    public bool HasImage(object imagePath, object imageName)
    {
        return !String.IsNullOrWhiteSpace(Convert.ToString(imagePath)) ||
               !String.IsNullOrWhiteSpace(Convert.ToString(imageName));
    }

    public string GetImageUrl(object imagePath, object imageName)
    {
        string path = Convert.ToString(imagePath).Trim();
        string name = Convert.ToString(imageName).Trim();

        if (String.IsNullOrEmpty(path))
        {
            return ResolveUrl(name);
        }

        if (String.IsNullOrEmpty(name) || path.EndsWith(name, StringComparison.OrdinalIgnoreCase))
        {
            return ResolveUrl(path);
        }

        return ResolveUrl(path.TrimEnd('/', '\\') + "/" + name);
    }

    private void LoadSalesCenters()
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
            daDropDownList.Items.Clear();
        }
    }

    private void LoadRouteList()
    {
        rootDropDownList.Items.Clear();
        daDropDownList.Items.Clear();

        int comUnitId;
        if (!Int32.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId))
        {
            InsertDefaultItem(rootDropDownList);
            InsertDefaultItem(daDropDownList);
            return;
        }

        try
        {
            aOrderInfoBll.LoadRouteforReturn(rootDropDownList, comUnitId);
        }
        catch
        {
            rootDropDownList.Items.Clear();
        }

        if (rootDropDownList.Items.FindByValue(String.Empty) == null)
        {
            rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        }

        rootDropDownList.SelectedIndex = 0;
        InsertDefaultItem(daDropDownList);
    }

    private void LoadDAList()
    {
        daDropDownList.Items.Clear();

        int routeId;
        if (!Int32.TryParse(rootDropDownList.SelectedValue, out routeId))
        {
            InsertDefaultItem(daDropDownList);
            return;
        }

        try
        {
            RouteInformationDAL_daaw routeDal = new RouteInformationDAL_daaw();
            using (DataTable dataTable = routeDal.GeteRouteInformationDA_DDLId(routeId.ToString(CultureInfo.InvariantCulture)))
            {
                daDropDownList.DataSource = dataTable;
                daDropDownList.DataValueField = "DANameId";
                daDropDownList.DataTextField = "DAName";
                daDropDownList.DataBind();
            }
        }
        catch
        {
            daDropDownList.Items.Clear();
        }

        daDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        daDropDownList.SelectedIndex = 0;
    }

    private void LoadExpenseClaims()
    {
        ClearGrid();

        int comUnitId;
        if (!Int32.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId))
        {
            ShowMessageBox("Please input Sales Center!");
            salesCenterDropDownList.Focus();
            return;
        }

        int routeIdValue;
        int? routeId = Int32.TryParse(rootDropDownList.SelectedValue, out routeIdValue)
            ? (int?)routeIdValue
            : null;

        int daIdValue;
        int? daId = Int32.TryParse(daDropDownList.SelectedValue, out daIdValue)
            ? (int?)daIdValue
            : null;

        DateTime fromDateValue;
        DateTime? fromDate = null;
        if (!String.IsNullOrWhiteSpace(fromDateTextBox.Text.Trim()))
        {
            if (!TryParseDate(fromDateTextBox.Text.Trim(), out fromDateValue))
            {
                ShowMessageBox("Please input a valid From Date!");
                fromDateTextBox.Focus();
                return;
            }

            fromDate = fromDateValue.Date;
        }

        DateTime toDateValue;
        DateTime? toDate = null;
        if (!String.IsNullOrWhiteSpace(toDateTextBox.Text.Trim()))
        {
            if (!TryParseDate(toDateTextBox.Text.Trim(), out toDateValue))
            {
                ShowMessageBox("Please input a valid To Date!");
                toDateTextBox.Focus();
                return;
            }

            toDate = toDateValue.Date;
        }

        if (fromDate.HasValue && toDate.HasValue && fromDate.Value > toDate.Value)
        {
            ShowMessageBox("From Date cannot be greater than To Date!");
            fromDateTextBox.Focus();
            return;
        }

        using (DataSet dataSet = GetDAExpenseClaimList(comUnitId, routeId, daId, fromDate, toDate))
        {
            DataTable claims = dataSet.Tables.Count > 0 ? dataSet.Tables[0] : new DataTable();
            DataTable pendingClaims = claims.Clone();

            foreach (DataRow row in claims.Select("ApprovalStatus = '0' OR ApprovalStatus IS NULL OR ApprovalStatus = ''"))
            {
                pendingClaims.ImportRow(row);
            }

            expenseClaimGridView.DataSource = pendingClaims;
            expenseClaimGridView.DataBind();
            lblCount.Text = "Total Record: " + pendingClaims.Rows.Count;
        }
    }

    private DataSet GetDAExpenseClaimList(int comUnitId, int? routeId, int? daId, DateTime? fromDate, DateTime? toDate)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
        parameters.Add(new SqlParameter("@RouteId", routeId.HasValue ? (object)routeId.Value : DBNull.Value));
        parameters.Add(new SqlParameter("@daid", daId.HasValue ? (object)daId.Value : DBNull.Value));
        parameters.Add(new SqlParameter("@FromDate", fromDate.HasValue ? (object)fromDate.Value : DBNull.Value));
        parameters.Add(new SqlParameter("@ToDate", toDate.HasValue ? (object)toDate.Value : DBNull.Value));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            return accessManager.GetDataSet("sp_Get_DAExpenseClaimList", parameters);
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private int UpdateDAExpenseClaimApprovalStatus(int expenseClaimId, string approvalStatus, int approvedBy, string updateBy)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ExpenseClaimID", expenseClaimId));
        parameters.Add(new SqlParameter("@ApprovalStatus", approvalStatus));
        parameters.Add(new SqlParameter("@ApprovedBy", approvedBy > 0 ? (object)approvedBy : DBNull.Value));
        parameters.Add(new SqlParameter("@UpdateBy", String.IsNullOrEmpty(updateBy) ? (object)DBNull.Value : updateBy));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            using (DataTable dt = accessManager.GetDataTable("sp_Update_DAExpenseClaimApprovalStatus", parameters))
            {
                if (dt.Rows.Count == 0 || !dt.Columns.Contains("AffectedRows"))
                {
                    return 0;
                }

                int affectedRows;
                return Int32.TryParse(dt.Rows[0]["AffectedRows"].ToString(), out affectedRows) ? affectedRows : 0;
            }
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private void ClearGrid()
    {
        expenseClaimGridView.DataSource = null;
        expenseClaimGridView.DataBind();
        lblCount.Text = "Total Record: 0";
    }

    private static void InsertDefaultItem(DropDownList dropDownList)
    {
        dropDownList.Items.Clear();
        dropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + message + "');", true);
    }

    private int GetLoginUserId()
    {
        int userId;
        return Session["UserId"] != null && Int32.TryParse(Session["UserId"].ToString(), out userId) ? userId : 0;
    }

    private string GetLoginName()
    {
        if (Session["LoginName"] != null && !String.IsNullOrEmpty(Session["LoginName"].ToString()))
        {
            return Session["LoginName"].ToString();
        }

        return Session["UserId"] == null ? String.Empty : Session["UserId"].ToString();
    }

    private static bool TryParseDate(string value, out DateTime dateValue)
    {
        string[] formats = new string[]
        {
            "dd-MMM-yyyy", "dd MMMM, yyyy", "dd MMM, yyyy", "dd MMM yyyy",
            "M/d/yyyy", "MM/dd/yyyy", "yyyy-MM-dd"
        };

        if (DateTime.TryParseExact(value, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out dateValue))
        {
            return true;
        }

        return DateTime.TryParse(value, out dateValue);
    }
}
