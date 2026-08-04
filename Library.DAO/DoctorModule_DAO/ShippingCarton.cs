using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ShippingCarton
    {
        public int ShippingCartonSizeId { get; set; }

        public string ShippingCartonSizeName { get; set; }

        public string ShippingCartonCode { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? ActiveInactiveDate { get; set; }
    }
}