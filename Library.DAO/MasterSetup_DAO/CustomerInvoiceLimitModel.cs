using System;

namespace Library.DAO.MasterSetup_DAO
{
    public class CustomerInvoiceLimitModel
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public decimal MaximumInvoiceValue { get; set; }
        public string Remarks { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }

    public class InvoiceNotBindingModel
    {
        public int InvoiceNotBindingId { get; set; }
        public string ApplyType { get; set; } // "Customer" or "CustomerType"
        public int CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public int CustomerTypeId { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime? ActiveToDate { get; set; }
        public int AllowedNoOfInvoice { get; set; }
        public decimal AllowedCreditLimit { get; set; }
        public int NumberOfDaysInTransit { get; set; }
        public string Remarks { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
