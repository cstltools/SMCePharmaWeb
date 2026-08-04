
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;

namespace SalesSolution.Web.Controllers
{
    public class GroupSetupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public DataTable GetGroupSetupList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", ""));
                //aSqlParameterlist.Add(new SqlParameter("@ToDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_GET_GroupList", aSqlParameterlist);
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
        
        public DataTable GetNationalSetupList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", ""));
                //aSqlParameterlist.Add(new SqlParameter("@ToDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_GET_NationalList", aSqlParameterlist);
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

        public ResultInfo Save_DepartmentInfo(GroupSetup employeeLeave, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();

            try
            {

                aInformation.isValiCheck = false;
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.GroupId));
                gSqlParameterList.Add(new SqlParameter("@NationalId", employeeLeave.NationalId));
                gSqlParameterList.Add(new SqlParameter("@GroupName", employeeLeave.GroupName));
                gSqlParameterList.Add(new SqlParameter("@CodeStr", employeeLeave.CodeStr));
                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));

                if (employeeLeave.GroupId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.GroupId));
                    aSqlParameterlist.Add(new SqlParameter("@Name", employeeLeave.GroupName));
                    DataTable dt = accessManager.GetDataTable("sp_check_GroupInfo", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));

                        if (employeeLeave.IsActive==false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", employeeLeave.GroupId));
                            aSqlprm.Add(new SqlParameter("@PageName", "Group"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {
                                aInformation.isSuccess = accessManager.UpdateData("sp_UD_GroupInfo", gSqlParameterList);
                                pk = employeeLeave.GroupId;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;
                            }
                            }
                        else
                        {
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_GroupInfo", gSqlParameterList);
                            pk = employeeLeave.GroupId;
                        }

                        
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_GroupInfo", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;

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



        public DataTable GetDepartmentList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_DepartmentInfo", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }



        public ResultInfo ActiveInactive_DepartmentInfo(Int32 DeleteId, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@Id", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                bool result = accessManager.DeleteData("sp_ActiveInactive_GroupInfo", gSqlParameterList);
                pk = DeleteId;
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
                aInformation.isSuccess = true;
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }


        public GroupSetup GetEmployeeLeaveForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                GroupSetup master = new GroupSetup();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_GroupInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.GroupId = (int)dr["GroupId"];
                    master.GroupName = dr["GroupName"].ToString();
                    master.GroupCode = dr["GroupCode"].ToString();
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());

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


        public ResultInfo Delete_employeeleave(Int32 DeleteId)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@Id", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_GroupInfo", gSqlParameterList);
                pk = DeleteId;
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
                aInformation.isSuccess = true;
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

    }
}