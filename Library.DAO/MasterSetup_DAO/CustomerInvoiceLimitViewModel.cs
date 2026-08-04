using System;

namespace Library.DAO.MasterSetup_DAO
{
    public class CustomerInvoiceLimitViewModel
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public string MobileNo { get; set; }
        public decimal MaximumInvoiceValue { get; set; }
        public string Remarks { get; set; }
        public bool IsActive { get; set; }
        public string Status { get { return IsActive ? "Active" : "Inactive"; } }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; } // Formatted string for UI
    }

    public class CustomerAutoCompleteViewModel
    {
        public int CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public string MobileNo { get; set; }
    }

    public class CustomerTypeViewModel
    {
        public int CustomerTypeId { get; set; }
        public string CustomerType { get; set; }
    }

    public class InvoiceNotBindingViewModel
    {
        public int InvoiceNotBindingId { get; set; }
        public string ApplyType { get; set; } // "Customer" or "CustomerType"
        public int CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public string MobileNo { get; set; }
        public int CustomerTypeId { get; set; }
        public string CustomerTypeName { get; set; }
        public string ActiveFromDate { get; set; }
        public string ActiveToDate { get; set; }
        public int AllowedNoOfInvoice { get; set; }
        public decimal AllowedCreditLimit { get; set; }
        public int NumberOfDaysInTransit { get; set; }
        public string Remarks { get; set; }
        public bool IsActive { get; set; }
        public string Status { get { return IsActive ? "Active" : "Inactive"; } }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
    }
}
