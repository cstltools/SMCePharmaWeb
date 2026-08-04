using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.DataManager;

public partial class SInventory_UI_DAClaim_DICApprovalList : System.Web.UI.Page
{
    private const string DicApprovalStatusApproved = "Approved";
    private const string DicApprovalStatusDisApproved = "DisApproved";
    private readonly OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            entryDateTextBox.Text = DateTime.Today.ToString("dd MMMM, yyyy");
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DAClaim_DICApprovalList.aspx");
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

    protected void daClaimGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ApproveClaim" && e.CommandName != "DisApproveClaim")
        {
            return;
        }

        int rowIndex;
        if (!int.TryParse(e.CommandArgument.ToString(), out rowIndex))
        {
            ShowMessageBox("Invalid row!");
            return;
        }

        int daClaimId;
        if (!int.TryParse(daClaimGridView.DataKeys[rowIndex]["DAClaimId"].ToString(), out daClaimId))
        {
            ShowMessageBox("Invalid DA Claim ID!");
            return;
        }

        string dicApprovalStatus = e.CommandName == "ApproveClaim"
            ? DicApprovalStatusApproved
            : DicApprovalStatusDisApproved;

        try
        {
            int affectedRows = UpdateDAClaimDICApprovalStatus(daClaimId, dicApprovalStatus, GetLoginName());
            if (affectedRows <= 0)
            {
                ShowMessageBox("This DA claim was not updated. It may already be approved or disapproved.");
                GridView();
                return;
            }

            ShowMessageBox("Operation successful!");
            GridView();
        }
        catch (Exception ex)
        {
            ShowMessageBox(ex.Message);
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

        DateTime entryDate;
        if (!TryParseDate(entryDateTextBox.Text.Trim(), out entryDate))
        {
            ShowMessageBox("Please input Entry Date!");
            entryDateTextBox.Focus();
            return;
        }

        using (DataTable aTable = GetDAClaimDICApprovalList(comUnitId, routeId, entryDate))
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

        return GetDataTable("sp_Get_DAClaimDARouteList", parameters);
    }

    private DataTable GetDAClaimDICApprovalList(int comUnitId, int routeId, DateTime entryDate)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
        parameters.Add(new SqlParameter("@RouteId", routeId));
        parameters.Add(new SqlParameter("@EntryDate", entryDate.Date));

        return GetDataTable("sp_Get_DAClaimDICApprovalList", parameters);
    }

    private int UpdateDAClaimDICApprovalStatus(int daClaimId, string dicApprovalStatus, string dicApprovalBy)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@DAClaimId", daClaimId));
        parameters.Add(new SqlParameter("@DICApprovalStatus", dicApprovalStatus));
        parameters.Add(new SqlParameter("@DICApprovalBy", String.IsNullOrEmpty(dicApprovalBy) ? (object)DBNull.Value : dicApprovalBy));

        using (DataTable dt = GetDataTable("sp_Update_DAClaimDICApprovalStatus", parameters))
        {
            if (dt.Rows.Count == 0 || !dt.Columns.Contains("AffectedRows"))
            {
                return 0;
            }

            int affectedRows;
            return int.TryParse(dt.Rows[0]["AffectedRows"].ToString(), out affectedRows) ? affectedRows : 0;
        }
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
        string[] formats = new string[] { "dd-MMM-yyyy", "dd MMM, yyyy", "dd MMM yyyy", "M/d/yyyy", "MM/dd/yyyy", "yyyy-MM-dd" };
        if (DateTime.TryParseExact(value, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out dateValue))
        {
            return true;
        }

        return DateTime.TryParse(value, out dateValue);
    }
}
