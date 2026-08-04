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
    public class FinancialYearDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo Save_DepartmentInfo(FinancialYear employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.FiscalYearId));
             
                gSqlParameterList.Add(new SqlParameter("@YearFromDate", employeeLeave.YearFromDate));
                gSqlParameterList.Add(new SqlParameter("@YearTodate", employeeLeave.YearTodate));
                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));

                if (employeeLeave.FiscalYearId > 0)
                {
                    //aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.FiscalYearId));
                    //aSqlParameterlist.Add(new SqlParameter("@FiscalYearDesc", employeeLeave.FiscalYearDesc));
                    //DataTable dt = accessManager.GetDataTable("sp_check_FinancialYear", aSqlParameterlist);
                    //if (dt.Rows.Count == 0)
                    //{
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_FinancialYearInfo", gSqlParameterList);
                        pk = employeeLeave.FiscalYearId;
                    //}
                    //else
                    //{
                    //    aInformation.isSuccess = false;
                    //}
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_FinancialYearInfo", gSqlParameterList);
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


        //public DataTable GetFinancialYearList(string Param)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
        //        DataTable dt = accessManager.GetDataTable("sp_GET_DepartmentInfo", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}



        public DataTable GetDepartmentList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_FinancialInfo", aSqlParameterlist);
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



        public ResultInfo ActiveInactive_FinancialYearInfo(Int32 DeleteId, int sessionUser)
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
                bool result = accessManager.DeleteData("sp_ActiveInactive_FinancialYear", gSqlParameterList);
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


        public FinancialYear GetFinancialYearForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                FinancialYear master = new FinancialYear();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_financialYear_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.FiscalYearId = (int)dr["FiscalYearId"];
                    master.FiscalYearDesc = dr["FiscalYearDesc"].ToString();
                    master.YearFromDateStr =  dr["YearFromDate"].ToString();
                    master.YearTodateStr =  dr["YearTodate"].ToString();
                    try
                    {
                        master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    }
                    catch(Exception ex)
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




        public DataTable GetFinancialYearList( string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", param));
                DataTable dt = accessManager.GetDataTable("sp_GET_FinancialInfo");
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