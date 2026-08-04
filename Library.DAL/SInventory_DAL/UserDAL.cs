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
    public class UserDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveUserInformation(UserInformation aInformation)
        {
            string insertQuery = @"insert into tblUser (UserId,UserName,UserType,LoginName,Password,UserStatus,Email,ContactNo,UserCode) 
            values (@UserId,@UserName,@UserType,@LoginName,@Password,@UserStatus,@Email,@ContactNo,@UserCode)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@UserId", aInformation.UserId),
                new SqlParameter("@UserName", SInventorySql.DbValue(aInformation.UserName)),
                new SqlParameter("@UserType", SInventorySql.DbValue(aInformation.UserType)),
                new SqlParameter("@LoginName", SInventorySql.DbValue(aInformation.LoginName)),
                new SqlParameter("@Password", SInventorySql.DbValue(aInformation.Password)),
                new SqlParameter("@UserStatus", SInventorySql.DbValue(aInformation.UserStatus)),
                new SqlParameter("@Email", SInventorySql.DbValue(aInformation.Email)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aInformation.ContactNo)),
                new SqlParameter("@UserCode", SInventorySql.DbValue(aInformation.UserCode))
            });
        }
        public DataTable LoadMenu(string userid, string UserRoleID)
        {
            string query = @"SELECT dbo.MainMenu2(@UserId,@UserRoleID) AS MenuHTML";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userid)),
                new SqlParameter("@UserRoleID", SInventorySql.DbValue(UserRoleID))
            });
        }
        public bool SaveUserCompanyUnit(UserCompanyUnit aCompanyUnit)
        {
            string insertQuery = @"insert into tblUserCompanyUnit (UserComId,UserId,CompanyUnitId) 
            values (@UserComId,@UserId,@CompanyUnitId)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@UserComId", aCompanyUnit.UserComId),
                new SqlParameter("@UserId", aCompanyUnit.UserId),
                new SqlParameter("@CompanyUnitId", aCompanyUnit.CompanyUnitId)
            });
        }

        public bool HasUserInformationName(UserInformation aUserInformation)
        {
            string query = "select * from tblUser where UserName = @UserName";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@UserName", SInventorySql.DbValue(aUserInformation.UserName))
            });
        }

        public bool HasLoginName(UserInformation aUserInformation)
        {
            string query = "select * from tblUser where LoginName = @LoginName";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@LoginName", SInventorySql.DbValue(aUserInformation.LoginName))
            });
        }

        public bool HasEmail(UserInformation aUserInformation)
        {
            string query = "select * from tblUser where Email = @Email";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@Email", SInventorySql.DbValue(aUserInformation.Email))
            });
        }
       
        public DataTable LoadUserView()
        {
            string query = @"SELECT tblUser.UserId,tblUser.UserName,tblUser.UserType,tblUser.LoginName,tblUser.Password,tblUser.UserStatus,tblUser.Email,tblUser.ContactNo FROM tblUser ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public UserInformation UserInformationEditLoad(string userId)
        {
            string query = "select * from tblUser where UserId = @UserId";
            DataTable userTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
            UserInformation aUserInformation = new UserInformation();
            //EmpGeneralInfo aGeneralInfo=new EmpGeneralInfo();

            
            if (userTable.Rows.Count > 0)
            {
                DataRow userRow = userTable.Rows[0];
                aUserInformation.UserId = Int32.Parse(userRow["UserId"].ToString());
                //aGeneralInfo.EmpMasterCode = dataReader["EmpMasterCode"].ToString();
                aUserInformation.UserName = userRow["UserName"].ToString();
                aUserInformation.UserType = userRow["UserType"].ToString();
                aUserInformation.LoginName = userRow["LoginName"].ToString();
                aUserInformation.Password = userRow["Password"].ToString();
                aUserInformation.UserStatus = userRow["UserStatus"].ToString();
                aUserInformation.Email = userRow["Email"].ToString();
                aUserInformation.ContactNo = userRow["ContactNo"].ToString();
            }
            return aUserInformation;
        }

        public bool UpdateUserInfo(UserInformation aUserInformation)
        {

            string query = @"UPDATE tblUser SET UserName=@UserName,UserType=@UserType,LoginName=@LoginName,Password=@Password,UserStatus=@UserStatus,Email=@Email,ContactNo=@ContactNo WHERE UserId=@UserId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@UserName", SInventorySql.DbValue(aUserInformation.UserName)),
                new SqlParameter("@UserType", SInventorySql.DbValue(aUserInformation.UserType)),
                new SqlParameter("@LoginName", SInventorySql.DbValue(aUserInformation.LoginName)),
                new SqlParameter("@Password", SInventorySql.DbValue(aUserInformation.Password)),
                new SqlParameter("@UserStatus", SInventorySql.DbValue(aUserInformation.UserStatus)),
                new SqlParameter("@Email", SInventorySql.DbValue(aUserInformation.Email)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aUserInformation.ContactNo)),
                new SqlParameter("@UserId", aUserInformation.UserId)
            });
        }

        public bool DeleteUserInfo(string userId)
        {

            string query = @"Delete from tblUser WHERE UserId=@UserId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
        }

        public void LoadUserType(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblUserType";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "UserType", "UserTypeId", queryStr);
        }

        public void LoadComUnit(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select ComUnitCode+':'+ComUnitName as ComUnitName,ComUnitId from tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
    }
}
