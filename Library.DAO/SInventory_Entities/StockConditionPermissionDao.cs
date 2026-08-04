using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class StockConditionPermissionDao
    {
        public Int32 StockCondintionID { get; set; }
        public Int32 UserId { get; set; }
        public Int32 CompanyUnitId { get; set; }
        public Int32 StockConId { get; set; }
        public Boolean Permission { get; set; }
    }
}
