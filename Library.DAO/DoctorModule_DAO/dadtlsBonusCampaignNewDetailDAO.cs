using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class dadtlsBonusCampaignNewDetailDAO
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



}
