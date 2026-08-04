using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class StationType
    {
        public int StationTypeId { get; set; }

        public string StationTypeName { get; set; }

        public string StationCode { get; set; }

        public bool? IsActive { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }

        public string StartTime { get; set; }


        public string EndTime { get; set; }
    }
}