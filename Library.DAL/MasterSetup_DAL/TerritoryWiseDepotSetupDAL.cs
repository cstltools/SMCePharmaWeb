using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.MasterSetup_DAL
{
  public  class TerritoryWiseDepotSetupDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo SaveRouteMarketDetailByTerritory(int routeId, List<int> territoryIds, string sessionUser)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<DataRow> allMarkets = new List<DataRow>();
                foreach (int terrId in territoryIds)
                {
                    List<SqlParameter> p = new List<SqlParameter>();
                    p.Add(new SqlParameter("@id", terrId));
                    DataTable dtMarkets = accessManager.GetDataTable("sp_CS_GetMarket_ByTerritoryId_ActiveNew", p);

                    if (dtMarkets != null && dtMarkets.Rows.Count > 0)
                    {
                        foreach (DataRow row in dtMarkets.Rows)
                        {
                            allMarkets.Add(row);
                        }
                    }
                }

                foreach (DataRow row in allMarkets)
                {
                    List<SqlParameter> aSQL = new List<SqlParameter>();
                    aSQL.Add(new SqlParameter("@RouteInformationMasterId", routeId));
                    aSQL.Add(new SqlParameter("@GroupId", row["GroupId"] ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@RegionId", row["RegionId"] ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@AreaId", row["AreaId"] ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@TerritoryId", row["TerritoryId"] ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@SubTerritoryId", row["SubTerritoryId"] ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@MarketId", row["MarketId"] ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Distance", 0));

                    aInformation.isSuccess = accessManager.SaveData("sp_Save_RouteMarketDetail_TerritoryWise", aSQL);
                }
                aInformation.isSuccess = true;
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
            return aInformation;
        }

        public DataTable GetRouteListByDepot(string DCId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> paramList = new List<SqlParameter>();
                paramList.Add(new SqlParameter("@DCId", DCId));
                DataTable dt = accessManager.GetDataTableByText("SELECT distinct RouteInformationMasterId, RouteName FROM tblRouteInformationMaster where RouteInformationMasterId in (SELECT RouteInformationMasterId FROM [dbo].[tblRouteInformationMarketDetail] WITH (NOLOCK)  )  and  DCId = @DCId ORDER BY RouteName asc", paramList);
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
        public ResultInfo SaveBonusCampaign(DcWiseTerritoryMasterDAO master,   List<DcWiseTerritoryDetailDAO> _CamCustomerDtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@DcWiseTerritoryMasterId", master.DcWiseTerritoryMasterId));
                gSqlParameterList.Add(new SqlParameter("@DCId", master.DCId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@SubDepotId", master.SubDepotId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@GroupId", master.GroupId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@RegionId", master.RegionId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@AreaId", master.AreaId ?? (object)DBNull.Value));
            

                if (master.DcWiseTerritoryMasterId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_DcWiseTerritoryMaster", gSqlParameterList);

                    pk = master.DcWiseTerritoryMasterId;

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DcWiseTerritoryMaster", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;

                    }
                }

                if (pk > 0)
                {
                    foreach (var item in _CamCustomerDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@DcWiseTerritoryMasterId", pk));

                        aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                        
                        aInformation.isSuccess = accessManager.SaveData("sp_Save_DcWiseTerritoryDetail", aSQL);

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

        public DataTable GetDAInfo(string parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_TerritoryWiseDepotSetupList", aSqlParameterlist);
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

        public DataTable GetSetupDetailById(string DCId,string SubDepotId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@DCId", DCId));
                aSqlParameterlist.Add(new SqlParameter("@SubDepotId", SubDepotId));

                DataTable dt = accessManager.GetDataTable("sp_GET_lDcWiseTerritoryDetail_ByAreaId", aSqlParameterlist);
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
