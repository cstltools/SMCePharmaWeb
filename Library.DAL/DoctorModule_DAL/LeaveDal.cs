
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;

namespace SalesSolution.Web.DataLayer
{
    public class LeaveDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo Save_LeaveInfo( EmployeeLeave employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@LeaveTypeId", employeeLeave.LeaveTypeId));
                gSqlParameterList.Add(new SqlParameter("@LeaveTypeName", employeeLeave.LeaveTypeName));
                gSqlParameterList.Add(new SqlParameter("@LeaveDays", employeeLeave.LeaveDays));        
                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));
      
                if (employeeLeave.LeaveTypeId > 0)
                {                  
                    aSqlParameterList.Add(new SqlParameter("@id", employeeLeave.LeaveTypeId));
                    aSqlParameterList.Add(new SqlParameter("@Name", employeeLeave.LeaveTypeName));
                    DataTable dt = accessManager.GetDataTable("sp_check_LeaveInfo", aSqlParameterList);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_Update_Employee_Leave_info", gSqlParameterList);
                        pk = employeeLeave.LeaveTypeId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_Employe_LeaveType_Infos", gSqlParameterList);
                    if (pk > 0)
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



        public DataTable GetLeaveList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                //aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_Get_Leavelist");
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



        public DataTable GetLeaveConfigList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                //aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_Get_LeaveConfigList");
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





        public ResultInfo ActiveInactive_emplopyeeleave(Int32 DeleteId , int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try 
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@LeaveTypeId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                bool result = accessManager.DeleteData("sp_ActiveInactive_Transport", gSqlParameterList);
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


        public EmployeeLeave GetEmployeeLeaveForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                EmployeeLeave master = new EmployeeLeave();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_EmployeeLeaveIinfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.LeaveTypeId = (int)dr["LeaveTypeId"];
                    master.LeaveTypeName = dr["LeaveTypeName"].ToString();
                    master.LeaveDays = (int)dr["LeaveDays"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());

                    master.EMPEntryBy = dr["EMPEntryBy"].ToString();
                    master.EMPUpdateBy = dr["EMPUpdateBy"].ToString();

                    master.EntryDatee = dr["EntryDatee"].ToString();

                    master.UpdateDatee = dr["UpdateDatee"].ToString();

                    master.EMPActiveInactiveBy = dr["EMPActiveInactiveBy"].ToString();

                    master.InactiveDatee = dr["InactiveDatee"].ToString();

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
                gSqlParameterList.Add(new SqlParameter("@LeaveTypeId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_Employee_LeaveInfo", gSqlParameterList);
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