using Library.DAL.DataManager;
using Library.DAO.DoctorModule_DAO;
using Library.DAO.MasterSetup_DAO;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using Dapper;

namespace Library.DAL.MasterSetup_DAL
{
  public  class BonusCampaignNewDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public DataTable GetBonusCampaignList(string prm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", prm));
                DataTable dt = accessManager.GetDataTable("sp_Get_BonusCampaignNewMasterList", aSqlParameterlist);
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
        public DataTable GetTargetUploadList(string prm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", prm));
                DataTable dt = accessManager.GetDataTable("sp_Get_TerritoryTargetList", aSqlParameterlist);
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
        public DataTable GetProductForDDL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                DataTable dt = accessManager.GetDataTable("sp_Get_Product_ForTargetSetup_DDL");
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


        public ResultInfo BankDeposit_SAP_Process(DateTime fromdate, DateTime todate)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB); 
                DateTime entryDtae = DateTime.Now;


                

                    List<SqlParameter> gSqlDelprm = new List<SqlParameter>();
                gSqlDelprm.Add(new SqlParameter("@fromdate", fromdate));
                gSqlDelprm.Add(new SqlParameter("@todate", todate));
                aInformation.isSuccess = accessManager.UpdateData("sp_SAP_BankDeposit_SAP_Process", gSqlDelprm);
                
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
        public ResultInfo BankDeposit_SAP_ProcessUpdate(string Ids)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB); 
                DateTime entryDtae = DateTime.Now;


                

                    List<SqlParameter> gSqlDelprm = new List<SqlParameter>();
                gSqlDelprm.Add(new SqlParameter("@Ids", Ids));
              
                aInformation.isSuccess = accessManager.UpdateData("sp_SAP_BankDepositSendtoSAP", gSqlDelprm);
                
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
       
