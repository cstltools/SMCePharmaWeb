using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class TADAMarketruleConfig
    {
        public int TADAMarketRuleConfigId { get; set; }

        public int? TourType { get; set; }

        public decimal? TAAmount { get; set; }

        public decimal? DAAmount { get; set; }

        public bool? IsActive { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsRoleWise { get; set; }

        public bool? IsMarketWise { get; set; }

        public bool? IsBoth { get; set; }

        public int? UserRoleID { get; set; }

        public int? GroupId { get; set; }

        public int? ZoneId { get; set; }

        public int? AreaId { get; set; }

        public int? TerritoryId { get; set; }

        public int? MarketId { get; set; }
    }
}