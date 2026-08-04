using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;

namespace Library.DAL.PanalCls
{
    public class PanalClsDAL
    {
        private ClsCommonInternalDAL _aCommonInternalDal;
        private DataAccessManager accessManager = new DataAccessManager();

        public DataTable Login(string loginName, string password)
        {
            string queryString = @"  select top 1 isnull(IsPasswordChange,0) IsPasswordChange, case when  emp.EmpInfoId is null then u.UserName else case when u.UserTypeId=6 or u.UserTypeId=7  then da.DACode else  emp.EmpMasterCode end  end EmpMasterCode ,  STUFF((SELECT ', ' + CONVERT(VARCHAR, CompanyUnitId) 
                   FROM tblUserCompanyUnit AS InnerUC 
                   WHERE InnerUC.UserId = U.UserId 
                   FOR XML PATH('')), 1, 2, '') AS CompanyUnitIdList , tblDis.CompanyUnitId DICCompanyUnitId, rt.RoleType RoleTypeName,  case when  emp.EmpInfoId is null then u.UserName else case when u.UserTypeId=6 then da.Name else  emp.EmpName end  end EmpName , case when u.UserTypeId=6 then  U.UserType else  dgs.DesigName end  DesigName, * from dbo.tblUser U with (nolock)
 left join tblUserCompanyUnit UC  with (nolock) on U.UserId=UC.UserId
 left join tblEmpGeneralInfo emp  with (nolock) on U.EmpInfoId=emp.EmpInfoId
 left join tblDAInfo da  with (nolock) on da.DAId=U.daInfoId
 left join tblDesignation dgs  with (nolock) on dgs.DesignationId=emp.DesignationId
  LEFT   JOIN dbo.tbl_UserRoleInfo  AS urR  with (nolock)  ON urR.UserRoleID = U.UserRoleID 
  LEFT   JOIN dbo.tblRoleType AS rt  with (nolock)  ON rt.RoleTypeId = urR.RoleTypeId

