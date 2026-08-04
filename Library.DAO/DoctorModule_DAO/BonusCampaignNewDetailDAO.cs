using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class BonusCampaignNewDetailDAO
    {
        public int? CampaignDetailId { get; set; }

        public int? CampaignMasterId { get; set; }

        

        public decimal? DiscountPercentage { get; set; }

        public int? ProductId { get; set; }

        public decimal? Quantity { get; set; }
        public decimal? QuantityDteail { get; set; }


        public int? BonusProductId { get; set; }
        public bool? IsRatioWiseIncrementPro { get; set; }

        public decimal? BonusQuantity { get; set; }
         
 

    

        public int? BonusTypeId { get; set; }
        public string CampaignName { get; set; }
    }


    public class CustomerPropUpdateDetailDAO
    {
        public int? CustPropUpdateDetailId { get; set; }

        public int? CustPropMasterId { get; set; }

        public string CustCode { get; set; }

        public int? CustomerId { get; set; }

        public string ProviderType { get; set; }

        public int? ProviderTypeId { get; set; }

        public string CustTypeCode { get; set; }

        public int? CustTypeId { get; set; }

        public string MarketCode { get; set; }
        public string PharmaPlatformCode { get; set; }

        public int? MarketId { get; set; }

    }
}