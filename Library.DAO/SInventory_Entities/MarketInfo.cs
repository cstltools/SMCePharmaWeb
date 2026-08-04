using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class MarketInfo
    {
        public int MarketId { get; set; }
        public string MarketCode { get; set; }
        public string MarketName { get; set; }
        public int CompanyId { get; set; }
        public int RegionId { get; set; }
        public int DistrictId { get; set; }
        public int ComUnitId { get; set; }
        public int AreaId { get; set; }
        public string AreaName { get; set; }
        public int MiaId { get; set; }
        public string MiaName { get; set; }
    }
}
