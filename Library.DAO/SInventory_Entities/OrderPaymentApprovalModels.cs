using System;

namespace Library.DAO.SInventory_Entities
{
    /// <summary>
    /// Status vocabulary of the shared approval framework (tblCustomerApprovalLog and
    /// friends). Order Payment Approval uses the same words, written to
    /// tblOrderPaymentApprovalLog.Status by the stored procedures - never by C#.
    ///
    /// Posted   -> "Go for Approval" opened a round, waiting on the first configured role
    /// Verified -> an intermediate approver said yes, waiting on the next configured role
    /// Accepted -> the last role in the configured chain said yes; the invoice is allowed
    /// Rejected -> someone said no; the round is closed and the order can be resubmitted
    /// </summary>
    public static class OrderPaymentApprovalStatus
    {
        public const string Posted = "Posted";
        public const string Verified = "Verified";
        public const string Accepted = "Accepted";
        public const string Rejected = "Rejected";

        /// <summary>True while the request is still moving through the chain.</summary>
        public static bool IsLive(string status)
        {
            return String.Equals(status, Posted, StringComparison.OrdinalIgnoreCase)
                || String.Equals(status, Verified, StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>What to show a user who is looking at an order, not at the approval page.</summary>
        public static string GetName(string status, string waitingForRole)
        {
            if (String.IsNullOrEmpty(status))
            {
                return String.Empty;
            }
            if (String.Equals(status, Accepted, StringComparison.OrdinalIgnoreCase))
            {
                return "Payment Approved";
            }
            if (String.Equals(status, Rejected, StringComparison.OrdinalIgnoreCase))
            {
                return "Payment Approval Rejected";
            }
            return String.IsNullOrEmpty(waitingForRole)
                ? "Waiting for approval"
                : "Waiting for " + waitingForRole;
        }
    }

    /// <summary>One instalment of the payment commitment attached to a request.</summary>
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
        public string Status { get; set; }
    }
}
