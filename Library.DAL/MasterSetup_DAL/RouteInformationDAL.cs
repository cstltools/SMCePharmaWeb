using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace Library.DAL.MasterSetup_DAL
{
 public   class RouteInformationDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public DataTable GetDANameDDL(int depoId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@depoId", depoId));

                DataTable dt = accessManager.GetDataTable("sp_Get_DDLDANameByDCID", aSqlParameterlist);
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


        public DataTable GetRouteInformationList(String parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));

                DataTable dt = accessManager.GetDataTable("sp_Get_RouteInformationMasterList", aSqlParameterlist);
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

        public DataTable GetDANameList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                 
                DataTable dt = accessManager.GetDataTable("sp_Get_DDLDAName");
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

        public DataTable GetRouteTypeInfoList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_RouteTypeInfo");
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
        public DataTable GetWeekNameList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_WeekNameInfo");
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

        public ResultInfo SaveRouteInformation(RouteInformationMasterDAO master, List<RouteInformationDADetailDAO> _Dtls, List<BonusCampaignMarketDetailDAO> _MarketDtls, string RouteDayArray, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@RouteInformationMasterId", master.RouteInformationMasterId));
                gSqlParameterList.Add(new SqlParameter("@DCId", master.DCId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsSubDepo", master.IsSubDepo ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RouteName", master.RouteName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TotalDay", master.TotalDay ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@TotalDistance", master.TotalDistance ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@RouteTypeId", master.RouteTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TAAmount", master.TAAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DAAmount", master.DAAmount ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));

                if (master.RouteInformationMasterId > 0)
                {
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    aSqlParameterlist.Add(new SqlParameter("@id", master.RouteInformationMasterId));
                    aSqlParameterlist.Add(new SqlParameter("@Name", master.MarketIdStr));
                    aSqlParameterlist.Add(new SqlParameter("@Status", "Update"));
                    DataTable dt = accessManager.GetDataTable("sp_check_RouteInformationMArket", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_RouteInformationMaster", gSqlParameterList);

                        pk = master.RouteInformationMasterId;
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;

                    }

                }
                else
                {
                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                    aSqlParameterlist.Add(new SqlParameter("@id", 1));
                    aSqlParameterlist.Add(new SqlParameter("@Name", master.MarketIdStr));
                    aSqlParameterlist.Add(new SqlParameter("@Status", "Entry"));
                    DataTable dt = accessManager.GetDataTable("sp_check_RouteInformationMArket", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_RouteInformationMaster", gSqlParameterList);

                        if (pk > 0)
                        {
                            aInformation.isSuccess = true;
                        }
                        else
                        {
                            aInformation.isDuplicateCheck = true;

                        }
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                   
                }

                if (pk > 0)
                {
                    foreach (var item in _Dtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@RouteInformationMasterId", pk));
                        aSQL.Add(new SqlParameter("@DAId", item.DAId ?? (object)DBNull.Value));
                       
                        aInformation.isSuccess = accessManager.SaveData("sp_Save_RouteInformationDADetail", aSQL);

                    }

                    foreach (var item in _MarketDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@RouteInformationMasterId", pk));
                        aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@SubTerritoryId", item.SubTerritoryId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketId", item.MarketId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@Distance", item.Distance?? (object)DBNull.Value));

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_RouteInformationMarketDetail", aSQL);

                    }

                    if (RouteDayArray != "")
                    {
                        string[] SpecialityList = RouteDayArray.Split(',');

                        foreach (String item in SpecialityList)
                        {
                            if (item != "")
                            {
                                List<SqlParameter> aSQL = new List<SqlParameter>();
                                aSQL.Add(new SqlParameter("@RouteInformationMasterId", pk));
                                aSQL.Add(new SqlParameter("@WeekNameId", item ?? (object)DBNull.Value));
                                aInformation.isSuccess = accessManager.SaveData("sp_Save_RouteInformationWeekNameDetails", aSQL);
                            }
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



        public DataTable GetRouteInformationMasterById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_RouteInformationMaster_ById", aSqlParameterlist);
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


        public DataTable GeteRouteInformationDA_DetailById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_RouteInformationDADetail_ById", aSqlParameterlist);
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
        
        public DataTable GeteRouteInformationDA_DDLId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_RouteInformationDADetailDDL", aSqlParameterlist);
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
        public DataTable GetforPaymentRouteInformationDA_DDLId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_RouteInformationDADetailDDL", aSqlParameterlist);
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
        public DataTable GetTerritoryByRouteInformationDA_DDLId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_TerritoryByRouteInformationDDL", aSqlParameterlist);
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
        public DataTable GetDelTerritoryByRouteInformationDA_DDLId(string Id, string IvDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                aSqlParameterlist.Add(new SqlParameter("@IvDate", IvDate));

                DataTable dt = accessManager.GetDataTable("sp_GET_DelTerritoryByRouteInformationDDL", aSqlParameterlist);
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
        
        public DataTable GetforPaymentTerritoryByRouteInformationDA_DDLId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_forPaymentTerritoryByRouteInformationDDL", aSqlParameterlist);
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
        
        public DataTable GetforsndreturnTerritoryByRouteInformationDA_DDLId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_forsndReturnTerritoryByRouteInformationDDL", aSqlParameterlist);
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

        public DataTable GetRouteInformationDetailMarketById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_RouteInformationMarketDetail_ById", aSqlParameterlist);
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
