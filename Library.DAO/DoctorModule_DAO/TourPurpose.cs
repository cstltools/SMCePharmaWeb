using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class TourPurpose
    {
        public int TPId { get; set; }

        public string TPName { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }
        public decimal? MIOAmount { get; set; }
        public decimal? AMAmount { get; set; }
        public decimal? DZSMAmount { get; set; }

        public int? IsMarketVisit { get; set; }
        public int? IsOtherVisit { get; set; }
    }
}