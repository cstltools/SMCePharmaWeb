using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.MasterSetup_DAL
{
   public class ProgramDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo Save_DepartmentInfo(ProgramType employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.ProgramTypeId));
                gSqlParameterList.Add(new SqlParameter("@ProgramTypeName", employeeLeave.ProgramTypeName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));
                gSqlParameterList.Add(new SqlParameter("@IsCustomer", employeeLeave.IsCustomer));
                gSqlParameterList.Add(new SqlParameter("@IsDoctor", employeeLeave.IsDoctor));
                gSqlParameterList.Add(new SqlParameter("@IsDefault", employeeLeave.IsDefault));
                if (employeeLeave.ProgramTypeId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.ProgramTypeId));
                    aSqlParameterlist.Add(new SqlParameter("@ProgramTypeName", employeeLeave.ProgramTypeName));
                    DataTable dt = accessManager.GetDataTable("sp_check_Programtype", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_ProgramTypeInfo", gSqlParameterList);
                        pk = employeeLeave.ProgramTypeId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }


                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ProgramTypeInfo", gSqlParameterList);
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

        public ResultInfo Save_SMCTypeInfo(SMCTypeDAO employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.SMCTypeId));
                gSqlParameterList.Add(new SqlParameter("@SMCType", employeeLeave.SMCType));
                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));
                gSqlParameterList.Add(new SqlParameter("@IsCustomer", employeeLeave.forCustomer));
                gSqlParameterList.Add(new SqlParameter("@IsDoctor", employeeLeave.forDotor));
                gSqlParameterList.Add(new SqlParameter("@IsDefault", employeeLeave.IsDefault));
                if (employeeLeave.SMCTypeId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.SMCTypeId));
                    aSqlParameterlist.Add(new SqlParameter("@ProgramTypeName", employeeLeave.SMCType));
                    DataTable dt = accessManager.GetDataTable("sp_check_SMCtype", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_SMCTypeInfo", gSqlParameterList);
                        pk = employeeLeave.SMCTypeId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }


                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_SMCTypeInfo", gSqlParameterList);
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


        public DataTable GetDepartmentList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_ProgramtypeInfo", aSqlParameterlist);
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



        public DataTable GetSMCTypeList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_SMCtypeInfo", aSqlParameterlist);
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
                bool result = accessManager.DeleteData("sp_ActiveInactive_Programtype", gSqlParameterList);
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


        public ProgramType GetEmployeeLeaveForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ProgramType master = new ProgramType();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_ProgramType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.ProgramTypeId = (int)dr["ProgramTypeId"];
                    master.ProgramTypeName = dr["ProgramTypeName"].ToString();
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.IsCustomer = Convert.ToBoolean(dr["IsCustomer"].ToString());
                    master.IsDoctor = Convert.ToBoolean(dr["IsDoctor"].ToString());
                    master.IsDefault = Convert.ToBoolean(dr["IsDefault"].ToString());
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

        public SMCTypeDAO GetSMCTypeEditData(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                SMCTypeDAO master = new SMCTypeDAO();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_SMCType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.SMCTypeId = (int)dr["SMCTypeId"];
                    master.SMCType = dr["SMCType"].ToString();
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    master.forCustomer = Convert.ToBoolean(dr["forCustomer"].ToString());
                    master.forDotor = Convert.ToBoolean(dr["forDotor"].ToString());
                    master.IsDefault = Convert.ToBoolean(dr["IsDefault"].ToString());
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