        public ResultInfo SYncBonusCampaign(  string sessionUser)
        {
            int pk = 0;  
             ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlDelprm = new List<SqlParameter>();
                gSqlDelprm.Add(new SqlParameter("@Ids", ""));

                aInformation.isSuccess = accessManager.UpdateData("sp_CampaignUpdateFromPage", gSqlDelprm);


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

        public ResultInfo SaveBonusCampaign(BonusCampaignNewMasterDAO master, List<BonusCampaignNewDetailDAO> _Dtls, List<BonusCampaignMarketDetailDAO> _MarketDtls, List<CampaignCustomerDetailDAO> _CamCustomerDtls, string sessionUser)
        {
            int pk = 0;  
             ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;


                if (master.CampgainMasterId > 0)
                {

                    List<SqlParameter> gSqlDelprm = new List<SqlParameter>();
                    gSqlDelprm.Add(new SqlParameter("@CampgainMasterId", master.CampgainMasterId));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Del_BonusCampaignNewMaster", gSqlDelprm);

                    master.CampgainMasterId = 0;
                    gSqlParameterList.Add(new SqlParameter("@CampgainMasterId", master.CampgainMasterId));
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@CampgainMasterId", master.CampgainMasterId));
                }

                   
                gSqlParameterList.Add(new SqlParameter("@CampaignName", master.CampaignName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CustomerTypeId", master.CustomerTypeId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@CampainTypeId", master.CampainTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CampaignCategoryId", master.CampaignCategoryId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@Amount", master.Amount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ProductQty", master.ProductQty ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MaxAmount", master.MaxAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@FromDate", master.FromDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Todate", master.Todate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsActive", master.IsActive ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsTradePolicy", master.IsTradePolicy ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsFCFS", master.IsFCFS ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@IsPTforCOD", master.IsPTforCOD ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsPTforOther", master.IsPTforOther ?? (object)DBNull.Value));



                gSqlParameterList.Add(new SqlParameter("@ProductLineID", master.ProductLineID ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@BonusProductId", master.BonusProductId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsRatioWiseIncrement", master.IsRatioWiseIncrement ?? (object)DBNull.Value));

                if (master.CampgainMasterId > 0)
                {

                    List<SqlParameter> gSql = new List<SqlParameter>();
                    gSql.Add(new SqlParameter("@CampgainMasterId", pk));
                    DataTable dt = accessManager.GetDataTable("sp_Get_BonusCampaigndtlList", gSql);

                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_BonusCampaignNewMaster", gSqlParameterList);

                    pk = master.CampgainMasterId;


                    List<SqlParameter> aSQLMap = new List<SqlParameter>();
                    aSQLMap.Add(new SqlParameter("@CampaignMasterId", pk));
                    aSQLMap.Add(new SqlParameter("@CampgainMasterMapId", HttpContext.Current.Session["CampgainMasterMapId"]));
                    aSQLMap.Add(new SqlParameter("@CustomerTypeId", master.CustomerTypeId ?? (object)DBNull.Value));
                    aInformation.isSuccess = accessManager.SaveData("sp_Update_BonusCampaignpkCampaignSetupId", aSQLMap);






                    //for (int i = 0; i < dt.Rows.Count; i++)
                    //{
                    foreach (var item in _Dtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk));
                        aSQL.Add(new SqlParameter("@CampaignDetailId",   item.CampaignDetailId ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@DiscountPercentage", item.DiscountPercentage ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@Quantity", item.Quantity ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@BonusProductId", item.BonusProductId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@BonusQuantity", item.BonusQuantity ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@QuantityDteail", item.QuantityDteail ?? (object)DBNull.Value));

                        aSQL.Add(new SqlParameter("@BonusTypeId", item.BonusTypeId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@CampaignName", master.CampaignName ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@IsRatioWiseIncrementPro", item.IsRatioWiseIncrementPro ?? (object)DBNull.Value));
                        aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignNewDetail_Up", aSQL);

                    }

                //}
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_BonusCampaignNewMaster", gSqlParameterList);
                    if (pk > 0)
                    {

                        List<SqlParameter> aSQLMap = new List<SqlParameter>();
                        aSQLMap.Add(new SqlParameter("@CampaignMasterId", pk));
                        aSQLMap.Add(new SqlParameter("@CampgainMasterMapId", HttpContext.Current.Session["CampgainMasterMapId"]));
                        aSQLMap.Add(new SqlParameter("@CustomerTypeId", master.CustomerTypeId ?? (object)DBNull.Value));
                        aInformation.isSuccess = accessManager.SaveData("sp_Update_BonusCampaignpkCampaignSetupId", aSQLMap);

                        aInformation.isSuccess = true;

                        foreach (var item in _Dtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@CampaignMasterId", pk));

                            aSQL.Add(new SqlParameter("@DiscountPercentage", item.DiscountPercentage ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Quantity", item.Quantity ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@BonusProductId", item.BonusProductId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@BonusQuantity", item.BonusQuantity ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@QuantityDteail", item.QuantityDteail ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@BonusTypeId", item.BonusTypeId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@CampaignName", master.CampaignName ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@IsRatioWiseIncrementPro", item.IsRatioWiseIncrementPro ?? (object)DBNull.Value));
                            aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignNewDetail", aSQL);

                        }
                    }
                    else
                    {
                        aInformation.isSuccess = false;

                    }
                }

                if (pk > 0)
                {
                    

                    foreach (var item in _MarketDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk ));
                        aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@SubTerritoryId", item.SubTerritoryId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketId", item.MarketId ?? (object)DBNull.Value));

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignMarketDetail", aSQL);

                    }


                    foreach (var item in _CamCustomerDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk));
                       
                        aSQL.Add(new SqlParameter("@CustomerMasterId", item.CustomerMasterId ?? (object)DBNull.Value));

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignCustomerDetail", aSQL);

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

                      
      public ResultInfo SaveTargetEdit(TargetEditDAO master , string sessionUser)
        {
            int pk = 0;  
             ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@SL", master.SL));
                gSqlParameterList.Add(new SqlParameter("@FYId", master.FYId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@YearValue", master.YearValue ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@MonthName", master.MonthName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpId", master.EmpId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@Value", master.Value ?? (object)DBNull.Value));
               

                if (master.SL > 0)
                {

                   

                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_TargetInfo", gSqlParameterList);

                    pk = master.SL;

                   
                  
 
                }

                if (pk > 0)
                {

                    aInformation.isSuccess = true;

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

                      
   
        public int SaveReturnSalesMaster(SalesReturnDaoMas master, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@ReturnInvoiceId", master.ReturnInvoiceId));
                gSqlParameterList.Add(new SqlParameter("@InvoiceDate", master.InvoiceDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@createBy", master.createBy ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@Createdate", master.Createdate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@OrderNo", master.OrderNo ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@OrderDate", master.OrderDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CustomerMasterId", master.CustomerMasterId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ComUnitId", master.ComUnitId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MiaId", master.MiaId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@PaymentTypeId", master.PaymentTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TpTotal", master.TpTotal ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TpDiscount", master.TpDiscount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Type", master.Type ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DpMob", master.DpMob ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TpVat", master.TpVat ?? (object)DBNull.Value));



                gSqlParameterList.Add(new SqlParameter("@OrderId", master.OrderId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TotalSpecialAmount", master.TotalSpecialAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@OldTradePolicy", master.OldTradePolicy ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ProductOffer", master.ProductOffer ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Remarks", master.Remarks ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MIACode", master.MIACode ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MIAName", master.MIAName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MarketCode", master.MarketCode ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MarketName", master.MarketName ?? (object)DBNull.Value));



                gSqlParameterList.Add(new SqlParameter("@AreaCode", master.AreaCode ?? (object)DBNull.Value)); gSqlParameterList.Add(new SqlParameter("@DisCode", master.DisCode ?? (object)DBNull.Value)); gSqlParameterList.Add(new SqlParameter("@FEName", master.FEName ?? (object)DBNull.Value)); gSqlParameterList.Add(new SqlParameter("@RegionCode", master.RegionCode ?? (object)DBNull.Value));




                gSqlParameterList.Add(new SqlParameter("@DZSMName", master.DZSMName ?? (object)DBNull.Value)); gSqlParameterList.Add(new SqlParameter("@FixedCustomer", master.FixedCustomer ?? (object)DBNull.Value)); 
                
                
                gSqlParameterList.Add(new SqlParameter("@DpNAme", master.DpNAme ?? (object)DBNull.Value)); gSqlParameterList.Add(new SqlParameter("@invoiceid", master.InvoiceId ?? (object)DBNull.Value));

                 gSqlParameterList.Add(new SqlParameter("@MIOId_new", master.MIOId_new ?? (object)DBNull.Value));
                 gSqlParameterList.Add(new SqlParameter("@Terri_Id_new", master.Terri_Id_new ?? (object)DBNull.Value));
                 gSqlParameterList.Add(new SqlParameter("@MioEmpId_new", master.MioEmpId_new ?? (object)DBNull.Value));
                 gSqlParameterList.Add(new SqlParameter("@Mio_SapCode_New", master.Mio_SapCode_New ?? (object)DBNull.Value));





                pk = accessManager.SaveDataReturnPrimaryKey("spInsertReturnInvoice_new", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;

                       
                    }
                    else
                    {
                        aInformation.isSuccess = false;

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

            return pk;
        }

        public ResultInfo SaveBonusCampaign_final(BonusCampaignNewMasterDAO master, List<BonusCampaignNewDetailDAO> _Dtls, List<BonusCampaignMarketDetailDAO> _MarketDtls, List<CampaignCustomerDetailDAO> _CamCustomerDtls, string sessionUser, List<ManualRationSetupCampDAO> ManualRationProList, List<MultipleProductAddCampDAO> MultipleProductList)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@CampgainMasterId", master.CampgainMasterId));
                gSqlParameterList.Add(new SqlParameter("@CampaignName", master.CampaignName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CustomerTypeId", master.CustomerTypeId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@CampainTypeId", master.CampainTypeId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@Amount", master.Amount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ProductQty", master.ProductQty ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MaxAmount", master.MaxAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@FromDate", master.FromDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Todate", master.Todate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsActive", master.IsActive ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsTradePolicy", master.IsTradePolicy ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ProductLineID", master.ProductLineID ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@BonusProductId", master.BonusProductId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@IsMultipleProductAdd", master.IsMultipleProductAdd ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsManualRationSetup", master.IsManualRationSetup ?? (object)DBNull.Value));

                if (master.CampgainMasterId > 0)
                {

                    List<SqlParameter> gSql = new List<SqlParameter>();
                    gSql.Add(new SqlParameter("@CampgainMasterId", pk));
                    DataTable dt = accessManager.GetDataTable("sp_Get_BonusCampaigndtlList", gSql);

                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_BonusCampaignNewMaster_final", gSqlParameterList);

                    pk = master.CampgainMasterId;








                    //for (int i = 0; i < dt.Rows.Count; i++)
                    //{
                    foreach (var item in _Dtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk));
                        aSQL.Add(new SqlParameter("@CampaignDetailId", item.CampaignDetailId ?? (object)DBNull.Value));

                        aSQL.Add(new SqlParameter("@DiscountPercentage", item.DiscountPercentage ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@Quantity", item.Quantity ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@BonusProductId", item.BonusProductId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@BonusQuantity", item.BonusQuantity ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@QuantityDteail", item.QuantityDteail ?? (object)DBNull.Value));

                        aSQL.Add(new SqlParameter("@BonusTypeId", item.BonusTypeId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@CampaignName", master.CampaignName ?? (object)DBNull.Value));
                        aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignNewDetail_Up", aSQL);

                    }

                    //}
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_BonusCampaignNewMaster_final", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;

                        foreach (var item in _Dtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@CampaignMasterId", pk));

                            aSQL.Add(new SqlParameter("@DiscountPercentage", item.DiscountPercentage ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Quantity", item.Quantity ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@BonusProductId", item.BonusProductId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@BonusQuantity", item.BonusQuantity ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@QuantityDteail", item.QuantityDteail ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@BonusTypeId", item.BonusTypeId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@CampaignName", master.CampaignName ?? (object)DBNull.Value));
                            aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignNewDetail", aSQL);

                        }
                    }
                    else
                    {
                        aInformation.isSuccess = false;

                    }
                }

                if (pk > 0)
                {


                    foreach (var item in _MarketDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk));
                        aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@SubTerritoryId", item.SubTerritoryId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketId", item.MarketId ?? (object)DBNull.Value));

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignMarketDetail", aSQL);

                    }


                    foreach (var item in _CamCustomerDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk));

                        aSQL.Add(new SqlParameter("@CustomerMasterId", item.CustomerMasterId ?? (object)DBNull.Value));

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_BonusCampaignCustomerDetail", aSQL);

                    }

                    if (master.IsManualRationSetup == true)
                    {
                        foreach (var item in ManualRationProList)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@CampaignMasterId", pk));

                            aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@BounsProductId", item.BounsProductId ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@MainQuantity_From", item.MainQuantity_From ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@MainQuantity_ManualRationSetup", item.MainQuantity_ManualRationSetup ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@BonusQuantity_ManualRationSetup", item.BonusQuantity_ManualRationSetup ?? (object)DBNull.Value));


                            aInformation.isSuccess = accessManager.SaveData("sp_Save_ManualRationSetupCampDetail", aSQL);

                        }
                    }

