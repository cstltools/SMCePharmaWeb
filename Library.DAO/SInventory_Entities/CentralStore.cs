using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CentralStore
    {
        public int ReceiveId { get; set; }
        public string InternalNoteNo { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public decimal Quantity { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime ReceiveDate { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal StockInQty { get; set; }
        public decimal TotalAmount
        {
            get { return UnitPrice + StockInQty; }
            set
            {
                return;
            }
        }
        public int ComUnitId { get; set; }
        public string ComUnitCode { get; set; }
    }
}
