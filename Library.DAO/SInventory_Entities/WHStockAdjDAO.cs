using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class WHStockAdjDAO
    {
        public int WHStockAdjId { get; set; }
        public string TransactionNo { get; set; }
        public DateTime TransactionDate { get; set; }
        public int AdjustmentType   { get; set; }
        public string StockEffect { get; set; }
        public int FromStore { get; set; }
        public int toStore { get; set; }
        public string Remarks { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public string ApproveBy { get; set; }
        public DateTime ApproveDate { get; set; }
        public string ActionStatus { get; set; }

        
    }
}
