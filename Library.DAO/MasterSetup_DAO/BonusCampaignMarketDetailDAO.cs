using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
  public  class BonusCampaignMarketDetailDAO
    {
        public int CampaignMarketDetailId { get; set; }

        public int? CampaignMasterId { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public int? AreaId { get; set; }

        public int? TerritoryId { get; set; }

        public int? SubTerritoryId { get; set; }

        public int? MarketId { get; set; }

        public decimal? Distance { get; set; }
    }
}
