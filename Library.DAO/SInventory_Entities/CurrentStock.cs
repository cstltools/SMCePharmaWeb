using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CurrentStock
    {
        public int StockId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public decimal Quantity { get; set; }
        public string ComUnitId { get; set; }
        public string StorageLocation { get; set; }
    }
}
