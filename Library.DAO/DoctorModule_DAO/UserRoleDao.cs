using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorModule_DAO
{
    public class UserRoleDao
    {
        public int UserRoleID { get; set; }
        public int RoleTypeId { get; set; }
        public string RoleName { get; set; }
        public string ActiveDateStr { get; set; }
        public string UserRole { get; set; }
        public bool IsActive { get; set; }
        public DateTime ActiveDate { get; set; }
        public DateTime InActiveDate { get; set; }
        public string InActiveBy { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }

    }
}
