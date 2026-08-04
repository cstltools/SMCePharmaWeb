using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class LoginInfoDAO
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string UserType { get; set; }
        public string EmpMasterCode { get; set; }
        public string LoginName { get; set; }
        public string Password { get; set; }
        public string UserStatus { get; set; }
        public string Email { get; set; }
        public string ContactNo { get; set; }
    }
}