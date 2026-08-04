using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DWSP_DAO
{
   public class AreaWiseTargetSetupDao
    {
        public int AreaWTSetupId { get; set; }

        public string Year { get; set; }

        public string Month { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public decimal? TargetAmount { get; set; }

        public int? AreaId { get; set; }

        public decimal? Amount { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
    }



    public class  TerritoryTargetSetupDao
    {
        public int TerritoryWTSetupId { get; set; }
        public int? EmpInfoId { get; set; }

        public string Year { get; set; }

        public string Month { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public decimal? TargetAmount { get; set; }

        public int? AreaId { get; set; }
        public int? TerritoryId { get; set; }
        public decimal? FCBAmount { get; set; }
        public decimal? GeneralAmount { get; set; }
        public decimal? CampaignAmount { get; set; }
        public DateTime? DWSPDate { get; set; }

        public decimal? Amount { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
    }
}
