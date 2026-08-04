using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorModule_DAO
{
 public   class SubTerritoryDAO
    {
        public int SubTerritoryId { get; set; }

        public int? TerritoryId { get; set; }

        public string SubTerritoryName { get; set; }

        public string SubTerritoryCode { get; set; }

        public string SubTerritoryShortName { get; set; }

        public string Description { get; set; }

        public string Remarks { get; set; }

        public bool? IsActive { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public DateTime? AcOrInAcDate { get; set; }

        public int? ActiveInactiveBy { get; set; }


        public int? ZoneId { get; set; }
        public int? AreaId { get; set; }
        public int? GroupId { get; set; }
    }
}
