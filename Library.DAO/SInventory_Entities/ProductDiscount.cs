using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class ProductDiscount
    {
        public int DiscountId { get; set; }
        public string ProductCode { get; set; }
        public int CustomerMasterId { get; set; }
        public decimal DiscountPercentage { get; set; }
        public string Status { get; set; }
        public DateTime ActiveDate { get; set; }
        public DateTime InactiveDate { get; set; }
    }
}
