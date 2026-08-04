using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class WharehouseStockInDetailsDao
    {
        public Int32 WHStockInDetailID { get; set; }
        public Int32 WHStockInMasterID { get; set; }
        public Int32 ProductId { get; set; }
        public String Batch { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime MfgDate { get; set; }
        public Decimal Qty { get; set; }
        public Decimal Price { get; set; }
        public Decimal VAT { get; set; }
        public Decimal TotalAmount { get; set; }
        public Int32 WHStockOutDetailID { get; set; }
        public Int32 ReceiveId { get; set; }
    }
}
