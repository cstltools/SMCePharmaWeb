using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;

namespace SalesSolution.Web.DataLayer
{
    public class HolidayDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();


        public DataTable GetFinancialYear()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                
                DataTable dt = accessManager.GetDataTable("sp_Get_FinanCialyearforDDL");
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
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetFinanCialyear()
        {
            string query = @"SELECT FiscalYearId, FiscalYearDesc FROM tblFiscalYearInfos WITH (NOLOCK) WHERE IsActive=1";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public ResultInfo Save_LeaveInfo(Holiday holiday, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@HolidayId", holiday.HolidayId));
                gSqlParameterList.Add(new SqlParameter("@FiscalYear", holiday.FiscalYear));
                gSqlParameterList.Add(new SqlParameter("@DayName", holiday.DayName));
                gSqlParameterList.Add(new SqlParameter("@HolidayDate", holiday.HolidayDate));
                gSqlParameterList.Add(new SqlParameter("@HolidayToDate", holiday.HolidayToDate));
                gSqlParameterList.Add(new SqlParameter("@IsActive", holiday.IsActive));

                if (holiday.HolidayId > 0)
                {
                 
                    aSqlParameterList.Add(new SqlParameter("@id", holiday.HolidayId));
                    aSqlParameterList.Add(new SqlParameter("@Name", holiday.DayName));
                    DataTable dt = accessManager.GetDataTable("sp_check_Holiday", aSqlParameterList);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_Update_Employee_Holiday", gSqlParameterList);
                        pk = holiday.HolidayId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_Employee_Holiday", gSqlParameterList);
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



        public DataTable GetHolydayList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                //aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_Get_Holidaylist");
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



        public ResultInfo ActiveInactive_emplopyeeleave(Int32 DeleteId, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@HolidayId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                bool result = accessManager.DeleteData("sp_ActiveInactive_Holiday", gSqlParameterList);
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


        public Holiday GetholidayForEdit(int id)
        {
            try


            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                Holiday master = new Holiday();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_HolidayInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    try
                    {
                        master.HolidayId = (int)dr["HolidayId"];
                        try
                        {
                            master.FiscalYear = (int)dr["FiscalYear"];
                        }
                        catch { }
                        master.DayName = dr["DayName"].ToString();
                        master.HolidayDate = (DateTime)dr["HolidayDate"];
                        try
                        {
                            master.HolidayToDate = (DateTime)dr["HolidayToDate"];
                        }
                        catch { }
                        master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    }
                    catch
                    {

                    }
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


        public ResultInfo Delete_holiday(Int32 DeleteId)
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