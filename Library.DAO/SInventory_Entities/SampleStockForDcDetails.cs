using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class SampleStockForDcDetails
    {

        public int SampleStockForDcDetailsId { get; set; }
        public int SampleStockForDcMasterId { get; set; }
        public int DCStoreId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string BatchNo { get; set; }
        public DateTime ReceiveDate { get; set; }
        public DateTime ExpDate { get; set; }
        public int SampleStock { get; set; }
  
    }
}
