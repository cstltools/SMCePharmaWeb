using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class DepotWiseAreaDao
    {
        //public int DcId { get; set; }
        public List<DcList> DepotList { get; set; }
    }


    public class DcList
    {
        public int DcWiseAreaId { get; set; }
        public int CompanyId { get; set; }
        public int DepotId { get; set; }
        public int AreaId { get; set; }
        public bool IsActive { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
    }
}