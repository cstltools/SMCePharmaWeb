using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.DataManager;
using Library.DAO.MarketUpload_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.MarketUpload_DAL
{
    public class MarketUploadDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();



        public ResultInfo SaveMarketInfoForExcel(MarketUpload master, List<MarketUploadDetail> _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@TypeId", "0"));
                gSqlParameterList.Add(new SqlParameter("@EntryBy ", master.EntryBy));
                gSqlParameterList.Add(new SqlParameter("@EntryDate", DateTime.Now));
                gSqlParameterList.Add(new SqlParameter("@ConvertType", master.ConvertType));
                gSqlParameterList.Add(new SqlParameter("@MarketPropMasterId ", "0"));



        
                pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MarketPropMaster", gSqlParameterList);
                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                }
                else
                {
                    aInformation.isSuccess = false;

                }


                if (pk > 0)
                {
                    foreach (var item in _Dtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@MarketPropMasterId", pk));

              

                        aSQL.Add(new SqlParameter("@TerritoryCode", item.TerritoryCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketCode", item.MarketCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketName", item.MarketName ?? (object)DBNull.Value));
                        
                        aSQL.Add(new SqlParameter("@DivisionName", item.DivisionName ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@DistrictName", item.DistrictName ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@ThanaName", item.ThanaName ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@DZSMStationType", item.DZSMStationType ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@AMStationType", item.AMStationType ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MIOStationType", item.MIOStationType ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@RegionalHeadStationType", item.RegionalHeadStationType ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@SalesAssistantStationType", item.SalesAssistantStationType ?? (object)DBNull.Value));


                        aInformation.isSuccess = accessManager.SaveData("sp_Save_MarketPropDetail", aSQL);

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
        public ResultInfo SaveMarketUploadMaster(MarketUpload aMarketUpload)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MarketPropMasterId ", "0"));
                gSqlParameterList.Add(new SqlParameter("@TypeId", "0"));
                gSqlParameterList.Add(new SqlParameter("@EntryBy ", HttpContext.Current.Session["UserId"].ToString()));
                gSqlParameterList.Add(new SqlParameter("@EntryDate", entryDtae));
                gSqlParameterList.Add(new SqlParameter("@ConvertType", ""));
                
                {
                    //gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MarketPropMaster", gSqlParameterList);
                    aInformation.Id = pk;
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
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
        public ResultInfo SaveMarketUploadDetail(MarketUploadDetail aMarketUpload)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MarketPropDetailId ", aMarketUpload.MarketPropDetailId));
                gSqlParameterList.Add(new SqlParameter("@MarketPropMasterId ", aMarketUpload.MarketPropMasterId));
                gSqlParameterList.Add(new SqlParameter("@TerritoryCode ", aMarketUpload.TerritoryCode));
                gSqlParameterList.Add(new SqlParameter("@MarketCode ", aMarketUpload.MarketCode));
                gSqlParameterList.Add(new SqlParameter("@MarketName ", aMarketUpload.MarketName));
                

                {
                    //gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MarketPropDetail", gSqlParameterList);
                    aInformation.Id = pk;
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
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

        public void SaveMarketUploadTransfer(MarketUpload aMarketUpload)
        {
            
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MarketPropMasterId ", aMarketUpload.MarketPropMasterId));
                
                gSqlParameterList.Add(new SqlParameter("@EntryBy ", HttpContext.Current.Session["UserId"].ToString()));
                gSqlParameterList.Add(new SqlParameter("@EntryDate", entryDtae));


                {
                    //gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                   bool stat= accessManager.SaveData("sp_Save_MarketPropToTable", gSqlParameterList,true);
                    
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

            
        }
    }
}
