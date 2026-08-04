using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.DataManager;

public partial class SInventory_UI_DAExpenseSummaryReport : System.Web.UI.Page
{
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();
    private readonly OrderInfoBLL_daaw aOrderInfoBll = new OrderInfoBLL_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialInfo();
            LoadData();
        }
    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadDAList();
        ClearGrid();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("DAExpenseSummaryReport.aspx");
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox chkBoxRows = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
        }
    }

    protected void loadGridView_PreRender(object sender, EventArgs e)
    {
        GridView gridView = (GridView)sender;
        if ((gridView.ShowHeader && gridView.Rows.Count > 0) || gridView.ShowHeaderWhenEmpty)
        {
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    protected void btnPrint_OnClick(object sender, EventArgs e)
    {
        OpenReport("Print");
    }

    protected void btnViewReport_Click(object sender, EventArgs e)
    {
        OpenReport("View");
    }

    private void LoadInitialInfo()
    {
        try
        {
            aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
            if (salesCenterDropDownList.Items.Count > 1)
            {
                salesCenterDropDownList.SelectedIndex = 1;
            }
        }
        catch
        {
            salesCenterDropDownList.Items.Clear();
        }

        LoadDefaultDates();
        LoadDAList();
    }

    private void LoadDefaultDates()
    {
        DateTime startDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
        DateTime endDate = startDate.AddMonths(1).AddDays(-1);
        fromDateTextBox.Text = startDate.ToString("dd MMMM, yyyy", CultureInfo.InvariantCulture);
        toDateTextBox.Text = endDate.ToString("dd MMMM, yyyy", CultureInfo.InvariantCulture);
    }

    private void LoadDAList()
    {
        daDropDownList.Items.Clear();

        int comUnitId;
        if (!Int32.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId))
        {
            daDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            return;
        }

        try
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter("@ComUnitId", comUnitId));

            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            using (DataTable dt = accessManager.GetDataTableByText("SELECT DAId, ISNULL(DACode, '') + ' : ' + ISNULL(Name, '') AS DAName FROM dbo.tblDAInfo WITH (NOLOCK) WHERE ISNULL(IsActive, 1) = 1 AND ComUnitId = @ComUnitId ORDER BY Name", parameters, true))
            {
                daDropDownList.DataSource = dt;
                daDropDownList.DataValueField = "DAId";
                daDropDownList.DataTextField = "DAName";
                daDropDownList.DataBind();
            }
        }
        catch
        {
            daDropDownList.Items.Clear();
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }

        daDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        daDropDownList.SelectedIndex = 0;
    }

    private void LoadData()
    {
        using (DataTable dataTable = GetSummaryData())
        {
            loadGridView.DataSource = dataTable;
            loadGridView.DataBind();
            lblCount.Text = "Total Record: " + dataTable.Rows.Count;
        }
    }

    private DataTable GetSummaryData()
    {
        int comUnitId;
        int daId;
        DateTime fromDate;
        DateTime toDate;
        GetSelectedDateRange(out fromDate, out toDate);

        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@Mode", "Summary"));
        parameters.Add(new SqlParameter("@ComUnitId", Int32.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId) ? (object)comUnitId : DBNull.Value));
        parameters.Add(new SqlParameter("@Month", DBNull.Value));
        parameters.Add(new SqlParameter("@Year", DBNull.Value));
        parameters.Add(new SqlParameter("@DAId", Int32.TryParse(daDropDownList.SelectedValue, out daId) ? (object)daId : DBNull.Value));
        parameters.Add(new SqlParameter("@DAIds", DBNull.Value));
        parameters.Add(new SqlParameter("@FromDate", fromDate));
        parameters.Add(new SqlParameter("@ToDate", toDate));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            return accessManager.GetDataTable("sp_Get_DAExpenseDayWiseSummary", parameters);
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private void OpenReport(string reportType)
    {
        string selectedDAIds = GetSelectedDAIds();
        if (String.IsNullOrEmpty(selectedDAIds))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Please Select at least one DA!','Faild');", true);
            return;
        }

        string url = "../SInventory_RPTVIEW/DAExpenseDayWiseSummaryViewer.aspx?daIds=" + selectedDAIds
            + "&fType=" + reportType;

        DateTime fromDate;
        DateTime toDate;
        GetSelectedDateRange(out fromDate, out toDate);
        url += "&FromDate=" + Server.UrlEncode(fromDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture))
            + "&ToDate=" + Server.UrlEncode(toDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));

        string fullURL = "window.open('" + url + "', '_blank', 'height=650,width=950,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=yes,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    private string GetSelectedDAIds()
    {
        List<string> selectedDAIds = new List<string>();
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox chkBoxRows = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");
            HiddenField hfDAId = (HiddenField)loadGridView.Rows[i].FindControl("hfDAId");
            if (chkBoxRows != null && hfDAId != null && chkBoxRows.Checked)
            {
                selectedDAIds.Add(hfDAId.Value);
            }
        }

        return String.Join(",", selectedDAIds.ToArray());
    }

    private void GetSelectedDateRange(out DateTime fromDate, out DateTime toDate)
    {
        fromDate = GetSelectedFromDate();
        toDate = GetSelectedToDate();

        if (toDate < fromDate)
        {
            DateTime swapDate = fromDate;
            fromDate = toDate;
            toDate = swapDate;
        }
    }

    private DateTime GetSelectedFromDate()
    {
        DateTime fromDate;
        if (TryParseDate(fromDateTextBox.Text, out fromDate))
        {
            return fromDate.Date;
        }

        return new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
    }

    private DateTime GetSelectedToDate()
    {
        DateTime toDate;
        if (TryParseDate(toDateTextBox.Text, out toDate))
        {
            return toDate.Date;
        }

        return new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).AddMonths(1).AddDays(-1);
    }

    private static bool TryParseDate(string value, out DateTime date)
    {
        return DateTime.TryParseExact(value, "dd MMMM, yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out date)
            || DateTime.TryParse(value, CultureInfo.CurrentCulture, DateTimeStyles.None, out date)
            || DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out date);
    }

    private void ClearGrid()
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
        lblCount.Text = "Total Record: 0";
    }
}
