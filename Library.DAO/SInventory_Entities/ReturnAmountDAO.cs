using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class ReturnAmountDAO
    {
        public int CustomerId { get; set; }
        public int InvoiceId { get; set; }
        public int ReturnInvoiceId { get; set; }
        public decimal Amount { get; set; }
       

    }
}
