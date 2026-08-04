using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ManufacturerDao
    {
        public int ManufacId { get; set; }

        public string ManufacName { get; set; }

        public string ManufacAddress { get; set; }

        public string ManufacCode { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? ActiveInActiveDate { get; set; }

    }
}