using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class DistrictInfo
    {
        public int DistrictId { get; set; }
        public string DistrictCode { get; set; }
        public string DistrictName { get; set; }
        public int ComUnitId { get; set; }
        public int RegionId { get; set; }
        public int CompanyId { get; set; }
        public string ComUnitName { get; set; }
        public int ZoneId { get; set; }
        public string ZoneName { get; set; }
    }
}
