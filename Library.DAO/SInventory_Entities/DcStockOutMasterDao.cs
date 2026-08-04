using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class DcStockOutMasterDao
    {
       public int DcStockOutMasterId { get; set; }
       public int ComUnitId { get; set; }
       public int InvoiceId { get; set; }
       public DateTime StockOutDate { get; set; }
       public string Reason { get; set; }
       public string EntryBy { get; set; }
       public DateTime EntryDate { get; set; }
       public string Status { get; set; }
       public string ApprovedBy { get; set; }
       public DateTime ApprovedDate { get; set; }

       public string CustomerCode { get; set; }
    }
}
