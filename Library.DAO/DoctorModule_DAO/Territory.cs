using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class Territory
    {
        public int TerritoryId { get; set; }

        public string TerritoryName { get; set; }
        public string CodeStr { get; set; }

        public string TerritoryCode { get; set; }

        public int? ZoneId { get; set; }
        public int? AreaId { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? AcOrInAcDate { get; set; }

        public string CreatedBy { get; set; }

        public DateTime? CreatedDate { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime? UpdatedDate { get; set; }

        public string Remarks { get; set; }
        public string ThanaId { get; set; }


        // data passing 

        public int GroupId { get; set; }

    }
}