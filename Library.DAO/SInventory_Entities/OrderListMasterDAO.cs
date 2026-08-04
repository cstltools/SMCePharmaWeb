using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class OrderListMasterDAO
    {
       public int OrderMasterID { get; set; }
       public int ManufacId { get; set; }
       public DateTime DocumentDate { get; set; }
        public bool GenerateOrder { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
    }
}
