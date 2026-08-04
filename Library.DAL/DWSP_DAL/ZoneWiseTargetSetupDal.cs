using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.DWSP_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.DWSP_DAL
{
   public class ZoneWiseTargetSetupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public ResultInfo SaveZoneWiseTarget(List<ZoneWiseTargetDao> _ZoneTarget, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                foreach (var item in _ZoneTarget)
                {
                    List<SqlParameter> aSQL = new List<SqlParameter>();
                    aSQL.Add(new SqlParameter("@ZoneWTSetupId", item.ZoneWTSetupId));
                    aSQL.Add(new SqlParameter("@Year", item.Year ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Month", item.Month ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@TargetAmount", item.TargetAmount ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Amount", item.Amount ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@EntryBy", sessionUser));

                    if (item.ZoneWTSetupId > 0)
                    {
                        aInformation.isSuccess = accessManager.SaveData("sp_Save_ZoneWiseTargetSetup", aSQL);
                    }
                    else
                    {
                        pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ZoneWiseTargetSetup", aSQL);

                        if (pk > 0)
                        {
                            aInformation.isSuccess = true;

                        }
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

        public DataTable Get_ZoneActive_All_ByGroup(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@GroupId", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_Zone_All_Active_ZoneTarget", aSqlParameterlist);
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
        public DataTable Get_AreaTargetAmount_All_ByZone(String month, String Year, String groupname)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@RegionId", groupname));
                aSqlParameterlist.Add(new SqlParameter("@month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));
                DataTable dt = accessManager.GetDataTable("sp_Get_ZoneTargetAmount", aSqlParameterlist);
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


        public DataTable Get_TerriTargetAmount_All_ByTeritoryId(String month, String Year, String groupname)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@RegionId", groupname));
                aSqlParameterlist.Add(new SqlParameter("@month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));
                DataTable dt = accessManager.GetDataTable("sp_Get_TerritoryWiseTargetSetup", aSqlParameterlist);
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

        public DataTable Get_FirstDate_LastDatebyYearMonth(String month, String Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>(); 
                if(Convert.ToInt32(month) >= 10)
                {
                    aSqlParameterlist.Add(new SqlParameter("@StartDate", Year +   month + "01"));

                    aSqlParameterlist.Add(new SqlParameter("@EndDate", Year +   month + "01"));
                }
                else
                {
                    aSqlParameterlist.Add(new SqlParameter("@StartDate", Year + "0" + month + "01"));

                    aSqlParameterlist.Add(new SqlParameter("@EndDate", Year + "0" + month + "01"));
                }
                
                DataTable dt = accessManager.GetDataTable("sp_Get_FirstDate_LastDatebyYearMonth", aSqlParameterlist);
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

        public DataTable GetDatewithinDateRange(String fDate, String tDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@fDate", fDate));
                aSqlParameterlist.Add(new SqlParameter("@tDate", tDate));
                DataTable dt = accessManager.GetDataTable("sp_GetDatewithinDateRange", aSqlParameterlist);
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

        public DataTable Get_TerriTargetAmount_All_ByArea(String month, String Year, String groupname)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@RegionId", groupname));
                aSqlParameterlist.Add(new SqlParameter("@month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));
                DataTable dt = accessManager.GetDataTable("sp_Get_AreaTargetAmount", aSqlParameterlist);
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
        public DataTable Get_NationalTargetAmount_All_ByGroup(String month , String Year, String groupname)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@GroupId", groupname));
                aSqlParameterlist.Add(new SqlParameter("@month", month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));
                DataTable dt = accessManager.GetDataTable("sp_Get_NationalTargetAmount", aSqlParameterlist);
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
        public DataTable Get_SaveDataAll(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter",param));
                DataTable dt = accessManager.GetDataTable("sp_Get_ZoneWiseTargetList",aSqlParameterlist);
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
