using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class AreaInfo
    {
        public int AreaId { get; set; }
        public string AreaCode { get; set; }
        public string AreaName { get; set; }
        public int DistrictId { get; set; }
        public int ComUnitId { get; set; }
        public int RegionId { get; set; }
        public int CompanyId { get; set; }
        public string DistrictName { get; set; }
    }
}
