
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
    public class DepartmentDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo Save_DepartmentInfo(Department employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.DeptId));
                gSqlParameterList.Add(new SqlParameter("@DepartmentName", employeeLeave.DeptName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));

                if (employeeLeave.DeptId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.DeptId));
                    aSqlParameterlist.Add(new SqlParameter("@DepartmentName", employeeLeave.DeptName));
                    DataTable dt = accessManager.GetDataTable("sp_check_Department", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {

                        if (employeeLeave.IsActive == false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", employeeLeave.DeptId));
                            aSqlprm.Add(new SqlParameter("@PageName", "Dept"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {
                                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                                aInformation.isSuccess = accessManager.UpdateData("sp_UD_DepartmentInfo", gSqlParameterList);
                                pk = employeeLeave.DeptId;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;
                            }
                        }
                        else
                        {
                            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_DepartmentInfo", gSqlParameterList);
                            pk = employeeLeave.DeptId;
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
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DepartmentInfo", gSqlParameterList);
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
                gSqlParameterList.Add(new SqlParameter("@DeptId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                bool result = accessManager.DeleteData("sp_ActiveInactive_Department", gSqlParameterList);
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


        public Department GetEmployeeLeaveForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                Department master = new Department();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_DepartmentInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.DeptId = (int)dr["DeptId"];
                    master.DeptName = dr["DeptName"].ToString();              
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
                gSqlParameterList.Add(new SqlParameter("@DeptId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_DepartmnetInfo", gSqlParameterList);
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