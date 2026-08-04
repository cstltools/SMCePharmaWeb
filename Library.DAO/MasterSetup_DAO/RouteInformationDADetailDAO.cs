using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
   public class RouteInformationDADetailDAO
    {
        public int RouteInformationDADetailId { get; set; }

        public int? RouteInformationMasterId { get; set; }

        public int? DAId { get; set; }
    }



    public class  RouteInformationMasterDAO
    {
        public int RouteInformationMasterId { get; set; }
        public int? DCId { get; set; }
        public bool? IsSubDepo { get; set; }

        public string RouteName { get; set; }

        public decimal? TotalDistance { get; set; }

        public decimal? TotalDay { get; set; }
        public decimal? TAAmount { get; set; }
        public decimal? DAAmount { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
        public String MarketIdStr { get; set; }

        public int? RouteTypeId { get; set; }


    }
}
