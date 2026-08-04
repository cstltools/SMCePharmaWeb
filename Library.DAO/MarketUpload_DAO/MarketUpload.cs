using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MarketUpload_DAO
{
    public class MarketUpload
    {
        public int MarketPropMasterId { get; set; }
        public int TypeId { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string ConvertType { get; set; }
        public bool IsTransfer { get; set; }
    }

    public class MarketUploadDetail
    {
        public int MarketPropDetailId { get; set; }

        public int? MarketPropMasterId { get; set; }

        public int? TerritoryId { get; set; }

        public string TerritoryCode { get; set; }

        public int? MarketId { get; set; }

        public string MarketCode { get; set; }

        public string MarketName { get; set; }

        public int? DivisionId { get; set; }

        public string DivisionName { get; set; }

        public int? DistrictId { get; set; }

        public string DistrictName { get; set; }

        public int? ThanaId { get; set; }

        public string ThanaName { get; set; }

        public string DZSMStationType { get; set; }
        public string RegionalHeadStationType { get; set; }

        public int? DZSMStationTypeId { get; set; }

        public string AMStationType { get; set; }

        public int? AMStationTypeId { get; set; }

        public string MIOStationType { get; set; }

        public int? MIOStationTypeId { get; set; }


        public string SalesAssistantStationType { get; set; }

        public int? SalesAssistantStationTypeId { get; set; }
    }
}
