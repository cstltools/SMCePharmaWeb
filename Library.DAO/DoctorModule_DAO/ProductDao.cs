using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ProductDao
    {
        public int ProductId { get; set; }

        public int? CompanyId { get; set; }

        public string ProductCode { get; set; }

        public string ProductName { get; set; }

        public string Description { get; set; }

        public int? PackSizeId { get; set; }

        public string PackSize { get; set; }

        public int? ProTypeId { get; set; }

        public int? ShippingCartonSizeId { get; set; }

        public string ProductType { get; set; }

        public int? ProductBrandId { get; set; }

        public int? CategoryId { get; set; }

        public int? ManufacId { get; set; }

        public int? StockUOMId { get; set; }

        public int? CaseId { get; set; }

        public int? GenericGroupId { get; set; }

        public int? TherapueticGroupId { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
    }
}