using System;
using System.Collections.Generic;

namespace Library.DAO.SInventory_Entities
{
    /// <summary>
    /// Order Payment Approval status codes. Persisted values live in
    /// tblOrderPaymentApproval.ApprovalStatus; see deploy_order_payment_approval.sql.
    /// AMApproved (1) and DZSMApproved (3) are audit-only - an approver's single action
    /// writes both history rows and the header lands on the next Pending status.
    /// </summary>
    public static class OrderPaymentApprovalStatus
    {
        public const int NoRequest = -1;
        public const int PendingAM = 0;
        public const int AMApproved = 1;
        public const int PendingDZSM = 2;
        public const int DZSMApproved = 3;
        public const int PendingNSM = 4;
        public const int FullyApproved = 5;
        public const int Rejected = 6;
        public const int Cancelled = 7;

        public static string GetName(int status)
        {
            switch (status)
            {
                case PendingAM: return "Pending AM Approval";
                case AMApproved: return "AM Approved";
                case PendingDZSM: return "Pending DZSM Approval";
                case DZSMApproved: return "DZSM Approved";
                case PendingNSM: return "Pending NSM Approval";
                case FullyApproved: return "Fully Approved";
                case Rejected: return "Rejected";
                case Cancelled: return "Cancelled";
                default: return String.Empty;
            }
        }
    }

    /// <summary>Role type ids as configured in tblRoleType.</summary>
    public static class ApprovalRoleType
    {
        public const int AM = 2;
        public const int DZSM = 3;
        public const int NSM = 4;
        public const int Admin = 5;
    }

    public class OrderPaymentApprovalViewModel
    {
        public int OrderPaymentApprovalId { get; set; }
        public int OrderId { get; set; }
        public string OrderCode { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public string TerritoryName { get; set; }
        public decimal OrderGrossValue { get; set; }
        public decimal TotalDueAmount { get; set; }
        public decimal ScheduledAmount { get; set; }
        public decimal RemainingAmount { get; set; }
        public string BlockReason { get; set; }
        public int ApprovalStatus { get; set; }
        public string ApprovalStatusName { get; set; }
        public int PaymentPlanVersion { get; set; }
        public bool IsScheduleLocked { get; set; }
        public DateTime RequestedDate { get; set; }
        public string RequestedByName { get; set; }
        public bool CanAct { get; set; }
    }

    public class PaymentScheduleRow
    {
        public int PaymentNo { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal PaymentAmount { get; set; }
    }

    /// <summary>Outcome of dbo.sp_OrderPaymentApproval_CanCreateInvoice.</summary>
    public class InvoiceCreationGate
    {
        public bool CanCreate { get; set; }
        public string Reason { get; set; }
        public int ApprovalStatus { get; set; }
    }

    public class OrderPaymentApprovalActionRequest
    {
        public int OrderPaymentApprovalId { get; set; }
        public int ActionUserId { get; set; }
        public string Action { get; set; }
        public string Remarks { get; set; }
        public List<PaymentScheduleRow> Schedule { get; set; }
    }
}
