using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace Library.DAL.MasterSetup_DAL
{
   public class LeaveApplicationDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public DataTable GetEmployeeLeaveBalanceByCode(string employeeCode)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                string pram = "";

                if (employeeCode != "")
                {
                    pram = pram + " AND EGI.EmpMasterCode = '" + employeeCode + "'";


                }

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", pram));
                DataTable dt = accessManager.GetDataTable("sp_GET_EmployeeLeaveBalance", aSqlParameterlist);
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

        public DataTable GetApplicationInfoById(int leaveApplicationId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                string pram = "";

                if (leaveApplicationId > 0)
                {
                    pram = pram + " AND LVAP.LeaveApplicationId = '" + leaveApplicationId + "'";
                }

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", pram));
                DataTable dt = accessManager.GetDataTable("sp_GET_LeaveApplicationInfoById", aSqlParameterlist);
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
        public bool IsEditable(int id)
        {
            bool result = true;
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Webapi_Get_LeaveApproveById", gSqlParameterList);
                if (dr.HasRows)
                {
                    result = false;
                }




            }
            catch (Exception ex)
            {

            }

            finally
            {
                accessManager.SqlConnectionClose();
            }

            return result;

        }
        public ResultInfo SaveLeaveApplication(LeaveApplication aInfo)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                bool isOKtoSubmit = true;

                if (aInfo.LeaveApplicationId > 0)
                {
                    isOKtoSubmit = IsEditable(aInfo.LeaveApplicationId);

                }


                if (isOKtoSubmit)
                {
                    accessManager.SqlConnectionOpen(DataBase.SalesDB);
                    List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                    DateTime entryDtae = DateTime.Now;
                    gSqlParameterList.Add(new SqlParameter("@leaveAppId", aInfo.LeaveApplicationId));
                    gSqlParameterList.Add(new SqlParameter("@typeId", aInfo.LeaveBalanceId));
                    gSqlParameterList.Add(new SqlParameter("@startDate", aInfo.StartDate));
                    gSqlParameterList.Add(new SqlParameter("@endDate", aInfo.EndDate));
                    gSqlParameterList.Add(new SqlParameter("@reason", aInfo.Reason));
                    gSqlParameterList.Add(new SqlParameter("@empId", aInfo.EmpId));
                    aInformation.isSuccess = accessManager.SaveData("sp_Webapi_Save_LeaveInfo", gSqlParameterList);

                }
                else
                {
                    aInformation.isSuccess = false;
                    aInformation.ErrorMessage = "The leave has already been approved. Can't edit right now";
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
        
             
        


    public ResultInfo ApproveLeaveApplication(int leaveApplicationId, string approvalStatus)
        {

            ResultInfo aInformation = new ResultInfo();
            try
            {



                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@id", leaveApplicationId));
                gSqlParameterList.Add(new SqlParameter("@approvalType", approvalStatus));
                gSqlParameterList.Add(new SqlParameter("@empId", HttpContext.Current.Session["UserId"].ToString()));
                aInformation.isSuccess = accessManager.UpdateData("sp_Webapi_Update_LeaveData", gSqlParameterList);




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




        public DataTable GetAllLeaveRecords(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_Get_AllLeaveRecords", aSqlParameterlist);
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