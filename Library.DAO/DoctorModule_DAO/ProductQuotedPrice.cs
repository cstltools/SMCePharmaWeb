using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ProductQuotedPrice
    {
        public int QuotedPriceId { get; set; }

        public int? ProductId { get; set; }

        public int? CustomerMasterId { get; set; }

        public decimal? QuotedPrice { get; set; }

        public string Status { get; set; }

        public DateTime? ActiveDate { get; set; }

        public DateTime? InactiveDate { get; set; }

        public bool? IsActive { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string ApprovedBy { get; set; }

        public DateTime? ApprovedDate { get; set; }

        public string ActionStatus { get; set; }
    }
}