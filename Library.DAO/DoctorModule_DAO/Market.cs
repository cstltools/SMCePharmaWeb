using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class Market
    {
        public int MarketId { get; set; }

        public string MarketCode { get; set; }

        public string MarketName { get; set; }
        public string RoleName { get; set; }
        public string StationTypeName { get; set; }

        public int ZoneId { get; set; }
        public int AreaId { get; set; }
        public int TerritoryId { get; set; }
        public int? SubTerritoryId { get; set; }
        public int? ThanaId { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? AcOrInAcDate { get; set; }

        public string CreatedBy { get; set; }

        public DateTime? CreatedDate { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime? UpdatedDate { get; set; }

        public string Remarks { get; set; }


        //passing value

        public int GroupId { get; set; }
        public int StationTypeId { get; set; }
        public int UserRoleID { get; set; }

        public List<MarketStationDetailDao> MarketStationDetailDaoList { get; set; }

    }

    public class MarketStationDetailDao
    {
        public int MarketStationDetailId { get; set; }
        public int MarketId { get; set; }
        public int? StationTypeId { get; set; }
        public int? UserRoleID { get; set; }
   

    }
}