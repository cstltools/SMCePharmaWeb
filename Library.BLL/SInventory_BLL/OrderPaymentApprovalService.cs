using System;
using System.Collections.Generic;
using System.Data;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    /// <summary>
    /// Order Payment Approval workflow:
    ///   credit-blocked order -> Go for Approval -> AM (+ payment schedule) -> DZSM -> NSM
    ///   -> invoice creation allowed.
    ///
    /// Every method returns "Success" or a message that is safe to show the user, matching
    /// the inline-validation style of MasterSetup_BLL/CustomerInvoiceLimitService.
    ///
    /// Authorization, state-transition and payment-schedule rules are NOT re-implemented
    /// here: they live in the stored procedures so that they hold for every caller,
    /// including the .asmx/.ashx endpoints and anything added later. The guards below are
    /// argument sanity checks only.
    /// </summary>
    public class OrderPaymentApprovalService
    {
        private OrderPaymentApprovalRepository repository = new OrderPaymentApprovalRepository();

        public const string Success = "Success";

        public string Request(int orderId, int actionUserId, string remarks, out int orderPaymentApprovalId)
        {
            orderPaymentApprovalId = 0;

            if (orderId <= 0)
            {
                return "Invalid order.";
            }
            if (actionUserId <= 0)
            {
                return "Your session has expired. Please log in again.";
            }

            string error = repository.Request(orderId, actionUserId, remarks, out orderPaymentApprovalId);
            return String.IsNullOrEmpty(error) ? Success : error;
        }

        public string Approve(int orderPaymentApprovalId, int actionUserId, string remarks,
                              List<PaymentScheduleRow> schedule)
        {
            return Act(orderPaymentApprovalId, actionUserId, "Approve", remarks, schedule);
        }

        public string Reject(int orderPaymentApprovalId, int actionUserId, string remarks)
        {
            if (String.IsNullOrEmpty(remarks) || remarks.Trim().Length == 0)
            {
                return "Rejection reason is required.";
            }
            return Act(orderPaymentApprovalId, actionUserId, "Reject", remarks, null);
        }

        public string Cancel(int orderPaymentApprovalId, int actionUserId, string remarks)
        {
            return Act(orderPaymentApprovalId, actionUserId, "Cancel", remarks, null);
        }

        private string Act(int orderPaymentApprovalId, int actionUserId, string action, string remarks,
                           List<PaymentScheduleRow> schedule)
        {
            if (orderPaymentApprovalId <= 0)
            {
                return "Invalid approval request.";
            }
            if (actionUserId <= 0)
            {
                return "Your session has expired. Please log in again.";
            }

            string error = repository.Act(new OrderPaymentApprovalActionRequest
            {
                OrderPaymentApprovalId = orderPaymentApprovalId,
                ActionUserId = actionUserId,
                Action = action,
                Remarks = remarks,
                Schedule = schedule
            });

            return String.IsNullOrEmpty(error) ? Success : error;
        }

        public DataTable GetList(int actionUserId, int statusFilter, DateTime? fromDate, DateTime? toDate)
        {
            if (actionUserId <= 0)
            {
                return new DataTable();
            }
            return repository.GetList(actionUserId, statusFilter, fromDate, toDate);
        }

        public DataSet GetDetail(int orderPaymentApprovalId, int actionUserId)
        {
            if (orderPaymentApprovalId <= 0 || actionUserId <= 0)
            {
                return null;
            }
            return repository.GetDetail(orderPaymentApprovalId, actionUserId);
        }

        /// <summary>
        /// Server-side gate for "may this order become an invoice right now?".
        /// Call it before every navigation into invoice creation - the grid's button state
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
                    ApprovalStatus = OrderPaymentApprovalStatus.NoRequest
                };
            }
            return repository.CanCreateInvoice(orderId);
        }
    }
}
