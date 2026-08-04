using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class ProductUnitPrice
    {
        public int UnitPriceId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public int ProductId { get; set; }
        public decimal CostPrice { get; set; }
        public decimal UnitPrice { get; set; }
        public bool IsActive { get; set; }
        public DateTime ActiveDate { get; set; }
        public DateTime InActiveDate { get; set; }
        public decimal VATPercentage { get; set; }
        public decimal VATAmountPerUnit { get; set; }
        public decimal MRPPrice { get; set; }
        public int UnitPriceUpdateId { get; set; }

       
    }
}
