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
  public  class CustomerTypeDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo Save_DepartmentInfo(CustomerType employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.CustomerTypeId));
                gSqlParameterList.Add(new SqlParameter("@CustomerType", employeeLeave.CustomerTypee));
                gSqlParameterList.Add(new SqlParameter("@CustomerCategoryId", employeeLeave.CustomerCategoryId));

                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));

                gSqlParameterList.Add(new SqlParameter("@IsCampaign", employeeLeave.IsCampaign));
                gSqlParameterList.Add(new SqlParameter("@IsDefault", employeeLeave.IsDefault));
                //gSqlParameterList.Add(new SqlParameter("@IsTradeDiscount", employeeLeave.IsTradeDiscount));
                //gSqlParameterList.Add(new SqlParameter("@IsFixedDiscount", employeeLeave.IsFixedDiscount));


                if (employeeLeave.CustomerTypeId > 0)
                {
                    //
                    aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.CustomerTypeId));
                    aSqlParameterlist.Add(new SqlParameter("@CustomerType", employeeLeave.CustomerTypee));
                    DataTable dt = accessManager.GetDataTable("sp_check_CustomerType", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        List<SqlParameter> asqDef = new List<SqlParameter>();

                        asqDef.Add(new SqlParameter("@id", employeeLeave.CustomerTypeId));
                     
                        DataTable dtCheckIsDefault = accessManager.GetDataTable("sp_checkIsDefault_CustomerType", asqDef);

                        if (dt.Rows.Count == 0)
                        {
                            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_CustomerTypeInfo", gSqlParameterList);
                            pk = employeeLeave.CustomerTypeId;
                        }
                  
                    else
                    {
                        aInformation.isValiCheck = true;

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
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_CustomerTypeInfo", gSqlParameterList);
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
                DataTable dt = accessManager.GetDataTable("sp_GET_CustomerInfo", aSqlParameterlist);
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
                gSqlParameterList.Add(new SqlParameter("@CustomerTypeId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                bool result = accessManager.DeleteData("sp_ActiveInactive_customerType_ById", gSqlParameterList);
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


        public CustomerType GetEmployeeLeaveForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                CustomerType master = new CustomerType();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_CustomerType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.CustomerTypeId = (int)dr["CustomerTypeId"];
                    try
                    {
                        master.CustomerCategoryId = (int)dr["CustomerCategoryId"];
                    }
                    catch { master.CustomerCategoryId = 0; }
                    master.CustomerTypee = dr["CustomerType"].ToString();
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());

                    if (dr["IsCampaign"] != DBNull.Value)
                    {
                        master.IsCampaign = Convert.ToBoolean(dr["IsCampaign"].ToString());


                    }
                    if (dr["IsDefault"] != DBNull.Value)
                    {
                        master.IsDefault = Convert.ToBoolean(dr["IsDefault"].ToString());


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