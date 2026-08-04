using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SubDepot_DAO
{
   public class SubdepotStockOutDetailsDao
    {

       public int SubDcStockOutDetailsId { get; set; }
        public int SubDcStockOutMasterId { get; set; }
        public int SubDCStoreId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime ReceiveDate { get; set; }
        public int StockOutQty { get; set; }
    }

}
