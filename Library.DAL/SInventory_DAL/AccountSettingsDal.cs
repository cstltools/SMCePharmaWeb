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
    public class AccountSettingsDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public UserInformation UserInformationEditLoad(string userId)
        {
            string query = "select * from tblUser where UserId = @UserId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            };
            DataTable userTable = SInventorySql.GetDataTable(query, parameters);
            UserInformation aUserInformation = new UserInformation();


            if (userTable.Rows.Count > 0)
            {
                DataRow row = userTable.Rows[0];
                aUserInformation.UserId = Int32.Parse(row["UserId"].ToString());
                aUserInformation.UserName = row["UserName"].ToString();
                aUserInformation.UserType = row["UserType"].ToString();
                aUserInformation.LoginName = row["LoginName"].ToString();
                aUserInformation.Password = row["Password"].ToString();
                aUserInformation.UserStatus = row["UserStatus"].ToString();
                aUserInformation.Email = row["Email"].ToString();
                aUserInformation.ContactNo = row["ContactNo"].ToString();
            }
            return aUserInformation;
        }


        public bool UpdateUserInfo(UserInformation aUserInformation)
        {
            string query = @"UPDATE tblUser SET UserName=@UserName,UserType=@UserType,LoginName=@LoginName,Password=@Password,UserStatus=@UserStatus,Email=@Email,ContactNo=@ContactNo WHERE UserId=@UserId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserName", SInventorySql.DbValue(aUserInformation.UserName)),
                new SqlParameter("@UserType", SInventorySql.DbValue(aUserInformation.UserType)),
                new SqlParameter("@LoginName", SInventorySql.DbValue(aUserInformation.LoginName)),
                new SqlParameter("@Password", SInventorySql.DbValue(aUserInformation.Password)),
                new SqlParameter("@UserStatus", SInventorySql.DbValue(aUserInformation.UserStatus)),
                new SqlParameter("@Email", SInventorySql.DbValue(aUserInformation.Email)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aUserInformation.ContactNo)),
                new SqlParameter("@UserId", aUserInformation.UserId)
            };
            return SInventorySql.Execute(query, parameters);
        }

        public void GetUserOnDropDownList(DropDownList ddl)
        {
            string query = "SELECT UserId,UserCode + ':' + UserName AS UserName FROM tblUser";
            aCommonInternalDal.LoadDropDownValue(ddl, "UserName", "UserId", query, "SSIDB");

        }
    }
}
