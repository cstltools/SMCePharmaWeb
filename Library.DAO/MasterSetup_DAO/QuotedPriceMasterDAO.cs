using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
  public  class QuotedPriceMasterDAO
    {
        public int QuotedPriceMasterId { get; set; }

        public string Description { get; set; }

        public string Policy { get; set; }

        public bool? IsCustomerWise { get; set; }

        public bool? IsMarketWise { get; set; }

        public int? CustomerMasterId { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public int? AreaId { get; set; }

        public int? TerritoryId { get; set; }

        public int? SubTerritoryId { get; set; }

        public int? MarketId { get; set; }

        public DateTime? ActiveFromDate { get; set; }

        public DateTime? ActiveToDate { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }

        public string ActionStatus { get; set; }
    }
}
