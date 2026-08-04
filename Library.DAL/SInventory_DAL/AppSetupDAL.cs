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
    public class AppSetupDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveAppSetup(AppSetupDAO appSetupDao)
        {
            string insertQuery = @"insert into tblAppSetup (SL,UserId,Email,EntryBy,EntryDate) 
            values (@SL,@UserId,@Email,@EntryBy,@EntryDate)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@SL", SInventorySql.DbValue(appSetupDao.SL)),
                new SqlParameter("@UserId", SInventorySql.DbValue(appSetupDao.UserId)),
                new SqlParameter("@Email", SInventorySql.DbValue(appSetupDao.Email)),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(appSetupDao.EntryBy)),
                new SqlParameter("@EntryDate", SInventorySql.DbValue(appSetupDao.EntryDate))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }
        public DataTable LoadAppSetup(string parameter)
        {
            string query = @"SELECT * FROM tblAppSetup
            LEFT JOIN dbo.tblMainMenu ON dbo.tblMainMenu.SL=tblAppSetup.SL
            LEFT JOIN dbo.tblUser ON dbo.tblUser.UserId=tblAppSetup.SL "+parameter;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public bool UpdateAreaInfo(AppSetupDAO appSetupDao)
        {
            string query = @"UPDATE tblAppSetup SET SL=@SL,UserId=@UserId,Email=@Email,EntryBy=@EntryBy,EntryDate=@EntryDate WHERE AppSetupId=@AppSetupId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@SL", SInventorySql.DbValue(appSetupDao.SL)),
                new SqlParameter("@UserId", SInventorySql.DbValue(appSetupDao.UserId)),
                new SqlParameter("@Email", SInventorySql.DbValue(appSetupDao.Email)),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(appSetupDao.EntryBy)),
                new SqlParameter("@EntryDate", SInventorySql.DbValue(appSetupDao.EntryDate)),
                new SqlParameter("@AppSetupId", appSetupDao.AppSetupId)
            };
            return SInventorySql.Execute(query, parameters);
        }
        public bool DeleteAreaInfo(string id)
        {
            string query = @"DELETE FROM tblAppSetup WHERE SL=@SL";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@SL", SInventorySql.DbValue(id))
            };
            return SInventorySql.Execute(query, parameters);
        }
        public void LoadMenuName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblMainMenu where IsApprovalPage='1'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManuName", "SL", queryStr);
        }
        public void LoadUser(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblUser WHERE UserStatus='Active'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "UserName", "UserId", queryStr);
        }
    }
}
