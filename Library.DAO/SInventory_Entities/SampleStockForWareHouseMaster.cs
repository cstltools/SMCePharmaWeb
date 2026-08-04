using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public  class SampleStockForWareHouseMaster
    {
        public int SampleStockForWareHouseMstId { get; set; }
        public string SampleStockForWareHouseMstCode { get; set; }
        public int WareHouseId { get; set; }
        public string Action { get; set; }
        public DateTime Date { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string Status { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime ApprovedDate { get; set; }
    }
}
