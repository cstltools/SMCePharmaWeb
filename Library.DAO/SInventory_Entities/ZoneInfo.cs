using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class ZoneInfo
    {
        public int ZoneId { get; set; }
        public string ZoneCode { get; set; }
        public string ZoneName { get; set; }
        public int ComUnitId { get; set; }
        public string ComUnitName { get; set; }
    }
}
