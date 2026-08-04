
using SalesSolution.Web.Interface;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;
using Library.DAO.DoctorModule_DAO;

namespace SalesSolution.Web.DataLayer
{
    public class RSMSetupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        
        

        public ResultInfo Save_ASMInfo(ASMInfo aRSMInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ASMId", aRSMInfo.ASMId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aRSMInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@AreaId", aRSMInfo.AreaId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aRSMInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aRSMInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aRSMInfo.ActiveDate));

                //aInformation.isSuccess = accessManager.SaveData("sp_Save_RSMInfo", gSqlParameterList);

                if (aRSMInfo.ASMId > 0)
                {

                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@AreaId", aRSMInfo.AreaId));
                    aSqlprm.Add(new SqlParameter("@ASMId", aRSMInfo.ASMId));
                    DataTable dt = accessManager.GetDataTable("sp_check_ASMInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {


                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_ASMInfo", gSqlParameterList);
                        pk = aRSMInfo.ASMId;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ASMInfo", gSqlParameterList);
                }
                    
               if (pk > 0)
               {
                 aInformation.isSuccess = true;
               }
                else
                {
                    aInformation.isValiCheck = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }


        public ResultInfo InsertUpdate_ASMInfoDAL(ASMInfo aRSMInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ASMId", aRSMInfo.ASMId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aRSMInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@AreaId", aRSMInfo.AreaId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aRSMInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aRSMInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aRSMInfo.ActiveDate));

                //aInformation.isSuccess = accessManager.SaveData("sp_Save_RSMInfo", gSqlParameterList);

                if (aRSMInfo.ASMId > 0)
                {

                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@AreaId", aRSMInfo.AreaId));
                    aSqlprm.Add(new SqlParameter("@ASMId", aRSMInfo.ASMId));
                    DataTable dt = accessManager.GetDataTable("sp_check_ASMInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {

                        if (aRSMInfo.IsActive)
                        {
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_Insert_ASMInfo", gSqlParameterList);
                            pk = aRSMInfo.ASMId;
                        }
                        else
                        {
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_ASMInfo", gSqlParameterList);
                            pk = aRSMInfo.ASMId;
                        }
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                //else
                //{
                //    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ASMInfo", gSqlParameterList);
                //}

                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isValiCheck = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public ResultInfo Save_UserRoleInfo(UserRoleDao aRoleInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@UserRoleID", aRoleInfo.UserRoleID));
                gSqlParameterList.Add(new SqlParameter("@RoleName", aRoleInfo.RoleName));
                gSqlParameterList.Add(new SqlParameter("@RoleTypeId", aRoleInfo.RoleTypeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aRoleInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aRoleInfo.ActiveDate));


                if (aRoleInfo.UserRoleID > 0)
                {

                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@RoleName", aRoleInfo.RoleName));
                    aSqlprm.Add(new SqlParameter("@UserRoleID", aRoleInfo.UserRoleID));
                    DataTable dt = accessManager.GetDataTable("sp_check_UserRoleInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {


                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_UserRoleInfo", gSqlParameterList);
                        pk = aRoleInfo.UserRoleID;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }

                else
                {
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_UserRoleInfo", gSqlParameterList);

                }

                //aInformation.isSuccess = accessManager.SaveData("sp_Save_RSMInfo", gSqlParameterList);

                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isValiCheck = true;
                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable Get_UserRoleInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_UserRoleList", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }



        public DataTable Get_UserListInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                string query = @"SELECT
                    CASE
                        WHEN UR.UserTypeId = 6 THEN ISNULL(da.DACode, '') +  ISNULL( ' : ' +da.Name, '')
                         WHEN UR.UserTypeId = 7 THEN ISNULL(daAss.DACode, '') +  ISNULL( ' : ' +daAss.Name, '')

                        ELSE emp.EmpName
                    END AS EmpName,
                    uRR.RoleName,
                    uType.UserType,
                    UR.UserStatus,
                    CONVERT(NVARCHAR(50), UR.ActiveInActiveDate, 106) AS ActiveInActiveDate,
                    *
                   FROM tblUser AS UR with (nolock)
                   left join tbl_UserRoleInfo uRR with (nolock) on uRR.UserRoleID=UR.UserRoleID
                   left join tblUserType uType with (nolock) on uType.UserTypeId=UR.UserTypeId
                   left join tblEmpGeneralInfo emp with (nolock) on UR.EmpInfoId=emp.EmpInfoId
                   left join tblDAInfo da with (nolock) on UR.UserTypeId = 6 and UR.daInfoId=da.DAId                   left join tblDAInfo daAss with (nolock) on UR.UserTypeId = 7 and UR.daInfoId=daAss.DAId

                   WHERE UR.UserId IS NOT NULL and UR.UserId not in (1) " + (parameter ?? "");

                DataTable dt = accessManager.GetDataTableByText(query, aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable Get_AppMonitoringList(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("AppMonitoringViewList", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable Get_AppMonitoringList_new(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("AppMonitoringViewList_new", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public ResultInfo Save_NSMInfo(NSMInfo aNSMInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NSMId", aNSMInfo.NSMId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aNSMInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@GroupId", aNSMInfo.GroupId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aNSMInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aNSMInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aNSMInfo.ActiveDate));


                if (aNSMInfo.NSMId > 0)
                {

                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@GroupId", aNSMInfo.GroupId));
                    aSqlprm.Add(new SqlParameter("@NSMId", aNSMInfo.NSMId));
                    DataTable dt = accessManager.GetDataTable("sp_check_NSMInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {
                     

                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_NSMInfo", gSqlParameterList);
                        pk = aNSMInfo.NSMId;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_NSMInfo", gSqlParameterList);

                }

                //aInformation.isSuccess = accessManager.SaveData("sp_Save_RSMInfo", gSqlParameterList);

                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isSuccess = false;
                    aInformation.isValiCheck = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }
        
        public ResultInfo Save_NSMHeadInfo(NSMHeadInfo aNSMInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NSMId", aNSMInfo.National_NSMId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aNSMInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@GroupId", aNSMInfo.NationalId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aNSMInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aNSMInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aNSMInfo.ActiveDate));


                if (aNSMInfo.National_NSMId > 0)
                {

                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@GroupId", aNSMInfo.National_NSMId));
                    aSqlprm.Add(new SqlParameter("@NSMId", aNSMInfo.NationalId));
                    DataTable dt = accessManager.GetDataTable("sp_check_NSMHeadInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {
                     

                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_NSMHeadInfo", gSqlParameterList);
                        pk = aNSMInfo.National_NSMId;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_NSMHeadInfo", gSqlParameterList);

                }

                //aInformation.isSuccess = accessManager.SaveData("sp_Save_RSMInfo", gSqlParameterList);

                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isSuccess = false;
                    aInformation.isValiCheck = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }


        public NSMInfo GetNSMSetupEditDataDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                NSMInfo master = new NSMInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_NSMInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.NSMId = (int)dr["NSMId"];
                    master.GroupId = (int)dr["GroupId"];
                    master.EmployeeId = (int)dr["EmployeeId"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.ActiveDateStr =  (dr["ActiveDateStr"].ToString());

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public NSMInfo GetNSMSetupEditDataByEmpIdDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                NSMInfo master = new NSMInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_NSMInfo_ByEMPId", aSqlParameters);
                while (dr.Read())
                {
                    master.NSMId = (int)dr["NSMId"];
                  
                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public UserRoleDao GetUserRoleEditDataDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                UserRoleDao master = new UserRoleDao();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_UserRoleInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.UserRoleID = (int)dr["UserRoleID"];
                    master.RoleTypeId = (int)dr["RoleTypeId"];
                    master.RoleName =  dr["RoleName"].ToString();
              
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.ActiveDateStr = (dr["ActiveDateStr"].ToString());

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public RSMInfo GeDZNSMSetupEditDataDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                RSMInfo master = new RSMInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_DZSMInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.RSMId = (int)dr["RSMId"];
                    master.GroupId = (int)dr["GroupId"];
                    master.RegionId = (int)dr["RegionId"];
                    master.EmployeeId = (int)dr["EmployeeId"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.ActiveDateStr = (dr["ActiveDateStr"].ToString());

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public RSMInfo GeDZSMSetupEditDataByEMPIDDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                RSMInfo master = new RSMInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_DZSMInfo_ByEmpId", aSqlParameters);
                while (dr.Read())
                {
                    master.RSMId = (int)dr["RSMId"];
                     

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public ASMInfo GeAMSetupEditDataDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ASMInfo master = new ASMInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_ASMInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.ASMId = (int)dr["ASMId"];
                    master.GroupId = (int)dr["GroupId"];
                    master.RegionId = (int)dr["RegionId"];
                    master.AreaId = (int)dr["AreaId"];
                    master.EmployeeId = (int)dr["EmployeeId"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.ActiveDateStr = (dr["ActiveDateStr"].ToString());

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetMIOetupEditDataByEmpId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_MIOInfo_ByEmpId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable GetAMSetupEditDataByEmpId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_ASMInfo_ByEmpId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable GetDZSMSetupEditDataByEmpId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_DZSMInfo_ByEmpId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable GetNSMSetupEditDataByEmpId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_NSMInfo_ByEMPId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public MIOInfo GeMIOetupEditDataDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                MIOInfo master = new MIOInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_MIOInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.MIOId = (int)dr["MIOId"];
                    master.GroupId = (int)dr["GroupId"];
                    master.RegionId = (int)dr["RegionId"];
                    master.AreaId = (int)dr["AreaId"];
                    master.TerritoryId = (int)dr["TerritoryId"];
                    master.EmployeeId = (int)dr["EmployeeId"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.ActiveDateStr = (dr["ActiveDateStr"].ToString());

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public MIOInfo GeMIOMasterDataByEmpIDDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                MIOInfo master = new MIOInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_MIOInfo_ByEmpId", aSqlParameters);
                while (dr.Read())
                {
                    master.MIOId = (int)dr["MIOId"];
                     

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public ASMInfo GAMMasterDataByEmpIDDAL(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ASMInfo master = new ASMInfo();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_ASMInfo_ByEmpId", aSqlParameters);
                while (dr.Read())
                {
                    master.ASMId = (int)dr["ASMId"];


                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable Get_NSMInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_NSMInfo", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
           public DataTable GetNSMHeadList(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_NSMHeadInfo", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_VacentGroup()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_GET_VacentGroup");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_ASMInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_ASMInfo", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public ResultInfo Inactive_ASMInfoById(int asmId, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ASMId", asmId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));

                if (asmId > 0)
                {
                    bool result = accessManager.UpdateData("sp_Update_ASMActiveStatus", gSqlParameterList);
                    pk = asmId;

                    if (result)
                    {
                        aInformation.isSuccess = true;
                    }
                }


            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable Get_RSMInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_RSMInfo",aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        

        public ResultInfo  Inactive_RSMInfoById(int rsmId, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@RSMId", rsmId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));

                if (rsmId > 0)
                {
                    bool result = accessManager.UpdateData("sp_Update_RSMActiveStatus", gSqlParameterList);
                    pk = rsmId;

                    if (result)
                    {
                        aInformation.isSuccess = true;
                    }
                }
               

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public ResultInfo  Save_RSMInfo(RSMInfo aRSMInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@RSMId", aRSMInfo.RSMId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aRSMInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@RegionId", aRSMInfo.RegionId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aRSMInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aRSMInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aRSMInfo.ActiveDate));

                if (aRSMInfo.RSMId > 0)
                {
                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@RegionId", aRSMInfo.RegionId));
                    aSqlprm.Add(new SqlParameter("@RSMId", aRSMInfo.RSMId));
                    DataTable dt = accessManager.GetDataTable("sp_check_RSMInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {


                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_RSMInfo", gSqlParameterList);
                        pk = aRSMInfo.RSMId;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {
                     
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_RSMInfo", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                        aInformation.isValiCheck = true;

                    }

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public ResultInfo Save_MIOInfo(MIOInfo aMIOInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MIOId", aMIOInfo.MIOId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aMIOInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@TerritoryId", aMIOInfo.TerritoryId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aMIOInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aMIOInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aMIOInfo.ActiveDate));

                if (aMIOInfo.MIOId > 0)
                {
                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@TerritoryId", aMIOInfo.TerritoryId));
                    aSqlprm.Add(new SqlParameter("@MIOId", aMIOInfo.MIOId));
                    DataTable dt = accessManager.GetDataTable("sp_check_MIOInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {


                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_MIOInfo", gSqlParameterList);
                        pk = aMIOInfo.MIOId;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {

                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MIOInfo", gSqlParameterList);
                }

                if (pk > 0)
                {
                   aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isValiCheck = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }



        public ResultInfo Insert_Update_MIOInfoDAL(MIOInfo aMIOInfo, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MIOId", aMIOInfo.MIOId));
                gSqlParameterList.Add(new SqlParameter("@CompanyId", aMIOInfo.CompanyId));
                gSqlParameterList.Add(new SqlParameter("@TerritoryId", aMIOInfo.TerritoryId));
                gSqlParameterList.Add(new SqlParameter("@EmployeeId", aMIOInfo.EmployeeId));
                gSqlParameterList.Add(new SqlParameter("@entryBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", aMIOInfo.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", aMIOInfo.ActiveDate));

                if (aMIOInfo.MIOId > 0)
                {
                    List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    aSqlprm.Add(new SqlParameter("@TerritoryId", aMIOInfo.TerritoryId));
                    aSqlprm.Add(new SqlParameter("@MIOId", aMIOInfo.MIOId));
                    DataTable dt = accessManager.GetDataTable("sp_check_MIOInfo", aSqlprm);
                    if (dt.Rows.Count == 0)
                    {
                        if (aMIOInfo.IsActive)
                        {
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_Insert_MIOInfo", gSqlParameterList);
                            pk = aMIOInfo.MIOId;
                        }
                        else
                        {
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_MIOInfo", gSqlParameterList);
                            pk = aMIOInfo.MIOId;
                        }

                       
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {

                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MIOInfo", gSqlParameterList);
                }

                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isValiCheck = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable Get_MIOInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_MIOInfo", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public ResultInfo Inactive_MIOInfoById(int mioId, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MIOId", mioId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));

                if (mioId > 0)
                {
                    bool result = accessManager.UpdateData("sp_Update_MIOActiveStatus", gSqlParameterList);
                    pk = mioId;

                    if (result)
                    {
                        aInformation.isSuccess = true;
                    }
                }


            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable Get_VacentRegion(int groupId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@GroupId", groupId));
                DataTable dt = accessManager.GetDataTable("sp_GET_VacentRegion", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_VacentArea(int zoneId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@RegionId", zoneId));
                DataTable dt = accessManager.GetDataTable("sp_GET_VacentArea", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_VacentTerritory(int areaId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@AreaId", areaId));
                DataTable dt = accessManager.GetDataTable("sp_GET_VacentTerritory", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
    }
}
