using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class StockConditionFreezeDAO
    {
        public int StockConditionFreezeID { get; set; }
        public int ReceiveId { get; set; }
        public int DCStoreId { get; set; }
        public int ManufacId { get; set; }
        public decimal FreezeQty { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
    }
}
