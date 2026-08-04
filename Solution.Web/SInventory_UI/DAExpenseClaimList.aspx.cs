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

public partial class SInventory_UI_DAExpenseClaimList : System.Web.UI.Page
{
    private const string ExpenseDetailsViewStateKey = "DAExpenseClaimDetails";
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
        Response.Redirect("DAExpenseClaimList.aspx");
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

    protected void expenseClaimGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
        {
            return;
        }

        GridView detailGrid = e.Row.FindControl("expenseDetailGridView") as GridView;
        DataTable details = ViewState[ExpenseDetailsViewStateKey] as DataTable;
        if (detailGrid == null || details == null)
        {
            return;
        }

        int expenseClaimId = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "ExpenseClaimID"));
        DataView detailView = new DataView(details);
        detailView.RowFilter = "ExpenseClaimID = " + expenseClaimId.ToString(CultureInfo.InvariantCulture);
        detailGrid.DataSource = detailView;
        detailGrid.DataBind();
        detailGrid.Visible = detailView.Count > 0;
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
            DataTable details = dataSet.Tables.Count > 1 ? dataSet.Tables[1] : new DataTable();

            ViewState[ExpenseDetailsViewStateKey] = details;
            expenseClaimGridView.DataSource = claims;
            expenseClaimGridView.DataBind();
            lblCount.Text = "Total Record: " + claims.Rows.Count;
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

    private void ClearGrid()
    {
        ViewState.Remove(ExpenseDetailsViewStateKey);
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
