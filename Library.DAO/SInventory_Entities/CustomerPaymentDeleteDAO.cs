using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CustomerPaymentDeleteDAO
    {
        public int? CustPayDeleteId { get; set; }
        public int? CustPayDetailId { get; set; }
        public int? InvoiceId { get; set; }
        public decimal? PaymentAmount { get; set; }
        public int? CustPayId { get; set; }
        public int? SubDeportInvoiceId { get; set; }
        public decimal? Discount { get; set; }
        public int? CashAccId { get; set; }
        public int? BankAccId { get; set; }
        public decimal? AIT { get; set; }
        public bool? IsPosting { get; set; }
        public int? TransctionDetailId { get; set; }
        public DateTime? CustPaymentDate { get; set; }
        public decimal? TPAmount { get; set; }
        public decimal? VATAmount { get; set; }
        public bool? FristRow { get; set; }
        public bool? SecondRow { get; set; }
        public bool? _42WorkingRow { get; set; }
        public string CollectionBy { get; set; }
        public int? DANameId { get; set; }
        public int? PreviousDANameId { get; set; }
        public int? TestIDnew { get; set; }
        public string PreCollDate { get; set; }
        public string Remarks { get; set; }
    }
}
