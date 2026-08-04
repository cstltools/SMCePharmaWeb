using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class ConditionalPurposeDal
    {


        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public void LoadCondition(DropDownList ddl)
        {
            string query = @"SELECT StockConId,StockCondition FROM dbo.tblStockCondition WHERE StockCondition NOT IN ('Available','ReturnStock')";
            aCommonInternalDal.LoadDropDownValue(ddl, "StockCondition", "StockConId", query, "SSIDB");
        }


        public bool SaveSettings(string purpose, string conditionId)
        {
            string insertQuery = @"INSERT INTO dbo.tblPurpose (Purpose,StockConditionId) VALUES (@Purpose,@StockConditionId)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@Purpose", SInventorySql.DbValue(purpose)),
                new SqlParameter("@StockConditionId", SInventorySql.DbValue(conditionId))
            });
        }
    }
}
