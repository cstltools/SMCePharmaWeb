using Library.DAL.DataManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_SalesAssistantDAClaimList : System.Web.UI.Page
{
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();
    private readonly Library.BLL.SInventory_BLL.OrderInfoBLL_daaw aOrderInfoBll = new Library.BLL.SInventory_BLL.OrderInfoBLL_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
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

            fromDateTextBox.Text = DateTime.Today.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Today.ToString("dd MMMM, yyyy");

            LoadData();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("SalesAssistantDAClaimList.aspx");
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        using (DataTable dataTable = GetSalesAssistantDAClaimList())
        {
            if (dataTable.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('No Data Found!','Faild');", true);
                return;
            }

            gv_Export.AllowPaging = false;
            gv_Export.DataSource = dataTable;
            gv_Export.DataBind();

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Sales Assistant DA Claim List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            Response.Output.Write(BuildCsv(gv_Export));
            Response.Flush();
            Response.End();
        }
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        LoadData();
    }

    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader && gv.Rows.Count > 0) || gv.ShowHeaderWhenEmpty)
        {
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    private void LoadData()
    {
        using (DataTable dataTable = GetSalesAssistantDAClaimList())
        {
            loadGridView.DataSource = dataTable;
            loadGridView.DataBind();
            lblCount.Text = "Total Record: " + dataTable.Rows.Count;
        }
    }

    private DataTable GetSalesAssistantDAClaimList()
    {
        try
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            
            int comUnitId = 0;
            if (salesCenterDropDownList != null && int.TryParse(salesCenterDropDownList.SelectedValue, out comUnitId) && comUnitId > 0)
            {
                parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
            }
            else
            {
                parameters.Add(new SqlParameter("@ComUnitId", DBNull.Value));
            }

            DateTime fromDate;
            if (fromDateTextBox != null && TryParseDate(fromDateTextBox.Text.Trim(), out fromDate))
            {
                parameters.Add(new SqlParameter("@FromDate", fromDate.Date));
            }
            else
            {
                parameters.Add(new SqlParameter("@FromDate", DBNull.Value));
            }

            DateTime toDate;
            if (toDateTextBox != null && TryParseDate(toDateTextBox.Text.Trim(), out toDate))
            {
                parameters.Add(new SqlParameter("@ToDate", toDate.Date));
            }
            else
            {
                parameters.Add(new SqlParameter("@ToDate", DBNull.Value));
            }

            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            return accessManager.GetDataTable("sAlesAssistantDAClaimList", parameters);
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private static bool TryParseDate(string value, out DateTime dateValue)
    {
        string[] formats = new string[] { "dd-MMM-yyyy", "dd MMM, yyyy", "dd MMM yyyy", "M/d/yyyy", "MM/dd/yyyy", "yyyy-MM-dd" };
        if (DateTime.TryParseExact(value, formats, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out dateValue))
        {
            return true;
        }

        return DateTime.TryParse(value, out dateValue);
    }

    private static string BuildCsv(GridView gridView)
    {
        StringBuilder sb = new StringBuilder();

        foreach (TableCell cell in gridView.HeaderRow.Cells)
        {
            AppendCsvCell(sb, HttpUtility.HtmlDecode(cell.Text));
        }

        sb.Append("\r\n");

        foreach (GridViewRow row in gridView.Rows)
        {
            foreach (TableCell cell in row.Cells)
            {
                AppendCsvCell(sb, HttpUtility.HtmlDecode(cell.Text));
            }

            sb.Append("\r\n");
        }

        return sb.ToString();
    }

    private static void AppendCsvCell(StringBuilder sb, string value)
    {
        value = (value ?? String.Empty).Replace("\"", "\"\"");
        sb.Append("\"").Append(value).Append("\",");
    }
}
