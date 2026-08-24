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
    /// Data access for Order Payment Approval (MenuId 383 of the shared approval
    /// framework - see deploy_order_payment_approval.sql).
    ///
    /// Nothing about the approval chain lives here. Which role approves at which step is
    /// configured on UserPermission/ApprovalStepMap.aspx and read by the procs. This class
    /// marshals parameters and surfaces the proc's RAISERROR text, which arrives as SQL
    /// error 50000 and is already worded for the user.
    /// </summary>
    public class OrderPaymentApprovalRepository
    {
        private DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

        /// <summary>
        /// "Go for Approval": opens a round with its payment commitment.
        /// Returns null on success, otherwise the message to show the user.
        /// </summary>
        public string Post(int orderId, int actionUserId, List<PaymentScheduleRow> schedule, string comments)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderId", orderId),
                    new SqlParameter("@ActionUserId", actionUserId),
                    new SqlParameter("@ScheduleXml", (object)BuildScheduleXml(schedule) ?? DBNull.Value),
                    new SqlParameter("@Comments", (object)comments ?? DBNull.Value)
                };

                using (DataTable dt = accessManager.GetDataTable("sp_Post_OrderPaymentApp", parameters))
                {
                    // result set is informational; every failure path raises
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

        /// <summary>
        /// Approve / Reject. The caller supplies an action, never a status and never a
        /// role: sp_Save_OrderPaymentAppLog resolves the acting role and market scope from
        /// the database using the session UserId and refuses anything that does not line up.
        /// Returns null on success, otherwise the message to show the user.
        /// </summary>
        public string Save(int orderId, int actionUserId, string action, string comments)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderId", orderId),
                    new SqlParameter("@ActionUserId", actionUserId),
                    new SqlParameter("@Action", action),
                    new SqlParameter("@Comments", (object)comments ?? DBNull.Value)
                };

                using (DataTable dt = accessManager.GetDataTable("sp_Save_OrderPaymentAppLog", parameters))
                {
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

        /// <summary>
        /// Approver worklist. Row scope is derived inside the proc from actionUserId; the
        /// market ids below are optional narrowing filters and can never widen it.
        /// </summary>
        public DataTable GetList(int actionUserId, string status, DateTime? fromDate, DateTime? toDate,
                                 int? groupId, int? regionId, int? areaId, int? territoryId, int? orderId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@ActionUserId", actionUserId),
                    new SqlParameter("@Status", (object)status ?? DBNull.Value),
                    new SqlParameter("@FromDt", fromDate.HasValue ? (object)fromDate.Value.Date : DBNull.Value),
                    new SqlParameter("@ToDt", toDate.HasValue ? (object)toDate.Value.Date : DBNull.Value),
                    new SqlParameter("@GroupId", groupId.HasValue ? (object)groupId.Value : DBNull.Value),
                    new SqlParameter("@RegionId", regionId.HasValue ? (object)regionId.Value : DBNull.Value),
                    new SqlParameter("@AreaId", areaId.HasValue ? (object)areaId.Value : DBNull.Value),
                    new SqlParameter("@TerritoryId", territoryId.HasValue ? (object)territoryId.Value : DBNull.Value),
                    new SqlParameter("@OrderId", orderId.HasValue ? (object)orderId.Value : DBNull.Value)
                };

                return accessManager.GetDataTable("sp_Get_OrderPaymentApp", parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>The instalment plan of one round. planVersion null = the latest plan.</summary>
        public DataTable GetSchedule(int orderId, int? planVersion)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderId", orderId),
                    new SqlParameter("@PlanVersion", planVersion.HasValue ? (object)planVersion.Value : DBNull.Value)
                };

                return accessManager.GetDataTable("sp_Get_OrderPaymentSchedule", parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>Every action ever taken on one order, oldest first.</summary>
        public DataTable GetHistory(int orderId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@OrderId", orderId)
                };

                return accessManager.GetDataTable("sp_Get_OrderPaymentAppHistory", parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// <summary>
        /// The authoritative invoice-creation gate. Re-evaluates credit validation and the
        /// approval state server-side; never trust a button's enabled state for this.
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
                            Status = null
                        };
                    }

                    DataRow row = dt.Rows[0];
                    return new InvoiceCreationGate
                    {
                        CanCreate = Convert.ToBoolean(row["CanCreate"]),
                        Reason = row["Reason"] == DBNull.Value ? null : Convert.ToString(row["Reason"]),
                        Status = row["Status"] == DBNull.Value ? null : Convert.ToString(row["Status"])
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
