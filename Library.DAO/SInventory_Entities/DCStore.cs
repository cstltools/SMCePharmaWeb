using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class DCStore
    {
        public int StockId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public decimal Quantity { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime ReceiveDate { get; set; }
        public string ChalanNo { get; set; }
        public DateTime ChalanDate { get; set; }
        public int ComUnitId { get; set; }
        public string StorageLocation { get; set; }

    }
}
