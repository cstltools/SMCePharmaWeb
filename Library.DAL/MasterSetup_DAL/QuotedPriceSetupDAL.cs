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
 public   class QuotedPriceSetupDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public DataTable GetCustomerListActive()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                 
                DataTable dt = accessManager.GetDataTable("sp_Get_Customer_Active");
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
        public DataTable GetDetailById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_Get_QuotedPriceDetailById", aSqlParameterlist);
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
        public DataTable GetQuotedPriceMasterById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_QuotedPriceMaster_ById", aSqlParameterlist);
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
        public DataTable GetProductListActive()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_Product_Active");
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
        public DataTable GetProductListActiveForALl()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_Product_All");
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


        public DataTable GetQuotedPriceList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = accessManager.GetDataTable("sp_Get_QuotedPriceMaster");
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


        public ResultInfo SaveMasterDetals(QuotedPriceMasterDAO _Master,  List<QuotedPriceDetailDAO>  _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@QuotedPriceMasterId", _Master.QuotedPriceMasterId));
                gSqlParameterList.Add(new SqlParameter("@Description", _Master.Description ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@Policy", _Master.Policy ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@IsCustomerWise", _Master.IsCustomerWise ?? (object)DBNull.Value ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@IsMarketWise", _Master.IsMarketWise ?? (object)DBNull.Value ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@CustomerMasterId", _Master.CustomerMasterId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@GroupId", _Master.GroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@RegionId", _Master.RegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@AreaId", _Master.AreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@TerritoryId", _Master.TerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@SubTerritoryId", _Master.SubTerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@MarketId", _Master.MarketId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@ActiveFromDate", _Master.ActiveFromDate ?? (object)DBNull.Value ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@ActiveToDate", _Master.ActiveToDate ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser ?? (object)DBNull.Value ?? (object)DBNull.Value));



                if (_Master.QuotedPriceMasterId > 0)
                {
                  
                    bool result = accessManager.UpdateData("sp_Update_QuotedPriceMaster", gSqlParameterList);
                    aInformation.isSuccess = result;
                    pk = _Master.QuotedPriceMasterId;
                    aInformation.Id = pk;
                }
                else
                {
                   
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_QuotedPriceMaster", gSqlParameterList);
                    //sp_Save_ExpenseTypeDetails
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                        aInformation.Id = pk;
                    }
                }


                foreach (var item in _Dtls)
                {

                    List<SqlParameter> aParameters = new List<SqlParameter>();
                    aParameters.Add(new SqlParameter("@QuotedPriceMasterId", pk));
                    aParameters.Add(new SqlParameter("@ProductId", item.ProductId));
                    aParameters.Add(new SqlParameter("@UnitPrice", item.UnitPrice ?? (object)DBNull.Value ?? (object)DBNull.Value));
                    aParameters.Add(new SqlParameter("@Vat", item.Vat ?? (object)DBNull.Value ?? (object)DBNull.Value));

                    accessManager.SaveData("sp_Save_QuotedPriceDetail", aParameters);
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

    }
}