                    if (master.IsMultipleProductAdd == true) { 
                    foreach (var item in MultipleProductList)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@CampaignMasterId", pk));

                        aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@ProQty_MultipleProductAdd", item.ProQty_MultipleProductAdd ?? (object)DBNull.Value));
                       

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_MultipleProductAddCampCampDetail", aSQL);

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


        public ResultInfo SaveLeaveConfig(LeaveConfigDAO master, string EmpList , List<LeaveConfigCountDtl> _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@LeaveConfigId", master.LeaveConfigId));
                gSqlParameterList.Add(new SqlParameter("@LeaveName", master.LeaveName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CountGovtLeave", master.CountGovtLeave ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@CountEmployeeHoliday", master.CountEmployeeHoliday ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@DayNameId", master.DayNameId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EligbleforProbationEmployee", master.EligbleforProbationEmployee ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@LeaveTypeId", master.LeaveTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsActive", master.IsActive ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));

                if (master.LeaveConfigId > 0)
                {
                     
                    aInformation.isSuccess = accessManager.UpdateData("sp_Up_LeaveConfigMaster", gSqlParameterList);
                    pk = master.LeaveConfigId;

                }  else
                {

                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_LeaveConfigMaster", gSqlParameterList);
                }
                    
                    if (pk > 0)
                    {


                    foreach (var item in _Dtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@LeaveConfigId", pk));

                        aSQL.Add(new SqlParameter("@JoiningDateCountId", item.JoiningDateCountId ?? (object)DBNull.Value));

                        aSQL.Add(new SqlParameter("@DaysPerMonthly", item.DaysPerMonthly ?? (object)DBNull.Value));

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_LeaveConfigDtl", aSQL);

                    }

                    if (EmpList != "")
                    {
                        string[] _List = null;

                        try
                        {
                            _List = EmpList.Split(',');

                        }
                        catch
                        {

                        }

                        try
                        {
                            if (_List.Length > 0)
                            {
                                foreach (String item in _List)
                                {
                                    if (item != "")
                                    {
                                        List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
                                        aSqlParameterList.Add(new SqlParameter("@LeaveConfigId", pk));
                                        aSqlParameterList.Add(new SqlParameter("@EmployeeId", item));

                                        aInformation.isSuccess = accessManager.SaveData("sp_Save_LeaveConfigFroenEmp", aSqlParameterList);
                                    }

                                }

                            }
                        }
                        catch (Exception ex) { }

                    }

                   // aInformation.isSuccess = true;

                       
                    }
                    else
                    {
                        aInformation.isSuccess = false;

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

        public ResultInfo SaveDoctorInfoForExcel(CustomerPropUpdateMasterDAO master, List<CustomerPropUpdateDetailDAO> _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@CustPropMasterId", master.CustPropMasterId));
                gSqlParameterList.Add(new SqlParameter("@TypeId", master.TypeId ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@ConvertType", master.ConvertType ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorPropUpdateMaster", gSqlParameterList);
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
                        aSQL.Add(new SqlParameter("@CustPropMasterId", pk));

                        aSQL.Add(new SqlParameter("@CustPropUpdateDetailId", item.CustPropUpdateDetailId ?? (object)DBNull.Value));

                        aSQL.Add(new SqlParameter("@CustCode", item.CustCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@ProviderType", item.ProviderType ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@CustTypeCode", item.CustTypeCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketCode", item.MarketCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@PharmaPlatformCode", item.PharmaPlatformCode ?? (object)DBNull.Value));



                        aInformation.isSuccess = accessManager.SaveData("sp_Save_DoctorPropUpdateDetail", aSQL);

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

        public ResultInfo SaveCustomerInfoForExcel(CustomerPropUpdateMasterDAO master, List<CustomerPropUpdateDetailDAO> _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@CustPropMasterId", master.CustPropMasterId));
                gSqlParameterList.Add(new SqlParameter("@TypeId", master.TypeId ?? (object)DBNull.Value));
                 

                gSqlParameterList.Add(new SqlParameter("@ConvertType", master.ConvertType ?? (object)DBNull.Value));
 
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_CustomerPropUpdateMaster", gSqlParameterList);
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
                        aSQL.Add(new SqlParameter("@CustPropMasterId", pk));

                        aSQL.Add(new SqlParameter("@CustPropUpdateDetailId", item.CustPropUpdateDetailId ?? (object)DBNull.Value));
                       
                        aSQL.Add(new SqlParameter("@CustCode", item.CustCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@ProviderType", item.ProviderType ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@CustTypeCode", item.CustTypeCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@MarketCode", item.MarketCode ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@PharmaPlatformCode", item.PharmaPlatformCode ?? (object)DBNull.Value));


                        aInformation.isSuccess = accessManager.SaveData("sp_Save_CustomerPropUpdateDetail", aSQL);

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
        public DataTable GetCampaignSetupById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignMaster_ById", aSqlParameterlist);
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
        public DataTable GetMobileSyncStatus(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB); 

                DataTable dt = accessManager.GetDataTable("usp_CheckCampaignEntryDate");
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
         public DataTable GetDelivaryInvoiceNoCheckById(string Id, string InvStatus)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                aSqlParameterlist.Add(new SqlParameter("@InvStatus", InvStatus));

                DataTable dt = accessManager.GetDataTable("sp_GET_DelivaryInvoiceNoCheckById", aSqlParameterlist);
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

        /// Same check as <see cref="GetDelivaryInvoiceNoCheckById(string, string)"/> but run on the
        /// caller's connection/transaction so the re-check under the submit lock (see
        /// AcquireOrderSubmitLock in the Delivery Invoice Submit flow) sees a consistent, isolated view
        /// instead of racing a concurrent submit through a separate auto-committing connection.
        public DataTable GetDelivaryInvoiceNoCheckById(string Id, string InvStatus, SqlTransaction transaction)
        {
            DataTable dt = new DataTable();
            using (var reader = (System.Data.Common.DbDataReader)transaction.Connection.ExecuteReader(
                "sp_GET_DelivaryInvoiceNoCheckById", new { id = Id, InvStatus = InvStatus }, transaction, commandType: CommandType.StoredProcedure))
            {
                dt.Load(reader);
            }
            return dt;
        }
        
        public DataTable GetCampaignSetupMapById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignMasterMap_ById", aSqlParameterlist);
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
        
        public DataTable GetOrderDtlCamCheckId(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_GetOrderDtlCamCheckId", aSqlParameterlist);
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
        
        public DataTable GetOrderDtlCamCheckIdCheckEzevent(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_GetOrderDtlCamCheckIdEze", aSqlParameterlist);
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
        
        
        public DataTable checkTodaysAlreadyInviceGenerate(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_checkTodaysAlreadyInviceGenerateByCustId", aSqlParameterlist);
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

        
        public DataTable GetTargetEditById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_TargetEdit_ById", aSqlParameterlist);
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



        public DataTable GetLeaveConfigSetupById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_LeaveConfigSetupById", aSqlParameterlist);
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


        public DataTable GetCampaignSetupDetailById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignDetail_ById", aSqlParameterlist);
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

        public DataTable GetCampaignSetupDetailMarketById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignDetailMarket_ById", aSqlParameterlist);
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


        public DataTable GetCampaignSetupDetailCustomerById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignDetailCustomer_ById", aSqlParameterlist);
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

        public DataTable GetCampaignSetupDetailMulProById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignDetailMulPro_ById", aSqlParameterlist);
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


        public DataTable GetCampaignSetupDetailMannualRatioById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CampaignDetailMaanualRatio_ById", aSqlParameterlist);
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

        public bool SaveImage(string path, string name, int id, int ImageId)
        {
            bool status = false;
            string meesage = "";

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NoticeImageId", ImageId));
                gSqlParameterList.Add(new SqlParameter("@NoticeId", id));
                gSqlParameterList.Add(new SqlParameter("@ImageName", name));
                gSqlParameterList.Add(new SqlParameter("@ImagePath", path));
                status = accessManager.SaveData("sp_Save_NoticeImage", gSqlParameterList, false);
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                status = false;
                meesage = exception.Message;

                throw exception;
            }
            finally
            {


                accessManager.SqlConnectionClose();
            }

            return status;
        }




        public ResultInfo SaveNoticeImage(string path, string name, int id)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NoticeImageId", 0));
                gSqlParameterList.Add(new SqlParameter("@NoticeImageId", id));
                gSqlParameterList.Add(new SqlParameter("@ImageName", name));
                gSqlParameterList.Add(new SqlParameter("@ImagePath", path));

                pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_NoticeImage", gSqlParameterList);
                if (pk > 0)
                {
                    aInformation.isSuccess = true;
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


        public DataTable GetNoticeMasterList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_NoticeMaster");
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


        public bool Delete_NoticeImage(int Id)
        {
            bool status = false;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> sqlParameters = new List<SqlParameter>();
                sqlParameters.Add(new SqlParameter("@NoticeId", Id));
                status = accessManager.DeleteData("sp_DEL_NoticeImage", sqlParameters);
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return status;
        }

        public bool Delete_Target(int Id)
        {
            bool status = false;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> sqlParameters = new List<SqlParameter>();
                sqlParameters.Add(new SqlParameter("@SL", Id));
                status = accessManager.DeleteData("sp_DEL_TargetInfo", sqlParameters);
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return status;
        }

        public ResultInfo Delete_NoticeMaster(Int32 DeleteId)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NoticeId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_NoticeMaster", gSqlParameterList);
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


        public NoticeMaster GetNoticeMasterForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                NoticeMaster master = new NoticeMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_NoticeMaster_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.NoticeId = (int)dr["NoticeId"];
                    master.NoticeTitle = dr["NoticeTitle"].ToString();
                    master.Announcement = dr["Announcement"].ToString();
                    master.FromDate = (DateTime)dr["FromDate"];
                    master.ToDate = (DateTime)dr["ToDate"];
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


        public DataTable Get_NoticeImageByNoticeId(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_NoticeImage_By_NoticeId", aSqlParameterlist);
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


        public DataTable Get_NoticeDetailsByNoticeId(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_Noticedetails_By_NoticeId", aSqlParameterlist);
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
