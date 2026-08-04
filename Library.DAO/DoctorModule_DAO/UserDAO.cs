using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorModule_DAO
{
 public   class UserDAO
    {

        public int UserId { get; set; }

        public string UserName { get; set; }

        public string UserType { get; set; }

        public string UserCode { get; set; }

        public string LoginName { get; set; }

        public string Password { get; set; }

        public string UserStatus { get; set; }

        public string Email { get; set; }

        public string ContactNo { get; set; }

        public bool? CentralWareHouse { get; set; }

        public int? EmpInfoId { get; set; }

        public bool? IsAppsUser { get; set; }

        public string IMEI_One { get; set; }

        public string IMEI_Two { get; set; }

        public int? UserRoleID { get; set; }

        public bool? IsExpProduct { get; set; }
        public DateTime? ActiveInActiveDate { get; set; }
        public int? UserTypeId { get; set; }
        public bool? IsMainDashboard { get; set; }
        public bool? IsDepotDashboard { get; set; }
        public int? DaInfoId { get; set; }
    }
}
