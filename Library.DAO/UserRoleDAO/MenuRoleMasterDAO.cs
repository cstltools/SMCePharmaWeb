using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SalesSolution.Web.Models;

namespace Library.DAO.UserRoleDAO
{
    public class MenuRoleMasterDAO
    {
        public int Id { get; set; }
        public List<MenuRoleDAO> MenuRoles { get; set; }
    }
}
