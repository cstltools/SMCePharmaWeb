using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.MasterSetup_DAL
{
    public class TourSetupForEmployeeDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public DataTable GetList(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_TourSetupEmployeeList", aSqlParameterlist);
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

        public int SaveDAInfo(TourTypeSetupDAO aDao)
        {
            int pk = 0;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> gSqlParameterUpdate = new List<SqlParameter>();

                gSqlParameterList.Add(new SqlParameter("@IsRoleWise", aDao.IsRoleWise ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsEmployeeWise", aDao.IsEmployeeWise ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@StationTypeId", aDao.StationTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpInfoId", aDao.EmpInfoId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RoleTypeId", aDao.RoleTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CountNo", aDao.CountNo ?? (object)DBNull.Value));

                if (aDao.TourSetupEmployeeId > 0)
                {
                    gSqlParameterUpdate.Add(new SqlParameter("@TourSetupEmployeeId", aDao.TourSetupEmployeeId));
                    gSqlParameterUpdate.Add(new SqlParameter("@UpdateBy", aDao.UpdateBy));
                    gSqlParameterUpdate.Add(new SqlParameter("@UpdateDate", aDao.UpdateDate));
                    gSqlParameterUpdate.Add(new SqlParameter("@CountNo", aDao.CountNo ?? (object)DBNull.Value));


                  accessManager.UpdateData("sp_Update_TourSetupEmployee", gSqlParameterUpdate);
                    pk = aDao.TourSetupEmployeeId;
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", aDao.EntryBy));
                    gSqlParameterList.Add(new SqlParameter("@EntryDate", aDao.EntryDate));

                    DataTable dt = new DataTable();
                    if (aDao.IsEmployeeWise == true)
                    {
                        List<SqlParameter> gqData = new List<SqlParameter>();
                        gqData.Add(new SqlParameter("@EmpInfoId", aDao.EmpInfoId ?? (object)DBNull.Value));

                          dt = accessManager.GetDataTable("sp_Check_TourSetupEmployeeList", gqData);
                    }
                    else
                    {
                        List<SqlParameter> gqData = new List<SqlParameter>();
                        gqData.Add(new SqlParameter("@RoleTypeId", aDao.RoleTypeId ?? (object)DBNull.Value));


                        dt = accessManager.GetDataTable("sp_Check_TourSetupEmployeeListRoleType", gqData);
                    }
                   

                    if (dt.Rows.Count == 0)
                    {
                        pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TourSetupEmployee", gSqlParameterList);

                    }
                    else
                    {
                        pk = 0;
                    }

                }
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return pk;
        }

        public DataTable GetDAInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_DAInfo", aSqlParameterlist);
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

        public DataTable GetDAInfoById(int daId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@Parameter", daId));
                DataTable dt = accessManager.GetDataTable("sp_GET_DAInfoById", aSqlParameterlist);
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

    }
}
