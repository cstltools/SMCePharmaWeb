using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class DCStockNew
    {
        public int DCStoreId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public decimal TotalQuantity { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime ReceiveDate { get; set; }
        public string ChalanNo { get; set; }
        public DateTime ChalanDate { get; set; }
        public int ComUnitId { get; set; }
        public string StorageLocation { get; set; }
        public decimal StockQty { get; set; }
        public decimal DamageQty { get; set; }
        public DateTime StockRcvDate { get; set; }
        public int? ReqId { get; set; }
        public int? ReqChildId { get; set; }
        public int? ChalanId { get; set; }
        public int? StockInTransfarId { get; set; }
        public int InvoiceDetailId { get; set; }
        public int DCStoreFreezeId { get; set; }
        public int? ChalanDetailsId { get; set; }
        public DateTime? mfgdate { get; set; }
        public int SubDCStoreId { get; set; }
    }
}
