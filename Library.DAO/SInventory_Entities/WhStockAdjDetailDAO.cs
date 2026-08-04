using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class WhStockAdjDetailDAO
    {
        public int WHStockAdjDetailId { get; set; }
        public int WHStockAdjId { get; set; }
        public decimal Quantity { get; set; }
        public int ReceiveId { get; set; }

    }
}
