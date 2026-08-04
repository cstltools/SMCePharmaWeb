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
    public class DCUserPermissionDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void GetUserInfo(DropDownList ddl)
        {
            string query = @"SELECT UserId,UserCode + ':' + UserName AS UserName FROM tblUser";
            aCommonInternalDal.LoadDropDownValue(ddl, "UserName", "UserId", query, "SSIDB");
        }

        public DataTable GetDCList()
        {
            string query = @"SELECT ComUnitId, ComUnitCode + ':'+ ComUnitName AS CompanyUnit FROM tblCompanyUnit UNION ALL SELECT 15,WearhouseCode + ':' + WearhouseName AS WearhouseName FROM tblWearhouse";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool SaveDCUserPermissionInfo(UserCompanyUnitDao aUserCompanyUnitDao)
        {
            string query = @"INSERT INTO tblUserCompanyUnit (UserId,CompanyUnitId,CWHPermission,NationalReportPermission) VALUES (@UserId,@CompanyUnitId,@CWHPermission,@NationalReportPermission)";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(aUserCompanyUnitDao.UserId)),
                new SqlParameter("@CompanyUnitId", SInventorySql.DbValue(aUserCompanyUnitDao.CompanyUnitId)),
                new SqlParameter("@CWHPermission", SInventorySql.DbValue(aUserCompanyUnitDao.CWHPermission)),
                new SqlParameter("@NationalReportPermission", SInventorySql.DbValue(aUserCompanyUnitDao.NationalReportPermission))
            });
        }

        public DataTable CheckPermissionInfoAlreadyExistOrNot(UserCompanyUnitDao aUserCompanyUnitDao)
        {
            string query = @"SELECT * FROM tblUserCompanyUnit WHERE UserId = @UserId AND CompanyUnitId = @CompanyUnitId AND CWHPermission = @CWHPermission AND NationalReportPermission = @NationalReportPermission";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(aUserCompanyUnitDao.UserId)),
                new SqlParameter("@CompanyUnitId", SInventorySql.DbValue(aUserCompanyUnitDao.CompanyUnitId)),
                new SqlParameter("@CWHPermission", SInventorySql.DbValue(aUserCompanyUnitDao.CWHPermission)),
                new SqlParameter("@NationalReportPermission", SInventorySql.DbValue(aUserCompanyUnitDao.NationalReportPermission))
            });
        }

        public bool DeletePermissionInfo(string userId)
        {
            string query = @"DELETE FROM tblUserCompanyUnit WHERE UserId = @UserId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
        }

        public DataTable GetDCUserPermissionById(string userId)
        {
            string query = @"SELECT * FROM tblUserCompanyUnit WHERE UserId = @UserId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
        }
    }
}
