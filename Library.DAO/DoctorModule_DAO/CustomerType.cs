using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class CustomerType
    {

        public int CustomerTypeId { get; set; }

        public string CustomerTypee { get; set; }

        public string CustTypeCode { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }
        public int? CustomerCategoryId { get; set; }

        public bool? IsActive { get; set; }
        public bool? IsCampaign { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsTradeDiscount { get; set; }
        public bool? IsFixedDiscount { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }
}