using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

/// <summary>
/// Reverses a DA Partial Sales-Return submit (dadtlsPaymentPartial_DA.aspx) for one invoice:
/// puts the credited quantity back out of tblDCStore, clears the Payment* columns on
/// tblInvoice/tblInvoiceDetail and returns tblSalesReturn_appLog to 'Pending' so the invoice
/// shows up on the DA approval list again.
/// </summary>
public partial class SInventory_UI_RollbackDAPartialSalesReturn : System.Web.UI.Page
{
    // The stock each DCStoreId was credited with at submit time. One row per DCStoreId,
    // mirroring the HashSet<int> updatedDCStoreIds de-dupe in SaveInvoiceDetail — UpdateDCStock
    // is additive, so a batch hit by two grid rows was still credited only once.
    private const string CreditedCte = @"
        WITH credited AS (
            SELECT DCStoreId, Qty FROM (
                SELECT d.DCStoreId,
                       ISNULL(d.DeliveryQuantity,0) - ISNULL(d.PaymentTotalQuantity,0) AS Qty,
                       ROW_NUMBER() OVER (PARTITION BY d.DCStoreId ORDER BY d.InvoiceDetailId) AS rn
                FROM dbo.tblInvoiceDetail d
                WHERE d.InvoiceId = @InvoiceId
                  AND d.PaymentStatus IN ('Partial','Reject')
                  AND d.DCStoreId IS NOT NULL
            ) x WHERE x.rn = 1 AND x.Qty <> 0
        )";

    // The log row the submit approved — the same one GetSalesReturnAppLogIdByInvoiceId picks.
    private const string LatestAppLogId =
        "(SELECT MAX(SalesReturnAppLogId) FROM dbo.tblSalesReturn_appLog WHERE InvoiceId = @InvoiceId)";

    private const string HeaderQuery = @"
        SELECT i.InvoiceId, i.InvoiceNo, i.PaymentInvoiceNo, c.CustomerName, c.CustomerCode,
               l.ReturnType, l.CreatedOn AS ReturnedOn, l.DICApprovalStatus, l.DICApproveDate
        FROM dbo.tblInvoice i
        LEFT JOIN dbo.tblCustMaster c ON c.CustomerMasterId = i.CustomerMasterId
        LEFT JOIN dbo.tblSalesReturn_appLog l ON l.SalesReturnAppLogId = " + LatestAppLogId + @"
        WHERE i.InvoiceId = @InvoiceId";

    // The DA's own return log is the summary source: it survives the rollback and carries the
    // reason and the date the return was raised. Its ReturnQty column holds the CONFIRMED (kept)
    // quantity, so what actually came back is TotalQty - ReturnQty.
    private const string SummaryQuery = @"
        SELECT ld.ProductCode, ld.ProductName, s.BatchNo, s.ExpDate,
               ISNULL(ld.TotalQty,0) AS InvoiceQty,
               ISNULL(ld.TotalQty,0) - ISNULL(ld.ReturnQty,0) AS ReturnedQty,
               (ISNULL(ld.TotalQty,0) - ISNULL(ld.ReturnQty,0)) * ISNULL(ld.UnitPrice,0) AS ReturnValue,
               COALESCE(NULLIF(RTRIM(ld.ReasonLabel),''), NULLIF(RTRIM(ld.ReasonCode),''),
                        NULLIF(RTRIM(d.PaymentReturnReason),''), 'Sales Return') AS Reason,
               ld.CreatedOn AS ReturnedOn,
               ISNULL(s.StockQty,0) AS CurrentStockQty
        FROM dbo.tblSalesReturn_appLogDetail ld
        LEFT JOIN dbo.tblDCStore s ON s.DCStoreId = ld.DCStoreId
        LEFT JOIN dbo.tblInvoiceDetail d ON d.InvoiceDetailId = ld.InvoiceDetailId
        WHERE ld.SalesReturnAppLogId = " + LatestAppLogId + @"
          AND ISNULL(ld.TotalQty,0) - ISNULL(ld.ReturnQty,0) > 0
        ORDER BY ld.SalesReturnAppLogDetailId";

