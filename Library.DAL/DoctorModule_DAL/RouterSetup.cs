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
    public class RouterSetup
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo Save_RouterSetup(RouterMaster router, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", router.RouterMasterId));
                gSqlParameterList.Add(new SqlParameter("@RouterName ", router.RouterName));
            
                if (router.RouterMasterId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", router.RouterMasterId));
                    aSqlParameterlist.Add(new SqlParameter("@RouterName", router.RouterName));
                    DataTable dt = accessManager.GetDataTable("sp_check_RouterMaster", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_Update_RouterMaster", gSqlParameterList);
                        pk = router.RouterMasterId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_RouterMaster", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
              
                }

                if (pk> 0 && aInformation.isSuccess == true)
                {
                    foreach (var item in router.RouterDetails)
                    {
                        RouterDetails ADetailDao = new RouterDetails();
                        ADetailDao.RouterMasterId = pk;
                        ADetailDao.TerritoryId = item.TerritoryId;
                        ADetailDao.MarketId = item.MarketId;
                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@id", ADetailDao.RouterDetailsId));
                        aSQL.Add(new SqlParameter("@RouterMasterId",ADetailDao.RouterMasterId ));
                        aSQL.Add(new SqlParameter("@TerritoryId ", ADetailDao.TerritoryId));
                        aSQL.Add(new SqlParameter("@MarketId ", ADetailDao.MarketId));
                        aInformation.isSuccess = accessManager.SaveData("sp_Save_RouterDetails", aSQL);
       
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

        public DataTable GetRouterMasterList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_RouterMasterInfo", aSqlParameterlist);
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

        public RouterMaster GetRouterMasterForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                RouterMaster master = new RouterMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_RouterMaster_ByRouterMasterId", aSqlParameters);
                while (dr.Read())
                {
                    master.RouterMasterId = (int)dr["RouterMasterId"];
                    master.RouterName = dr["RouterName"].ToString();
                 
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

        public DataTable GetMarketByTerriTory()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
             
                DataTable dt = accessManager.GetDataTable("sp_Get_MarketByTerriTory", aSqlParameters);
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

        public DataTable GetMarketByTerriToryById(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_MarketByTerriTory_ByRouterMasterId", aSqlParameters);
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