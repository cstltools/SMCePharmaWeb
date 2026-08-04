using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class SupplierInformation
    {

        public int SupplierId { get; set; }
        public string CompanyCode { get; set; }
        public string SupplierName { get; set; }
        public string Address { get; set; }
        public string ContactNo { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
    }
}
