using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;

public partial class SInventory_UI_ExpiryReturnReport : System.Web.UI.Page
{
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

    private string roleTypeName = String.Empty;
    private string roleTypeId = String.Empty;
    private string empInfoId = String.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["RoleTypeName"] != null) roleTypeName = Session["RoleTypeName"].ToString();
        if (Session["RoleTypeId"] != null) roleTypeId = Session["RoleTypeId"].ToString();
        if (Session["EmpInfoId"] != null) empInfoId = Session["EmpInfoId"].ToString();

        if (!IsPostBack)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            LoadDropDown();
        }
    }

    private bool IsDicUser()
    {
        return String.Equals(roleTypeName, "DIC", StringComparison.OrdinalIgnoreCase) || roleTypeId == "8";
    }

    private void LoadDropDown()
    {
        try
        {
            dcDropDownList1.Items.Clear();

            int currentEmpId = 0;
            int.TryParse(empInfoId, out currentEmpId);
            int currentUserId = 0;
            if (Session["UserId"] != null) int.TryParse(Session["UserId"].ToString(), out currentUserId);

            List<SqlParameter> parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter("@UserId", currentUserId));
            parameters.Add(new SqlParameter("@EmpInfoId", currentEmpId));
            parameters.Add(new SqlParameter("@RoleTypeName", String.IsNullOrEmpty(roleTypeName) ? (object)DBNull.Value : roleTypeName));

            DataTable dtSc = GetDataTable("sp_Get_UserDistributionCenters", parameters);
            if (dtSc != null && dtSc.Rows.Count > 0)
            {
                dcDropDownList1.DataSource = dtSc;
                dcDropDownList1.DataValueField = "ComUnitId";
                dcDropDownList1.DataTextField = "ComUnitName";
                dcDropDownList1.DataBind();
            }

            if (IsDicUser())
            {
                if (Session["DICCompanyUnitId"] != null && !String.IsNullOrEmpty(Session["DICCompanyUnitId"].ToString()))
                {
                    dcDropDownList1.SelectedValue = Session["DICCompanyUnitId"].ToString();
                    dcDropDownList1.Enabled = false;
                }
            }
            else
            {
                dcDropDownList1.Items.Insert(0, new ListItem("--------Select---------", "0"));
                dcDropDownList1.SelectedIndex = 0;
            }
        }
        catch
        {
            dcDropDownList1.Items.Clear();
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        loadGridView.PageIndex = 0;
        LoadData();
    }

    private bool IsSummary()
    {
        return rblReportType.SelectedValue == "Summary";
    }

    protected void rblReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.PageIndex = 0;
        summaryGridView.PageIndex = 0;
        LoadData();
    }

    protected void summaryGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        summaryGridView.PageIndex = e.NewPageIndex;
        LoadData();
    }

    protected void summaryGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ViewDetails") return;

        string[] parts = Convert.ToString(e.CommandArgument).Split('|');
        if (parts.Length < 3) return;
        string scCode = parts[0], productCode = parts[1], packSize = parts[2];

        DateTime fromDate, toDate;
        if (!TryGetDates(out fromDate, out toDate)) return;

        DataTable src = GetReportData(fromDate, toDate);
        DataTable detail = src == null ? new DataTable() : src.Clone();
        decimal total = 0;
        string scName = "", productName = "";
        if (src != null)
        {
            foreach (DataRow r in src.Rows)
            {
                string ps = r["PackSize"] == DBNull.Value ? "" : Convert.ToString(r["PackSize"]);
                if (Convert.ToString(r["ComUnitCode"]) != scCode || Convert.ToString(r["ProductCode"]) != productCode || ps != packSize) continue;
                detail.ImportRow(r);
                scName = Convert.ToString(r["ComUnitName"]);
                productName = Convert.ToString(r["ProductName"]);
                if (r["ReturnQty"] != DBNull.Value) total += Convert.ToDecimal(r["ReturnQty"]);
            }
        }

        lblModalSc.Text = HttpUtility.HtmlEncode(scCode + " - " + scName);
        lblModalProduct.Text = HttpUtility.HtmlEncode(productCode + " - " + productName + (packSize.Length > 0 ? " (" + packSize + ")" : ""));
        lblModalPeriod.Text = fromDate.ToString("dd-MMM-yyyy") + " to " + toDate.ToString("dd-MMM-yyyy");
        lblModalTotal.Text = total.ToString("N2");
        litModalBody.Text = BuildInvoiceBlocks(detail);

        ScriptManager.RegisterStartupScript(this, GetType(), "showDetail", "showDetailModal();", true);
    }

    private static string H(object v)
    {
        return v == null || v == DBNull.Value ? "" : HttpUtility.HtmlEncode(Convert.ToString(v));
    }

    private static string D(object v)
    {
        if (v == null || v == DBNull.Value) return "";
        if (v is DateTime) return ((DateTime)v).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
        DateTime dt;
        if (DateTime.TryParse(Convert.ToString(v), out dt)) return dt.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
        return "";
    }

    // One invoice-style block per Expiry Return request: header, product lines, total, approvals
    private static string BuildInvoiceBlocks(DataTable detail)
    {
        if (detail.Rows.Count == 0) return "<p>No Data Found!</p>";

        List<string> order = new List<string>();
        Dictionary<string, List<DataRow>> byReq = new Dictionary<string, List<DataRow>>();
        foreach (DataRow r in detail.Rows)
        {
            string id = Convert.ToString(r["ExpiryReturnId"]);
            if (!byReq.ContainsKey(id)) { byReq[id] = new List<DataRow>(); order.Add(id); }
            byReq[id].Add(r);
        }

        StringBuilder sb = new StringBuilder();
        foreach (string id in order)
        {
            List<DataRow> lines = byReq[id];
            DataRow h = lines[0];
            sb.Append("<div class=\"invBlock\">");
            sb.Append("<table class=\"infoTbl\" style=\"width:100%;font-size:13px;margin-bottom:6px\">");
            sb.Append("<tr><td><b>Request No:</b> " + H(id) + "</td><td><b>Submit Date:</b> " + D(h["SubmitDate"]) + "</td></tr>");
            sb.Append("<tr><td><b>Customer:</b> " + H(h["CustomerCode"]) + " - " + H(h["CustomerName"]) + "</td><td><b>DA:</b> " + H(h["DACode"]) + " - " + H(h["DAName"]) + "</td></tr>");
            sb.Append("<tr><td colspan=\"2\"><b>Remarks:</b> " + H(h["Remarks"]) + "</td></tr></table>");

            sb.Append("<table class=\"table table-bordered table-sm\" style=\"width:100%;margin-bottom:6px\"><thead><tr>");
            sb.Append("<th>SL</th><th>Product Code</th><th>Product Name</th><th>Pack Size</th><th>Batch No</th><th>Exp Date</th><th style=\"text-align:right\">Return Qty</th><th>Reason</th></tr></thead><tbody>");
            decimal total = 0;
            int sl = 1;
            foreach (DataRow r in lines)
            {
                decimal q = r["ReturnQty"] == DBNull.Value ? 0 : Convert.ToDecimal(r["ReturnQty"]);
                total += q;
                sb.Append("<tr><td>" + (sl++) + "</td><td>" + H(r["ProductCode"]) + "</td><td>" + H(r["ProductName"]) + "</td><td>" + H(r["PackSize"]) +
                          "</td><td>" + H(r["BatchNo"]) + "</td><td>" + D(r["ExpDate"]) + "</td><td style=\"text-align:right\">" + q.ToString("N2") +
                          "</td><td>" + H(r["ReasonName"]) + "</td></tr>");
            }
            sb.Append("</tbody><tfoot><tr><td colspan=\"6\" style=\"text-align:right\"><b>Total</b></td><td style=\"text-align:right\"><b>" + total.ToString("N2") + "</b></td><td></td></tr></tfoot></table>");

            string daName = H(h["DAName"]);
            string daDate = D(h["SubmitDate"]);
            string amName = H(h["AM_EmpName"]);
            string amDate = D(h["AM_ApproveDate"]);
            string dzsmName = H(h["DZSM_EmpName"]);
            string dzsmDate = D(h["DZSM_ApproveDate"]);
            string dicName = H(h["DIC_EmpName"]);
            string dicDate = D(h["DIC_ApproveDate"]);

            sb.Append("<table class=\"infoTbl\" style=\"width:100%;font-size:12px;margin-top:10px\"><tr>");
            sb.Append("<td style=\"width:25%;vertical-align:top\"><b>1) Expiry collected by:</b><br />" + (daName.Length > 0 ? daName : "&nbsp;") + (daDate.Length > 0 ? "<br />" + daDate : "") + "</td>");
            sb.Append("<td style=\"width:25%;vertical-align:top\"><b>2) Checked By AM:</b><br />" + (amName.Length > 0 ? amName : "&nbsp;") + (amDate.Length > 0 ? "<br />" + amDate : "") + "</td>");
            sb.Append("<td style=\"width:25%;vertical-align:top\"><b>3) Checked &amp; Recomm by Zonal Head:</b><br />" + (dzsmName.Length > 0 ? dzsmName : "&nbsp;") + (dzsmDate.Length > 0 ? "<br />" + dzsmDate : "") + "</td>");
            sb.Append("<td style=\"width:25%;vertical-align:top\"><b>4) Check and Received by DIC:</b><br />" + (dicName.Length > 0 ? dicName : "&nbsp;") + (dicDate.Length > 0 ? "<br />" + dicDate : "") + "</td>");
            sb.Append("</tr></table></div>");
        }
        return sb.ToString();
    }

    // Sales Center + Product + Pack Size wise total of the details rows
    private static DataTable BuildSummary(DataTable src)
    {
        DataTable res = new DataTable();
        res.Columns.Add("ComUnitCode", typeof(string));
        res.Columns.Add("ComUnitName", typeof(string));
        res.Columns.Add("ProductCode", typeof(string));
        res.Columns.Add("ProductName", typeof(string));
        res.Columns.Add("PackSize", typeof(string));
        res.Columns.Add("RequestCount", typeof(int));
        res.Columns.Add("ReturnQty", typeof(decimal));
        if (src == null) return res;

        Dictionary<string, DataRow> rows = new Dictionary<string, DataRow>();
        Dictionary<string, HashSet<string>> requests = new Dictionary<string, HashSet<string>>();
        foreach (DataRow r in src.Rows)
        {
            string cu = Convert.ToString(r["ComUnitCode"]);
            string pc = Convert.ToString(r["ProductCode"]);
            string ps = r["PackSize"] == DBNull.Value ? "" : Convert.ToString(r["PackSize"]);
            string key = cu + "|" + pc + "|" + ps;

            DataRow s;
            if (!rows.TryGetValue(key, out s))
            {
                s = res.NewRow();
                s["ComUnitCode"] = cu;
                s["ComUnitName"] = Convert.ToString(r["ComUnitName"]);
                s["ProductCode"] = pc;
                s["ProductName"] = Convert.ToString(r["ProductName"]);
                s["PackSize"] = ps;
                s["RequestCount"] = 0;
                s["ReturnQty"] = 0m;
                res.Rows.Add(s);
                rows[key] = s;
                requests[key] = new HashSet<string>();
            }
            if (r["ReturnQty"] != DBNull.Value) s["ReturnQty"] = (decimal)s["ReturnQty"] + Convert.ToDecimal(r["ReturnQty"]);
            if (requests[key].Add(Convert.ToString(r["ExpiryReturnId"]))) s["RequestCount"] = (int)s["RequestCount"] + 1;
        }

        res.DefaultView.Sort = "ComUnitCode ASC, ProductName ASC";
        return res.DefaultView.ToTable();
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ExpiryReturnReport.aspx");
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        LoadData();
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + message + "');", true);
    }

    private bool TryGetDates(out DateTime fromDate, out DateTime toDate)
    {
        toDate = DateTime.MinValue;
        if (!DateTime.TryParse(fromDateTextBox.Text, out fromDate) || !DateTime.TryParse(toDateTextBox.Text, out toDate))
        {
            ShowMessageBox("Please select From Date and To Date!");
            return false;
        }
        if (fromDate > toDate)
        {
            ShowMessageBox("From Date can not be greater than To Date!");
            return false;
        }
        return true;
    }

    private DataTable GetReportData(DateTime fromDate, DateTime toDate)
    {
        int comUnitId = 0;
        int.TryParse(dcDropDownList1.SelectedValue, out comUnitId);
        int currentEmpId = 0;
        int.TryParse(empInfoId, out currentEmpId);

        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@ComUnitId", comUnitId));
        parameters.Add(new SqlParameter("@FromDate", fromDate.Date));
        parameters.Add(new SqlParameter("@ToDate", toDate.Date));
        parameters.Add(new SqlParameter("@RoleTypeName", String.IsNullOrEmpty(roleTypeName) ? (object)DBNull.Value : roleTypeName));
        parameters.Add(new SqlParameter("@EmpInfoId", currentEmpId));
        parameters.Add(new SqlParameter("@ApprovalStatus", ddlApprovalStatus.SelectedValue));

        return GetDataTable("sp_Get_ExpiryReturnReport", parameters);
    }

    private void LoadData()
    {
        DateTime fromDate, toDate;
        if (!TryGetDates(out fromDate, out toDate)) return;

        if (IsDicUser() && dcDropDownList1.SelectedValue == "0")
        {
            ShowMessageBox("Please input Sales Center!");
            return;
        }

        DataTable dt = GetReportData(fromDate, toDate);
        bool isSummary = IsSummary();
        lblListTitle.Text = isSummary ? "Summary List" : "Details List";
        loadGridView.Visible = !isSummary;
        summaryGridView.Visible = isSummary;
        if (isSummary)
        {
            summaryGridView.DataSource = BuildSummary(dt);
            summaryGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = dt;
            loadGridView.DataBind();
        }

        decimal totalQty = 0;
        if (dt != null)
        {
            foreach (DataRow r in dt.Rows)
            {
                if (r["ReturnQty"] != DBNull.Value) totalQty += Convert.ToDecimal(r["ReturnQty"]);
            }
        }
        lblCount.Text = "Total Return Qty : " + totalQty.ToString("N2");
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        DateTime fromDate, toDate;
        if (!TryGetDates(out fromDate, out toDate)) return;

        DataTable src = GetReportData(fromDate, toDate);
        if (src == null || src.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('No Data Found!','Failed');", true);
            return;
        }

        string stamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
        if (IsSummary())
            WriteCsvAndEnd(BuildSummary(src), SummaryExportColumns, "ExpiryReturn_Summary_" + stamp + ".csv");
        else
            WriteCsvAndEnd(src, ExportColumns, "ExpiryReturn_Report_" + stamp + ".csv");
    }

    private static string CsvEscape(string s)
    {
        if (String.IsNullOrEmpty(s)) return "";
        s = s.Replace("\"", "\"\"");
        bool mustQuote = s.IndexOfAny(new[] { ',', '"', '\n', '\r' }) >= 0;
        return mustQuote ? "\"" + s + "\"" : s;
    }

    private static string FormatCell(object val, string dataField)
    {
        if (val == null || val == DBNull.Value) return "";
        if (val is DateTime) return ((DateTime)val).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
        if (dataField == "ReturnQty" && !(val is string)) return Convert.ToDecimal(val).ToString("0.##", CultureInfo.InvariantCulture);
        return Convert.ToString(val);
    }

    // Same order/headers as the GridView
    static readonly Tuple<string, string>[] ExportColumns = new Tuple<string, string>[] {
        Tuple.Create("ComUnitCode", "Sales Center"),
        Tuple.Create("ComUnitName", "Sales Center Name"),
        Tuple.Create("DACode", "DA Code"),
        Tuple.Create("DAName", "DA Name"),
        Tuple.Create("CustomerCode", "Customer Code"),
        Tuple.Create("CustomerName", "Customer Name"),
        Tuple.Create("SubmitDate", "Submit Date"),
        Tuple.Create("ProductCode", "Product Code"),
        Tuple.Create("ProductName", "Product Name"),
        Tuple.Create("PackSize", "Pack Size"),
        Tuple.Create("BatchNo", "Batch No"),
        Tuple.Create("ExpDate", "Exp Date"),
        Tuple.Create("ReturnQty", "Return Qty"),
        Tuple.Create("ReasonName", "Reason"),
        Tuple.Create("Remarks", "Remarks"),
        Tuple.Create("AM_EmpCode", "AM Emp Code"),
        Tuple.Create("AM_EmpName", "AM Name"),
        Tuple.Create("AM_ApproveDate", "AM Approve Date"),
        Tuple.Create("DZSM_EmpCode", "DZSM Emp Code"),
        Tuple.Create("DZSM_EmpName", "DZSM Name"),
        Tuple.Create("DZSM_ApproveDate", "DZSM Approve Date"),
        Tuple.Create("DIC_EmpCode", "DIC Emp Code"),
        Tuple.Create("DIC_EmpName", "DIC Name"),
        Tuple.Create("DIC_ApproveDate", "DIC Approve Date"),
    };

    static readonly Tuple<string, string>[] SummaryExportColumns = new Tuple<string, string>[] {
        Tuple.Create("ComUnitCode", "Sales Center"),
        Tuple.Create("ComUnitName", "Sales Center Name"),
        Tuple.Create("ProductCode", "Product Code"),
        Tuple.Create("ProductName", "Product Name"),
        Tuple.Create("PackSize", "Pack Size"),
        Tuple.Create("RequestCount", "No. of Requests"),
        Tuple.Create("ReturnQty", "Total Return Qty"),
    };

    private static void WriteCsvAndEnd(DataTable dt, Tuple<string, string>[] ExportColumns, string fileName)
    {
        var resp = HttpContext.Current.Response;
        resp.Clear();
        resp.ClearHeaders();
        resp.Buffer = true;
        resp.ContentType = "text/csv";
        resp.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        resp.Cache.SetCacheability(HttpCacheability.NoCache);

        var sb = new StringBuilder();
        for (int i = 0; i < ExportColumns.Length; i++)
        {
            if (i > 0) sb.Append(',');
            sb.Append(CsvEscape(ExportColumns[i].Item2));
        }
        sb.Append("\r\n");

        foreach (DataRow r in dt.Rows)
        {
            for (int i = 0; i < ExportColumns.Length; i++)
            {
                if (i > 0) sb.Append(',');
                string field = ExportColumns[i].Item1;
                object val = dt.Columns.Contains(field) ? r[field] : null;
                sb.Append(CsvEscape(FormatCell(val, field)));
            }
            sb.Append("\r\n");
        }

        resp.BinaryWrite(new UTF8Encoding(true).GetBytes(sb.ToString()));
        resp.Flush();
        resp.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }

    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if ((gv.ShowHeader && gv.Rows.Count > 0) || gv.ShowHeaderWhenEmpty)
        {
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
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
