using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.Target_DAO
{
    public class ProductWiseTargetDAO
    {
        public int ProductSalesTargetId { get; set; }
        public int GroupId { get; set; }
        public int RegionId { get; set; }
        public int AreaId { get; set; }
        public int TerritoryId { get; set; }
        public int ProductId { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }


    }
}
