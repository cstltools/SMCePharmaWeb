using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class MiaInformation
    {
        public int MiaId { get; set; }
        public string MiaCode { get; set; }
        public string MiaName { get; set; }
        public int ManufacId { get; set; }
        public int CompanyId { get; set; }
        public int RegionId { get; set; }
        public int DistrictId { get; set; }
        public int ComUnitId { get; set; }
        public int AreaId { get; set; }
        public int MarketId { get; set; }
        public string RegionName { get; set; }
        public string AreaName { get; set; }
        public string DistrictName { get; set; }
        public string ComUnitName { get; set; }
        public string MarketName { get; set; }
        public int ZoneId { get; set; }
        public string ZoneName { get; set; }
    }
}
