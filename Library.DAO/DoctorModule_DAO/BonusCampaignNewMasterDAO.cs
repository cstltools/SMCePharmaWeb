using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class BonusCampaignNewMasterDAO
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

        public List<BonusCampaignNewDetailDAO> BonusCampaignNewDetailDAOs { get; set; }
    }

    public class CampaignCustomerDetailDAO
    {
        public int CampaignCustomerDetailId { get; set; }
        public int CampgainMasterId { get; set; }

        public int? CustomerMasterId { get; set; }
         

    } 
    
    public class TargetEditDAO
    {
        public int SL { get; set; }
        public int? FYId { get; set; }
        public int? YearValue { get; set; }

        public int?  MonthName { get; set; }
        public int? EmpId { get; set; }
        public decimal? Value { get; set; } 

    }


    public class CustomerPropUpdateMasterDAO
    {
        public int CustPropMasterId { get; set; }

        public int? TypeId { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string ConvertType { get; set; }

        public bool? IsTransfer { get; set; }
    }



    public class  ManualRationSetupCampDAO
    {
        public int ManualRationSetupId { get; set; }

        public int? CampgainMasterId { get; set; }

        public int? ProductId { get; set; }
        public int? BounsProductId { get; set; }

        public decimal? MainQuantity_From { get; set; }
        public decimal? MainQuantity_ManualRationSetup { get; set; }

        public decimal? BonusQuantity_ManualRationSetup { get; set; }

    }




    public class  MultipleProductAddCampDAO
    {
        public int MultipleProductAddId { get; set; }

        public int? CampgainMasterId { get; set; }

        public int? ProductId { get; set; }

        public decimal? ProQty_MultipleProductAdd { get; set; }

    }


}