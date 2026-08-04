using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class WhStoreFreezeDao
    {
        public int WhStoreFreezeId { get; set; }
        public int ReceiveId { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public decimal TotalQuantity { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime ReceiveDate { get; set; }
        public decimal StockQty { get; set; }
        public decimal DamageQty { get; set; }
        public DateTime StockRcvDate { get; set; }
        public string StockCondition { get; set; }
        public int WhStockConditionFreezeID { get; set; }
        public string Remarks { get; set; }
    }
}
