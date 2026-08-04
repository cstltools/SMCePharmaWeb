using System;

namespace SalesSolution.Web.Models
{
    public class Zone
    {
        public int RegionId { get; set; }

        public int? GroupId { get; set; }

        public string RegionName { get; set; }

        public string RegionCode { get; set; }
        public string CodeStr { get; set; }


        public string RgnShortName { get; set; }

        public string Description { get; set; }

        public string Remarks { get; set; }

        public DateTime? AcOrInAcDate { get; set; }

        public bool? IsActive { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ActiveOrInactiveBy { get; set; }


        public string DivisionId { get; set; }
    }
}