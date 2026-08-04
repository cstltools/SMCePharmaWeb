using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.UserRoleDAO
{
    public class UserRoleDAO
    {
        public int UserRoleID { get; set; }
        public string RoleName { get; set; }
        public bool IsActive { get; set; }
        public DateTime ActiveDate { get; set; }
        public DateTime ActiveInActiveDate { get; set; }
        public string InActiveBy { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public int RoleTypeId { get; set; }
    }
}
