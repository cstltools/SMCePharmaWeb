using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class NoticeMarketDetails
    {
        public int NoticeDetailsId { get; set; }
        public int NoticeId { get; set; }
        public int RegionId { get; set; }
        public int AreaId { get; set; }
        public int TerritoryId { get; set; }
        public int MarketId { get; set; }
        public int GroupId { get; set; }
    }
}