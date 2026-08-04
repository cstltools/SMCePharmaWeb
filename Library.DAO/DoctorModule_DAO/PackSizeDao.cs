using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class PackSizeDao
    {
        public int PackSizeId { get; set; }

        public string PackSizeName { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? ActiveInactiveDate { get; set; }

        public string PackSizeCode { get; set; }
    }
}