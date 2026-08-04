using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class dadtlsBonusCampaignNewMasterDAO
    {
        public int CampgainMasterId { get; set; }
        public int CampgainMasterForUpdateId { get; set; }

        public string CampaignCode { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? CompanyId { get; set; }

        public string CampaignName { get; set; }

        public string CampaignDesc { get; set; }

        public DateTime? FromDate { get; set; }

        public DateTime? Todate { get; set; }

        public int? CampainTypeId { get; set; }
        public int? CampaignCategoryId { get; set; }
        public int? ProductLineID { get; set; }
        public int? BonusProductId { get; set; }
        public decimal? Amount { get; set; }
        public decimal? ProductQty { get; set; }

        public decimal? MaxAmount { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsTradePolicy { get; set; }
        public bool? IsFCFS { get; set; }
        public bool? IsRatioWiseIncrement { get; set; }
        public bool? IsMultipleProductAdd { get; set; }
        public bool? IsManualRationSetup { get; set; }
        public bool? IsPTforCOD { get; set; }
        public bool? IsPTforOther { get; set; }

        public int? CustomerTypeId { get; set; }

        public List<dadtlsBonusCampaignNewDetailDAO> BonusCampaignNewDetailDAOs { get; set; }
    }
     


}
