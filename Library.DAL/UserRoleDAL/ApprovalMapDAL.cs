using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.UserRoleDAO;
using SalesSolution.Web.Models;

namespace Library.DAL.UserRoleDAL
{
    public class ApprovalMapDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public dynamic GetRoleTypeDropDown()
        {

            try
            {
                try
                {
                    accessManager.SqlConnectionOpen(DataBase.SalesDB);
                    //List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    //aSqlParameterlist.Add(new SqlParameter("@RoleId", (object)(roleid ?? (object)DBNull.Value)));
                    SqlDataReader dr = this.accessManager.GetSqlDataReader("sp_GET_RoleType", false);
                    var list = accessManager.Serialize(dr);

                    return list;
                }
                catch (Exception exception)
                {
                    throw;
                }
            }
            finally
            {
                accessManager.SqlConnectionClose(false);
            }

        }
        public dynamic LoadApprovalMap(string roleid, string typeId)
        {

            try
            {
                try
                {
                    accessManager.SqlConnectionOpen(DataBase.SalesDB);
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    aSqlParameterlist.Add(new SqlParameter("@FromRoleId", (object)(roleid ?? (object)DBNull.Value)));
                    aSqlParameterlist.Add(new SqlParameter("@MenuId", (object)(typeId ?? (object)DBNull.Value)));
                    SqlDataReader dr = this.accessManager.GetSqlDataReader("sp_GET_ApprovalMapLoad", aSqlParameterlist, false);
                    var list = accessManager.Serialize(dr);

                    return list;
                }
                catch (Exception exception)
                {
                    throw;
                }
            }
            finally
            {
                accessManager.SqlConnectionClose(false);
            }

        }
        public dynamic GetMainMenuDropDown()
        {

            try
            {
                try
                {
                    accessManager.SqlConnectionOpen(DataBase.SalesDB);
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    aSqlParameterlist.Add(new SqlParameter("@TypeId", (object)("" ?? (object)DBNull.Value)));
                    SqlDataReader dr = this.accessManager.GetSqlDataReader("sp_GET_MainMenuByType", aSqlParameterlist);
                    var list = accessManager.Serialize(dr);

                    return list;
                }
                catch (Exception exception)
                {
                    throw;
                }
            }
            finally
            {
                accessManager.SqlConnectionClose(false);
            }

        }

        public int SaveApprovalMapMaster(ApprovalMapMaster approvalMapMaster)
        {

            try
            {
                try
                {
                    this.accessManager.SqlConnectionOpen(DataBase.SalesDB);
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    aSqlParameterlist.Add(new SqlParameter("@MenuId", (object)(approvalMapMaster.MenuId ?? (object)DBNull.Value)));
                    aSqlParameterlist.Add(new SqlParameter("@FromRoleId", (object)(approvalMapMaster.FromRoleId ?? (object)DBNull.Value)));
                    aSqlParameterlist.Add(new SqlParameter("@MenuName", (object)(approvalMapMaster.MenuName ?? (object)DBNull.Value)));
                    

                    return accessManager.SaveDataReturnPrimaryKey("sp_Save_ApprovalMapMaster", aSqlParameterlist, true);
                }
                catch (Exception exception)
                {
                    throw;
                }
            }
            finally
            {
                this.accessManager.SqlConnectionClose(false);
            }

        }

        public int SaveApprovalMapDetail(ApprovalMapDetail approvalMapMaster)
        {

            try
            {
                try
                {
                    this.accessManager.SqlConnectionOpen(DataBase.SalesDB);
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    aSqlParameterlist.Add(new SqlParameter("@ApprovalMapMasterId", (object)(approvalMapMaster.ApprovalMapMasterId ?? (object)DBNull.Value)));
                    aSqlParameterlist.Add(new SqlParameter("@Order", (object)(approvalMapMaster.Order ?? (object)DBNull.Value)));
                    aSqlParameterlist.Add(new SqlParameter("@ToRoleId", (object)(approvalMapMaster.ToRoleId ?? (object)DBNull.Value)));
                    


                    return accessManager.SaveDataReturnPrimaryKey("sp_Save_ApprovalMapDetail", aSqlParameterlist, true);
                }
                catch (Exception exception)
                {
                    throw;
                }
            }
            finally
            {
                this.accessManager.SqlConnectionClose(false);
            }

        }

    }
}