    LEFT JOIN (select * from (Select  UserId, CompanyUnitId ,
ROW_NUMBER() OVER (
      PARTITION BY UserId
      ORDER BY UserComId asc

   ) row_num
FROM tblUserCompanyUnit with (nolock)  )as tblt where row_num=1) AS tblDis on tblDis.UserId=U.UserId
where LoginName=@LoginName and Password=@Password and UserStatus='active'";

            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@LoginName", SqlDbType.VarChar, 100) { Value = loginName },
                new SqlParameter("@Password", SqlDbType.VarChar, 100) { Value = password }
            };

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                return accessManager.GetDataTableByText(queryString, parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable MainMenu()
        {
            _aCommonInternalDal = new ClsCommonInternalDAL();
            DataTable aTableMainMenu = new DataTable();
            string queryString = "select * from tblMainMenu where ParantId is null or ParantId=''";
            aTableMainMenu= _aCommonInternalDal.DataContainerDataTable(queryString);
            return aTableMainMenu;
        }

        public DataTable FinancialYearList()
        {
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = @"select FinancialYearId, FinancialYearDesc from SalesDisDB_SMC_NEWDB..tblFinancialYear  ";
            return _aCommonInternalDal.DataContainerDataTable(queryString, "SSIDB");
        }
        public bool LoginLog(string userId,string LoginName,DateTime loginTime)
        {
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = "INSERT INTO dbo.tblLoginLog ( UserId, LoginName, LoginTime ) VALUES  ( @UserId, @LoginName, @LoginTime )";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserId", SqlDbType.VarChar, 50) { Value = userId },
                new SqlParameter("@LoginName", SqlDbType.VarChar, 100) { Value = LoginName },
                new SqlParameter("@LoginTime", SqlDbType.DateTime) { Value = loginTime }
            };
            return _aCommonInternalDal.UpdateDataByUpdateCommandNew(queryString, parameters);
        }
        public DataTable MainMenu(int userId)
        {
            _aCommonInternalDal = new ClsCommonInternalDAL();
            DataTable aTableMainMenu = new DataTable();
            string queryString = @"select tblMainMenu.* from tblMainMenu "+
                                    " INNER JOIN dbo.tblMenuDistribution ON dbo.tblMainMenu.SL = dbo.tblMenuDistribution.MenuSL " +
                                    " WHERE UserId = @UserId AND (ParantId is null or ParantId='')";
            aTableMainMenu = _aCommonInternalDal.DataContainerDataTable(queryString, new List<SqlParameter>
            {
                new SqlParameter("@UserId", userId)
            }, "SSIDB");
            return aTableMainMenu;
        }
        public DataTable SubItem(string Id)
        {
            DataTable aDataTableSubItem = new DataTable();
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = "select * from tblMainMenu where ParantId = @ParantId";
            aDataTableSubItem = _aCommonInternalDal.DataContainerDataTable(queryString, ParentParameters(Id), "SSIDB");
            return aDataTableSubItem;
        }
        public DataTable SubItem(string Id, int userId)
        {
            DataTable aDataTableSubItem = new DataTable();
            _aCommonInternalDal = new ClsCommonInternalDAL();

            string queryString = @"select tblMainMenu.* from tblMainMenu " +
                                   " INNER JOIN dbo.tblMenuDistribution ON dbo.tblMainMenu.SL = dbo.tblMenuDistribution.MenuSL " +
                                   " WHERE UserId = @UserId AND ParantId = @ParantId";

            
            aDataTableSubItem = _aCommonInternalDal.DataContainerDataTable(queryString, MenuParameters(Id, userId), "SSIDB");
            return aDataTableSubItem;
        }
        public DataTable SubSubItem(string Id)
        {
            DataTable aDataSubSubItem = new DataTable();
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = "select * from tblMainMenu where ParantId = @ParantId";
            aDataSubSubItem = _aCommonInternalDal.DataContainerDataTable(queryString, ParentParameters(Id), "SSIDB");
            return aDataSubSubItem;
        }
        public DataTable SubSubItem(string Id, int userId)
        {
            DataTable aDataSubSubItem = new DataTable();
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = @"select tblMainMenu.* from tblMainMenu " +
                                   " INNER JOIN dbo.tblMenuDistribution ON dbo.tblMainMenu.SL = dbo.tblMenuDistribution.MenuSL " +
                                   " WHERE UserId = @UserId AND ParantId = @ParantId";
            aDataSubSubItem = _aCommonInternalDal.DataContainerDataTable(queryString, MenuParameters(Id, userId), "SSIDB");
            return aDataSubSubItem;
        }
        public DataTable SubSubChildItem(string Id)
        {
            DataTable aDataSubSubChildItem = new DataTable();
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = "select * from tblMainMenu where ParantId = @ParantId";
            aDataSubSubChildItem = _aCommonInternalDal.DataContainerDataTable(queryString, ParentParameters(Id), "SSIDB");
            return aDataSubSubChildItem;
        }
        public DataTable SubSubChildItem(string Id, int userId)
        {
            DataTable aDataSubSubChildItem = new DataTable();
            _aCommonInternalDal = new ClsCommonInternalDAL();
            string queryString = @"select tblMainMenu.* from tblMainMenu " +
                                    " INNER JOIN dbo.tblMenuDistribution ON dbo.tblMainMenu.SL = dbo.tblMenuDistribution.MenuSL " +
                                    " WHERE UserId = @UserId AND ParantId = @ParantId";
            aDataSubSubChildItem = _aCommonInternalDal.DataContainerDataTable(queryString, MenuParameters(Id, userId), "SSIDB");
            return aDataSubSubChildItem;
        }

        private static List<SqlParameter> ParentParameters(string parentId)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ParantId", parentId ?? (object)DBNull.Value)
            };
        }

        private static List<SqlParameter> MenuParameters(string parentId, int userId)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@UserId", userId),
                new SqlParameter("@ParantId", parentId ?? (object)DBNull.Value)
            };
        }

    }
}
