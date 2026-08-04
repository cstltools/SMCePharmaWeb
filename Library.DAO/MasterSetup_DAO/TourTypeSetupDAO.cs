using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
    public class TourTypeSetupDAO
    {

        public int TourSetupEmployeeId { get; set; }

        public bool? IsRoleWise { get; set; }

        public bool? IsEmployeeWise { get; set; }

        public int? EmpInfoId { get; set; }
        public int? RoleTypeId { get; set; }

        public int? StationTypeId { get; set; }

        public int? CountNo { get; set; }
        public int EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public int UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }

    }
}
