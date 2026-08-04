using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class UserCompanyUnitDao
    {
        public Int32 UserComId { get; set; }
        public Int32 UserId { get; set; }
        public Int32 CompanyUnitId { get; set; }
        public bool CWHPermission { get; set; }
        public bool NationalReportPermission { get; set; }
    }
}