    private static string StockCheckQuery(string lockHint)
    {
        return CreditedCte + @"
        SELECT c.DCStoreId, s.ProductCode, s.BatchNo, c.Qty AS NeedToDeduct,
               ISNULL(s.StockQty,0) AS AvailableStockQty,
               CASE WHEN s.DCStoreId IS NULL THEN 'MISSING'
                    WHEN ISNULL(s.StockQty,0) < c.Qty THEN 'SHORT'
                    ELSE 'OK' END AS StockStatus
        FROM credited c
        LEFT JOIN dbo.tblDCStore s " + lockHint + @" ON s.DCStoreId = c.DCStoreId
        ORDER BY c.DCStoreId";
    }

    private static string ConnectionString
    {
        get { return ConfigurationManager.ConnectionStrings["SolutionConnectionStringSSIDB"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {
        pnlResult.Visible = false;
        btnRollback.Visible = false;
        hfInvoiceId.Value = "";

        string invoiceNo = invoiceNoTextBox.Text.Trim();
        if (invoiceNo.Length == 0)
        {
            ShowMessage("Please input an Invoice No.", false);
            return;
        }

        try
        {
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                int invoiceId = FindInvoiceId(connection, invoiceNo);
                if (invoiceId == 0)
                {
                    ShowMessage("No invoice found for '" + Server.HtmlEncode(invoiceNo) + "'.", false);
                    return;
                }

                DataTable header = Query(connection, null, HeaderQuery, invoiceId);
                ShowSummary(connection, header, invoiceId);

                DataTable stock = Query(connection, null, StockCheckQuery(""), invoiceId);
                gvStock.DataSource = stock;
                gvStock.DataBind();

                pnlResult.Visible = true;
                hfInvoiceId.Value = invoiceId.ToString();

                string paymentInvoiceNo = header.Rows.Count > 0 ? header.Rows[0]["PaymentInvoiceNo"].ToString().Trim() : "";
                if (paymentInvoiceNo.Length == 0)
                {
                    ShowMessage("This invoice has no submitted sales return to roll back.", false);
                    return;
                }

                int badRows = CountBadStock(stock);
                if (badRows > 0)
                {
                    ShowMessage("Cannot roll back: " + badRows + " batch(es) no longer hold the credited quantity (see Status column).", false);
                    return;
                }

                ShowMessage("Ready to roll back. Review the tables below, then press Rollback.", true);
                btnRollback.Visible = true;
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Trace.TraceError("Sales return rollback check failed for '{0}': {1}", invoiceNo, ex);
            ShowMessage("Check failed: " + ex.Message, false);
        }
    }

    protected void btnRollback_Click(object sender, EventArgs e)
    {
        int invoiceId;
        if (!int.TryParse(hfInvoiceId.Value, out invoiceId) || invoiceId == 0)
        {
            ShowMessage("Please press Check first.", false);
            return;
        }

        try
        {
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                // All four tables revert as one atomic unit, and the stock check is re-run inside
                // the transaction under UPDLOCK so a concurrent invoice cannot empty a batch
                // between Check and Rollback.
                SqlTransaction transaction = connection.BeginTransaction(IsolationLevel.ReadCommitted);
                bool committed = false;
                try
                {
                    DataTable stock = Query(connection, transaction, StockCheckQuery("WITH (UPDLOCK, HOLDLOCK)"), invoiceId);

                    if (CountBadStock(stock) > 0)
                    {
                        transaction.Rollback();
                        gvStock.DataSource = stock;
                        gvStock.DataBind();
                        // Partial reversal would leave stock and invoice inconsistent, which is worse
                        // than not reversing at all — so nothing is changed.
                        ShowMessage("Rollback aborted: DC stock is short for the batches marked SHORT/MISSING. Nothing was changed.", false);
                        return;
                    }

                    Execute(connection, transaction, CreditedCte + @"
                        UPDATE s SET s.StockQty = s.StockQty - c.Qty
                        FROM dbo.tblDCStore s JOIN credited c ON c.DCStoreId = s.DCStoreId", invoiceId);

                    Execute(connection, transaction, @"
                        UPDATE dbo.tblInvoiceDetail
                        SET PaymentQuantity = NULL, PaymentBonusQuantity = NULL, PaymentTotalQuantity = NULL,
                            PaymentTotalPrice = NULL, PaymentTotalPriceVatAmount = NULL,
                            PaymentDiscountPercentage = NULL, PaymentDiscountAmount = NULL,
                            PaymentNetAmount = NULL, PaymentStatus = NULL, PaymentReturnReason = NULL
                        WHERE InvoiceId = @InvoiceId", invoiceId);

                    Execute(connection, transaction, @"
                        UPDATE dbo.tblInvoice
                        SET PaymentTpTotal = NULL, PaymentTpDiscount = NULL, PaymentTpVat = NULL,
                            PaymentTpGrandTotal = NULL, PaymentInvoiceStatus = NULL, PaymentInvoiceNo = NULL,
                            PaymentBy = NULL, PaymentDate = NULL
                        WHERE InvoiceId = @InvoiceId", invoiceId);

                    // Back to 'Pending' — this is what puts the invoice back on the DA approval list.
                    // Only the latest log row, the same one the submit approved (see
                    // GetSalesReturnAppLogIdByInvoiceId): an invoice can carry several log rows and
                    // the older ones must keep whatever status they already have.
                    Execute(connection, transaction, @"
                        UPDATE dbo.tblSalesReturn_appLog
                        SET DICApprovalStatus = 'Pending', DICApproveDate = NULL, DICApproveBy = NULL
                        WHERE SalesReturnAppLogId = (SELECT MAX(SalesReturnAppLogId)
                                                     FROM dbo.tblSalesReturn_appLog
                                                     WHERE InvoiceId = @InvoiceId)", invoiceId);

                    transaction.Commit();
                    committed = true;
                }
                catch (Exception)
                {
                    if (!committed)
                    {
                        try { transaction.Rollback(); } catch { /* connection/transaction may already be dead */ }
                    }
                    throw;
                }

                ShowSummary(connection, Query(connection, null, HeaderQuery, invoiceId), invoiceId);
                gvStock.DataSource = null;
                gvStock.DataBind();
            }

            btnRollback.Visible = false;
            hfInvoiceId.Value = "";
            ShowMessage("Rolled back successfully. The invoice is back on the DA sales return list.", true);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Trace.TraceError("Sales return rollback failed for InvoiceId={0}: {1}", invoiceId, ex);
            ShowMessage("Rollback failed, nothing was changed: " + ex.Message, false);
        }
    }

    private static int FindInvoiceId(SqlConnection connection, string invoiceNo)
    {
        // DelivaryInvoiceNo / PaymentInvoiceNo are just 'DEL-' / 'RTN-' + InvoiceNo, and only
        // InvoiceNo is indexed (UQ_tblIssnvoice_InvoiceNo) — so strip the prefix and seek.
        // Matching all three columns with OR instead scans the whole table and times out.
        string core = invoiceNo;
        if (core.StartsWith("DEL-", StringComparison.OrdinalIgnoreCase) ||
            core.StartsWith("RTN-", StringComparison.OrdinalIgnoreCase))
        {
            core = core.Substring(4);
        }

        int invoiceId = SelectInvoiceId(connection,
            "SELECT TOP 1 InvoiceId FROM dbo.tblInvoice WHERE InvoiceNo = @InvoiceNo ORDER BY InvoiceId DESC",
            core, 0);
        if (invoiceId != 0)
        {
            return invoiceId;
        }

        // A few dozen legacy rows don't follow that prefix convention. Neither column is indexed,
        // so this fallback is a table scan — only reached when the seek above finds nothing.
        return SelectInvoiceId(connection, @"
            SELECT TOP 1 InvoiceId FROM dbo.tblInvoice
            WHERE DelivaryInvoiceNo = @InvoiceNo OR PaymentInvoiceNo = @InvoiceNo
            ORDER BY InvoiceId DESC", invoiceNo, 300);
    }

    private static int SelectInvoiceId(SqlConnection connection, string sql, string invoiceNo, int timeoutSeconds)
    {
        using (SqlCommand command = new SqlCommand(sql, connection))
        {
            // InvoiceNo is varchar(50): AddWithValue would send nvarchar, and the implicit
            // conversion turns the index seek into a full table scan.
            command.Parameters.Add("@InvoiceNo", SqlDbType.VarChar, 50).Value = invoiceNo;
            if (timeoutSeconds > 0)
            {
                command.CommandTimeout = timeoutSeconds;
            }
            object result = command.ExecuteScalar();
            return result == null || result == DBNull.Value ? 0 : Convert.ToInt32(result);
        }
    }

    private static DataTable Query(SqlConnection connection, SqlTransaction transaction, string sql, int invoiceId)
    {
        DataTable table = new DataTable();
        using (SqlCommand command = new SqlCommand(sql, connection, transaction))
        {
            command.Parameters.AddWithValue("@InvoiceId", invoiceId);
            using (SqlDataReader reader = command.ExecuteReader())
            {
                table.Load(reader);
            }
        }
        return table;
    }

    private static void Execute(SqlConnection connection, SqlTransaction transaction, string sql, int invoiceId)
    {
        using (SqlCommand command = new SqlCommand(sql, connection, transaction))
        {
            command.Parameters.AddWithValue("@InvoiceId", invoiceId);
            command.ExecuteNonQuery();
        }
    }

    private static int CountBadStock(DataTable stock)
    {
        int count = 0;
        foreach (DataRow row in stock.Rows)
        {
            if (row["StockStatus"].ToString() != "OK")
            {
                count++;
            }
        }
        return count;
    }

    /// <summary>What came back, from which batch, when, and where that stock stands right now.</summary>
    private void ShowSummary(SqlConnection connection, DataTable header, int invoiceId)
    {
        if (header.Rows.Count > 0)
        {
            DataRow row = header.Rows[0];
            lblInvoiceNo.Text = row["InvoiceNo"].ToString();
            lblCustomer.Text = row["CustomerName"] + " (" + row["CustomerCode"] + ")";
            lblReturnType.Text = row["ReturnType"].ToString();
            lblReturnedOn.Text = FormatDate(row["ReturnedOn"]);
            lblApproval.Text = row["DICApprovalStatus"].ToString();
            if (row["DICApproveDate"] != DBNull.Value)
            {
                lblApproval.Text += " (" + FormatDate(row["DICApproveDate"]) + ")";
            }
        }

        DataTable summary = Query(connection, null, SummaryQuery, invoiceId);
        gvSummary.DataSource = summary;
        gvSummary.DataBind();

        decimal totalQty = 0;
        decimal totalValue = 0;
        foreach (DataRow line in summary.Rows)
        {
            totalQty += Convert.ToDecimal(line["ReturnedQty"]);
            totalValue += Convert.ToDecimal(line["ReturnValue"]);
        }
        lblTotals.Text = string.Format("Total returned: {0:n0} item(s) in {1} line(s), value {2:n2}",
            totalQty, summary.Rows.Count, totalValue);
    }

    private static string FormatDate(object value)
    {
        return value == DBNull.Value ? "" : Convert.ToDateTime(value).ToString("dd-MMM-yyyy hh:mm tt");
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        lblMessage.Text = message;
        lblMessage.CssClass = "d-block mb-3 alert " + (isSuccess ? "alert-success" : "alert-danger");
    }
}
