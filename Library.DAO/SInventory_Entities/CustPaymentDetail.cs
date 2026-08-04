using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CustPaymentDetail
    {
        public int CustPayDetailId { get; set; }
        public int InvoiceId { get; set; }
        public decimal PaymentAmount { get; set; }
        public decimal TPAmount { get; set; }
        public decimal VATAmount { get; set; }
        public int CustPayId { get; set; }
        public int DANameId { get; set; }
        public string CollectionBy { get; set; }
        public Boolean IsAdjust { get; set; }
    }
}
