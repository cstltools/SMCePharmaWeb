using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ProductCategoryDao
    {
        public int ProductCategoryId { get; set; }

        public string ProductCategoryCode { get; set; }

        public string ProductCategory { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }
}