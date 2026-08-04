using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SubDepot_DAO
{
    public class SubDepoAdjustDetailDAO
    {
        public int SubDepoStockOutDetId { get; set; }
        public int SubDCStoreId { get; set; }
        public int SubDepoStockOutId { get; set; }
        public decimal Quantity { get; set; }
    }
}
