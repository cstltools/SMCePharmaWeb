using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class SampleStockForDcMaster
    {

       public int SampleStockForDcMasterId { get; set; }
       public string SampleStockForDcMasterCode { get; set; }
       public int ComUnitId { get; set; }
       public string Action { get; set; }
       public DateTime Date { get; set; }
       public string EntryBy { get; set; }
       public DateTime EntryDate { get; set; }
       public string Status { get; set; }
       public string ApprovedBy { get; set; }
       public DateTime ApprovedDate { get; set; }
    }
}
