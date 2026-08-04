using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class SampleStockForWHDetails
    {
        public int SampleStockForWHDetailsId { get; set; }
        public int SampleStockForWHMasterId { get; set; }
        public int ReceiveId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string BatchNo { get; set; }
        public DateTime ReceiveDate { get; set; }
        public DateTime ExpDate { get; set; }
        public int SampleStock { get; set; }
    }
}
