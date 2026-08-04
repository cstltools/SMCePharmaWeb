using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class SubMarket
    {
        public int SMId { get; set; }

        public string SMCode { get; set; }

        public string SMName { get; set; }

        public int ZoneId { get; set; }
        public int AreaId { get; set; }
        public int TerritoryId { get; set; }
        public int MarketId { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? AcOrInAcDate { get; set; }

        public string CreatedBy { get; set; }

        public DateTime? CreatedDate { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime? UpdatedDate { get; set; }

        public string Remarks { get; set; }
    }
}