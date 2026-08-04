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
    public class AreaWiseTargetSetupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public ResultInfo SaveZoneWiseTarget(List<AreaWiseTargetSetupDao> _ZoneTarget, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                foreach (var item in _ZoneTarget)
                {
                    List<SqlParameter> aSQL = new List<SqlParameter>();
                    aSQL.Add(new SqlParameter("@AreaWTSetupId", item.AreaWTSetupId));
                    aSQL.Add(new SqlParameter("@Year", item.Year ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Month", item.Month ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@TargetAmount", item.TargetAmount ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Amount", item.Amount ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@EntryBy", sessionUser));

                    aInformation.isSuccess = accessManager.SaveData("sp_Save_AreaWiseTargetSetup", aSQL);
                    
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

        public ResultInfo SaveTerritoryWiseTarget(List<TerritoryTargetSetupDao> _ZoneTarget, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                foreach (var item in _ZoneTarget)
                {
                    List<SqlParameter> aSQL = new List<SqlParameter>();
                    aSQL.Add(new SqlParameter("@TerritoryWTSetupId", item.TerritoryWTSetupId));
                    aSQL.Add(new SqlParameter("@Year", item.Year ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Month", item.Month ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@TargetAmount", item.TargetAmount ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value)); 
                    aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Amount", item.Amount ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@EntryBy", sessionUser));

                    aInformation.isSuccess = accessManager.SaveData("sp_Save_TerritoryWiseTargetSetup", aSQL);

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


        public ResultInfo Save_DWSPMaster(List<TerritoryTargetSetupDao> _ZoneTarget, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                foreach (var item in _ZoneTarget)
                { 
                    List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                    gSqlParameterList.Add(new SqlParameter("@DWSPDate", item.DWSPDate ?? (object)DBNull.Value ?? (object)DBNull.Value));
                    gSqlParameterList.Add(new SqlParameter("@empId", item.EmpInfoId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                    gSqlParameterList.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                    gSqlParameterList.Add(new SqlParameter("@FCBAmount", item.FCBAmount ?? (object)DBNull.Value ?? (object)DBNull.Value));
                    gSqlParameterList.Add(new SqlParameter("@CampaignAmount", item.CampaignAmount ?? (object)DBNull.Value ?? (object)DBNull.Value));
                    gSqlParameterList.Add(new SqlParameter("@GeneralAmount", item.GeneralAmount ?? (object)DBNull.Value ?? (object)DBNull.Value));

                    aInformation.isSuccess = accessManager.SaveData("sp_Save_DWSPMaster", gSqlParameterList);

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

        public DataTable Get_SaveDataAll(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_AreaWiseTargetList", aSqlParameterlist);
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

        public DataTable Get_TerritoryDataAll(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_TerritoryWiseTargetList", aSqlParameterlist);
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
