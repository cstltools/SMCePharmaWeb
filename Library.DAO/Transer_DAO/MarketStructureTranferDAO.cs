using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.Transer_DAO
{
  public  class MarketStructureTranferDAO
    {

        public int MarketStructureTranferId { get; set; }

        public int? FGroupId { get; set; }

        public int? FRegionId { get; set; }

        public int? FAreaId { get; set; }

        public int? FTerritoryId { get; set; }

        public int? FSubTerritoryId { get; set; }

        public int? FMarketId { get; set; }

        public int? TGroupId { get; set; }

        public int? TRegionId { get; set; }

        public int? TAreaId { get; set; }

        public int? TTerritoryId { get; set; }

        public int? TSubTerritoryId { get; set; }

        public int? TMarketId { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }
    }
}
