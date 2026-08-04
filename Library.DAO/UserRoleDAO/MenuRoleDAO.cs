using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class MenuRoleDAO
    {
        public int? MenuRoleId { get; set; }
        public int? SL { get; set; }
        public int? RoleId { get; set; }
        public bool? Add { get; set; }
        public bool? View { get; set; }
        public bool? Delete { get; set; }
        public bool? Edit { get; set; }
        public bool? Permission { get; set; }

    }
}