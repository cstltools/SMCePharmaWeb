using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class UnitPriceDao
    {
        public int? UnitPriceId { get; set; }

        public int? CompanyId { get; set; }

        public int? ProductId { get; set; }

        public string ProductCode { get; set; }

        public string ProductName { get; set; }

        public string PackSize { get; set; }

        public decimal? CostPrice { get; set; }

        public decimal? UnitPrice { get; set; }

        public decimal? MRPPrice { get; set; }

        public decimal? VATPercentage { get; set; }

        public decimal? VATAmountPerUnit { get; set; }

        public decimal? MusakVATPercentage { get; set; }

        public decimal? MusakVATAmountPerUnit { get; set; }

        public decimal? TPVat { get; set; }

        public decimal? MusakVat { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? ActiveDate { get; set; }

        public DateTime? InActiveDate { get; set; }

        public string ActionStatus { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }
    }
}