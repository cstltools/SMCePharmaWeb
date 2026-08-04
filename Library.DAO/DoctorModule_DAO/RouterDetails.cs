using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class RouterDetails
    {
        public int RouterDetailsId { get; set; }

        public int? RouterMasterId { get; set; }

        public int? TerritoryId { get; set; }

        public int? MarketId { get; set; }
    }
}