using System;
using System.Collections.Generic;
using System.Data;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    /// <summary>
    /// Order Payment Approval - MenuId 383 of the shared approval framework.
    ///
    ///   credit-blocked order
    ///     -> "Go for Approval" (+ instalment plan)   [Posted]
    ///     -> each role in the chain configured on UserPermission/ApprovalStepMap.aspx
    ///                                                [Verified ... Verified]
    ///     -> last configured role                    [Accepted] -> invoice allowed
    ///
    /// No role and no step count appears anywhere in this class. Changing the chain is a
    /// configuration change on ApprovalStepMap.aspx, not a code change.
    ///
    /// Every method returns "Success" or a message safe to show the user, matching the
    /// inline-validation style of MasterSetup_BLL/CustomerInvoiceLimitService.
    ///
    /// Authorization, state transition and schedule validation are NOT re-implemented
    /// here: they live in the stored procedures so they hold for every caller, including
    /// the .asmx/.ashx endpoints. The guards below are argument sanity checks only.
    /// </summary>
    public class OrderPaymentApprovalService
    {
        private OrderPaymentApprovalRepository repository = new OrderPaymentApprovalRepository();

        public const string Success = "Success";

        /// <summary>"Go for Approval" with the payment commitment the customer has agreed to.</summary>
        public string Post(int orderId, int actionUserId, List<PaymentScheduleRow> schedule, string comments)
        {
            if (orderId <= 0)
            {
                return "Invalid order.";
            }
            if (actionUserId <= 0)
            {
                return "Your session has expired. Please log in again.";
            }
            if (schedule == null || schedule.Count == 0)
            {
                return "Add at least one instalment before sending for approval.";
            }

            string error = repository.Post(orderId, actionUserId, schedule, comments);
            return String.IsNullOrEmpty(error) ? Success : error;
        }

        public string Approve(int orderId, int actionUserId, string comments)
        {
            return Save(orderId, actionUserId, "Approve", comments);
        }

        public string Reject(int orderId, int actionUserId, string comments)
        {
            if (String.IsNullOrEmpty(comments) || comments.Trim().Length == 0)
            {
                return "A reason is required when rejecting.";
            }
            return Save(orderId, actionUserId, "Reject", comments);
        }

        private string Save(int orderId, int actionUserId, string action, string comments)
        {
            if (orderId <= 0)
            {
                return "Invalid order.";
            }
            if (actionUserId <= 0)
            {
                return "Your session has expired. Please log in again.";
            }

            string error = repository.Save(orderId, actionUserId, action, comments);
            return String.IsNullOrEmpty(error) ? Success : error;
        }

        public DataTable GetList(int actionUserId, string status, DateTime? fromDate, DateTime? toDate,
                                 int? groupId, int? regionId, int? areaId, int? territoryId, int? orderId)
        {
            if (actionUserId <= 0)
            {
                return new DataTable();
            }
            return repository.GetList(actionUserId, status, fromDate, toDate,
                                      groupId, regionId, areaId, territoryId, orderId);
        }

        public DataTable GetSchedule(int orderId, int? planVersion)
        {
            if (orderId <= 0)
            {
                return new DataTable();
            }
            return repository.GetSchedule(orderId, planVersion);
        }

        public DataTable GetHistory(int orderId)
        {
            if (orderId <= 0)
            {
                return new DataTable();
            }
            return repository.GetHistory(orderId);
        }

        /// <summary>
        /// Server-side gate for "may this order become an invoice right now?".
        /// Call it before every navigation into invoice creation - the grid button state
        /// is a hint for the user, not a security control.
        /// </summary>
        public InvoiceCreationGate CanCreateInvoice(int orderId)
        {
            if (orderId <= 0)
            {
                return new InvoiceCreationGate
                {
                    CanCreate = false,
                    Reason = "Invalid order.",
                    Status = null
                };
            }
            return repository.CanCreateInvoice(orderId);
        }
    }
}
