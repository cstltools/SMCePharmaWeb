using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class DCStoreFreezeDAO
    {
        public int DCStoreFreezeId { get; set; }
        public int DCStoreId { get; set; }
        public int InvoiceDetailId { get; set; }
        public string StorageLocation { get; set; }
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
        public decimal StockQty { get; set; }
        public decimal DamageQty { get; set; }
        public DateTime StockRcvDate { get; set; }
        public int ReqId { get; set; }
         public int SDStoreFreezeId { get; set; }
        public int ReqChildId { get; set; }
        public int StockInTransfarId { get; set; }
        public string StockCondition { get; set; }
        public int ReceiveId { get; set; }
        public int ChalanId { get; set; }
        public int StockConditionFreezeID { get; set; }
        public int? ChalanDetailsId { get; set; }
        public string remarks { get; set; }
    }
}
