using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class StockConditionPermissionDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void GetUserInfoOnDropdownList(DropDownList ddl)
        {
            string query = @"SELECT UserId,UserCode + ':' + UserName AS UserName FROM tblUser";
            aCommonInternalDal.LoadDropDownValue(ddl, "UserName", "UserId", query, "SSIDB");
        }

        public DataTable GetStockConditionList()
        {
            string query = @"SELECT * FROM dbo.tblStockCondition";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetStockConditionByUserId(string userId)
        {
            string query = @"SELECT * FROM dbo.tblStockConditionPermission WHERE UserId = @UserId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
        }

        public bool SaveStockConditionPermissionInfo(StockConditionPermissionDao stockConditionPermissionDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblStockConditionPermission (UserId,StockConId,Permission) VALUES (@UserId,@StockConId,@Permission)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(stockConditionPermissionDao.UserId)),
                new SqlParameter("@StockConId", SInventorySql.DbValue(stockConditionPermissionDao.StockConId)),
                new SqlParameter("@Permission", SInventorySql.DbValue(stockConditionPermissionDao.Permission))
            });
        }

        public DataTable CheckPermissionInfoAlreadyExistOrNot(StockConditionPermissionDao stockConditionPermissionDao)
        {
            string query = @"SELECT * FROM dbo.tblStockConditionPermission WHERE UserId = @UserId AND StockConId = @StockConId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(stockConditionPermissionDao.UserId)),
                new SqlParameter("@StockConId", SInventorySql.DbValue(stockConditionPermissionDao.StockConId))
            });
        }

        public bool DeletePermissionInfo(StockConditionPermissionDao stockConditionPermissionDao)
        {
            string query = @"DELETE FROM dbo.tblStockConditionPermission WHERE UserId = @UserId AND StockConId = @StockConId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(stockConditionPermissionDao.UserId)),
                new SqlParameter("@StockConId", SInventorySql.DbValue(stockConditionPermissionDao.StockConId))
            });
        }
    }
}
