using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SubDepot_DAO
{
  public class SubdepotStockOutMasterDao
    {
        public int SubDcStockOutMasterId { get; set; }
        public string SubDcStockOutMasterCode { get; set; }
        public int ComUnitId { get; set; }
        public int InvoiceId { get; set; }
        public DateTime StockOutDate { get; set; }
        public string Reason { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string Status { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime ApprovedDate { get; set; }
    }
}
