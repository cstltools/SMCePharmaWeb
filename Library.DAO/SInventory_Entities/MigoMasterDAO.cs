using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class MigoMasterDAO
    {
        public int MigoMasterID { get; set; }
        public string MogoCode { get; set; }
        public int ManufacId { get; set; }
        public DateTime MogoDocumentDate { get; set; }
        public bool StockUpload { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
    }
}
