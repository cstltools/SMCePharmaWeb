using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

namespace Library.DAL.SInventory_DAL
{
    /// <summary>
    /// Data access for the Order Payment Approval workflow.
    /// Every rule that matters (authorization, state transition, payment-schedule
    /// validation) is enforced inside the stored procedures - this class only marshals
    /// parameters and surfaces the proc's RAISERROR text, which arrives as SQL error 50000.
    /// </summary>
    public class OrderPaymentApprovalRepository
    {
        private DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

        /// <summary>"Go for Approval". Returns null on success, otherwise the message to show.</summary>
        public string Request(int orderId, int actionUserId, string remarks, out int newId)
        {
            newId = 0;
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderId", orderId),
                    new SqlParameter("@ActionUserId", actionUserId),
                    new SqlParameter("@Remarks", (object)remarks ?? DBNull.Value)
                };

                using (DataTable dt = accessManager.GetDataTable("sp_OrderPaymentApproval_Request", parameters))
                {
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        newId = Convert.ToInt32(dt.Rows[0]["OrderPaymentApprovalId"]);
                    }
                }
                return null;
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 50000)
                {
                    return sqlEx.Message;
                }
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>Approve / Reject / Cancel. Returns null on success, otherwise the message to show.</summary>
        public string Act(OrderPaymentApprovalActionRequest request)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderPaymentApprovalId", request.OrderPaymentApprovalId),
                    new SqlParameter("@ActionUserId", request.ActionUserId),
                    new SqlParameter("@Action", request.Action),
                    new SqlParameter("@Remarks", (object)request.Remarks ?? DBNull.Value),
                    new SqlParameter("@ScheduleXml", (object)BuildScheduleXml(request.Schedule) ?? DBNull.Value)
                };

                using (DataTable dt = accessManager.GetDataTable("sp_OrderPaymentApproval_Act", parameters))
                {
                    // Result set is informational; the proc raises on every failure path.
                }
                return null;
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 50000)
                {
                    return sqlEx.Message;
                }
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetList(int actionUserId, int statusFilter, DateTime? fromDate, DateTime? toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@ActionUserId", actionUserId),
                    new SqlParameter("@StatusFilter", statusFilter),
                    new SqlParameter("@FromDate", fromDate.HasValue ? (object)fromDate.Value.Date : DBNull.Value),
                    new SqlParameter("@ToDate", toDate.HasValue ? (object)toDate.Value.Date : DBNull.Value)
                };

                return accessManager.GetDataTable("sp_OrderPaymentApproval_GetList", parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>Header (table 0), schedule (table 1) and history (table 2) for one request.</summary>
        public DataSet GetDetail(int orderPaymentApprovalId, int actionUserId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderPaymentApprovalId", orderPaymentApprovalId),
                    new SqlParameter("@ActionUserId", actionUserId)
                };

                return accessManager.GetDataSet("sp_OrderPaymentApproval_GetDetail", parameters);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 50000)
                {
                    return null;   // not authorized for this id - caller shows a generic message
                }
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>
        /// The authoritative invoice-creation gate. Re-evaluates credit validation and the
        /// approval status server-side; never trust a button's enabled state for this.
        /// </summary>
        public InvoiceCreationGate CanCreateInvoice(int orderId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderId", orderId)
                };

                using (DataTable dt = accessManager.GetDataTable("sp_OrderPaymentApproval_CanCreateInvoice", parameters))
                {
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        return new InvoiceCreationGate
                        {
                            CanCreate = false,
                            Reason = "Order could not be validated.",
                            ApprovalStatus = OrderPaymentApprovalStatus.NoRequest
                        };
                    }

                    DataRow row = dt.Rows[0];
                    return new InvoiceCreationGate
                    {
                        CanCreate = Convert.ToBoolean(row["CanCreate"]),
                        Reason = Convert.ToString(row["Reason"]),
                        ApprovalStatus = Convert.ToInt32(row["ApprovalStatus"])
                    };
                }
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>
        /// &lt;Schedule&gt;&lt;Row Date="yyyy-MM-dd" Amount="0.00"/&gt;...&lt;/Schedule&gt;
        /// Invariant culture on both values so a client locale can never shift a date or a
        /// decimal separator on the way into the proc.
        /// </summary>
        private static string BuildScheduleXml(List<PaymentScheduleRow> schedule)
        {
            if (schedule == null || schedule.Count == 0)
            {
                return null;
            }

            StringBuilder sb = new StringBuilder("<Schedule>");
            foreach (PaymentScheduleRow row in schedule)
            {
                sb.Append("<Row Date=\"")
                  .Append(row.PaymentDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture))
                  .Append("\" Amount=\"")
                  .Append(row.PaymentAmount.ToString("0.00", CultureInfo.InvariantCulture))
                  .Append("\" />");
            }
            sb.Append("</Schedule>");
            return sb.ToString();
        }
    }
}
