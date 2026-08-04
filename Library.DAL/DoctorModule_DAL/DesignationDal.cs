using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.DataLayer
{
    public class DesignationDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo Save_DesignationInfo(Designation employeeLeave, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", employeeLeave.DesignationId));
                gSqlParameterList.Add(new SqlParameter("@DesigName", employeeLeave.DesigName));

                gSqlParameterList.Add(new SqlParameter("@IsActive", employeeLeave.IsActive));

                if (employeeLeave.DesignationId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", employeeLeave.DesignationId));
                    aSqlParameterlist.Add(new SqlParameter("@DesigName", employeeLeave.DesigName));
                    DataTable dt = accessManager.GetDataTable("sp_check_Designation", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {

                        if (employeeLeave.IsActive == false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", employeeLeave.DesignationId));
                            aSqlprm.Add(new SqlParameter("@PageName", "Designation"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {
                                gSqlParameterList.Add(new SqlParameter("@UpdateBy", HttpContext.Current.Session["UserId"].ToString()
    ));
                                aInformation.isSuccess = accessManager.UpdateData("sp_UD_DesignationInfo", gSqlParameterList);
                                pk = employeeLeave.DesignationId;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;
                            }
                        }
                        else
                        { 
                            gSqlParameterList.Add(new SqlParameter("@UpdateBy", HttpContext.Current.Session["UserId"].ToString()
    ));
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_DesignationInfo", gSqlParameterList);
                        pk = employeeLeave.DesignationId;
                    }
                    }
                    else
                    {
                      
                        aInformation.isDuplicateCheck = true;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", HttpContext.Current.Session["UserId"].ToString()
));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DesignationInfo", gSqlParameterList);
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

        public DataTable GetDesignationList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_DesignationInfo",aSqlParameterlist);
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


        public ResultInfo ActiveInactive_DesignationInfo(Int32 DeleteId, int sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@DesignationId ", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                bool result = accessManager.DeleteData("sp_ActiveInactive_employeeDesignation_ById", gSqlParameterList);
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

        public Designation GetDesignationForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                Designation master = new Designation();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_DesignationInfo_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.DesignationId = (int)dr["DesignationId"];
                    master.DesigName = dr["DesigName"].ToString();                 
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

        public ResultInfo Delete_DesignationInfo(Int32 DeleteId)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@DesignationId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_DesignationInfo", gSqlParameterList);
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