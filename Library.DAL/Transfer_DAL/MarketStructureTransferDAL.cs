using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using Library.DAO.Transer_DAO;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.MasterSetup_DAL
{
 public   class MarketStructureTransferDAL
    {

        private DataAccessManager  accessManager = new DataAccessManager ();
        public DataTable GetList(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_MSList_Approve", aSqlParameterlist);
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

        public DataTable GetCustomerSetupById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_CustMaster_ById", aSqlParameterlist);
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


        public ResultInfo Update__ProgramTypeInfo(string unitPriceId, string ProgramTypeCode, int? ProgramTypeId, int UpdateBy, DateTime UpdateDate)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);


                List<SqlParameter> gSqlParameterUpdate = new List<SqlParameter>();



                gSqlParameterUpdate.Add(new SqlParameter("@CustomerMasterId", unitPriceId));
                gSqlParameterUpdate.Add(new SqlParameter("@UpdateBy", UpdateBy));
                gSqlParameterUpdate.Add(new SqlParameter("@UpdateDate", UpdateDate));
                gSqlParameterUpdate.Add(new SqlParameter("@ProgramTypeCode", ProgramTypeCode ?? (object)DBNull.Value));
                gSqlParameterUpdate.Add(new SqlParameter("@ProgramTypeId", ProgramTypeId ?? (object)DBNull.Value));


                aInformation.isSuccess = accessManager.UpdateData("sp_Update_CustomerProgramType", gSqlParameterUpdate);




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

            return aInformation;
        }
        //public DataTable GetCustomerSetupById(string Id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@id", Id));

        //        DataTable dt = accessManager.GetDataTable("sp_GET_CustMaster_ById", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        public ResultInfo ApprovalCustomerListInfo(string Id, string rbValue, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@CustomerMasterId", Id));
                gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
                aInformation.isSuccess = accessManager.UpdateData("sp_ApproveCustomerInformation", gSqlParameterList);

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
        public ResultInfo UpdateMarketStructure_TransferApprove(string Type, string Id, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                if (Id != "")
                {
                    string[] degreeList = Id.Split(',');

                    foreach (String item in degreeList)
                    {
                        if (item != "")
                        {
                            List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                            DateTime entryDtae = DateTime.Now;
                            gSqlParameterList.Add(new SqlParameter("@MasterId", item));

                            gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                            gSqlParameterList.Add(new SqlParameter("@Type", Type));

                            aInformation.isSuccess = accessManager.UpdateData("sp_Update_MarketStructure_Approve", gSqlParameterList);
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


        public ResultInfo UpdateCustomer_Doctor_Transfer(string Type, string Id,string MarketId, string SessionUser, string DCID, string TouteId)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@MasterId", Id));
                gSqlParameterList.Add(new SqlParameter("@MarketId", MarketId));
                gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                gSqlParameterList.Add(new SqlParameter("@Type", Type));
                gSqlParameterList.Add(new SqlParameter("@DCID", DCID));
                gSqlParameterList.Add(new SqlParameter("@RouteId", TouteId));
                aInformation.isSuccess = accessManager.UpdateData("sp_Update_Customer_Doctor_Transfer", gSqlParameterList);

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


        public ResultInfo UpdateMArket_Transfer(MarketStructureTranferDAO aMaster,string Type, string param, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {


                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                if (param != "")
                {
                    string[] degreeList = param.Split(',');

                    foreach (String item in degreeList)
                    {
                        if (item != "")
                        {
                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@FGroupId", aMaster.FGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FRegionId", aMaster.FRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FAreaId", aMaster.FAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FTerritoryId", aMaster.FTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FSubTerritoryId", aMaster.FSubTerritoryId ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TGroupId", aMaster.TGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TRegionId", aMaster.TRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TAreaId", aMaster.TAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TTerritoryId", aMaster.TTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TSubTerritoryId", aMaster.TSubTerritoryId ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TMarketId", item ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@EntryBy", SessionUser ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Type", Type ?? (object)DBNull.Value));




                            aInformation.isSuccess = accessManager.SaveData("sp_Update_MarketStructure_Transfer", aSQL);
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

        public ResultInfo UpdateSubTerritory_Transfer(MarketStructureTranferDAO aMaster, string Type, string param, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {


                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                if (param != "")
                {
                    string[] degreeList = param.Split(',');

                    foreach (String item in degreeList)
                    {
                        if (item != "")
                        {
                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@FGroupId", aMaster.FGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FRegionId", aMaster.FRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FAreaId", aMaster.FAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FTerritoryId", aMaster.FTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FSubTerritoryId", aMaster.FSubTerritoryId ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TGroupId", aMaster.TGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TRegionId", aMaster.TRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TAreaId", aMaster.TAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TTerritoryId", aMaster.TTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TSubTerritoryId",  item ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TMarketId", null ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@EntryBy", SessionUser ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Type", Type ?? (object)DBNull.Value));




                            aInformation.isSuccess = accessManager.SaveData("sp_Update_MarketStructure_Transfer", aSQL);
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




        public ResultInfo UpdateZone_Transfer(MarketStructureTranferDAO aMaster, string Type, string param, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {


                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                if (param != "")
                {
                    string[] degreeList = param.Split(',');

                    foreach (String item in degreeList)
                    {
                        if (item != "")
                        {
                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@FGroupId", aMaster.FGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FRegionId", aMaster.FRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FAreaId", aMaster.FAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FTerritoryId", aMaster.FTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FSubTerritoryId", aMaster.FSubTerritoryId ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TGroupId", aMaster.TGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TRegionId", item ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TAreaId", null ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TTerritoryId",  null ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TSubTerritoryId", null ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TMarketId", null ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@EntryBy", SessionUser ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Type", Type ?? (object)DBNull.Value));




                            aInformation.isSuccess = accessManager.SaveData("sp_Update_MarketStructure_Transfer", aSQL);
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



        public ResultInfo UpdateArea_Transfer(MarketStructureTranferDAO aMaster, string Type, string param, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {


                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                if (param != "")
                {
                    string[] degreeList = param.Split(',');

                    foreach (String item in degreeList)
                    {
                        if (item != "")
                        {
                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@FGroupId", aMaster.FGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FRegionId", aMaster.FRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FAreaId", aMaster.FAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FTerritoryId", aMaster.FTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FSubTerritoryId", aMaster.FSubTerritoryId ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TGroupId", aMaster.TGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TRegionId", aMaster.TAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TAreaId", item ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TTerritoryId", null ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TSubTerritoryId", null ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TMarketId", null ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@EntryBy", SessionUser ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Type", Type ?? (object)DBNull.Value));




                            aInformation.isSuccess = accessManager.SaveData("sp_Update_MarketStructure_Transfer", aSQL);
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


        public ResultInfo UpdateTerritory_Transfer(MarketStructureTranferDAO aMaster, string Type, string param, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {


                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                if (param != "")
                {
                    string[] degreeList = param.Split(',');

                    foreach (String item in degreeList)
                    {
                        if (item != "")
                        {
                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@FGroupId", aMaster.FGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FRegionId", aMaster.FRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FAreaId", aMaster.FAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FTerritoryId", aMaster.FTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@FSubTerritoryId", aMaster.FSubTerritoryId ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TGroupId", aMaster.TGroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TRegionId", aMaster.TRegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TAreaId", aMaster.TAreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TTerritoryId", item ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TSubTerritoryId",  null ?? (object)DBNull.Value));


                            aSQL.Add(new SqlParameter("@TMarketId", null ?? (object)DBNull.Value));

                            aSQL.Add(new SqlParameter("@EntryBy", SessionUser ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Type", Type ?? (object)DBNull.Value));




                            aInformation.isSuccess = accessManager.SaveData("sp_Update_MarketStructure_Transfer", aSQL);
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

        public ResultInfo SaveProductDist( int ProductId , String _ProLineArray)
        {
            int pk = ProductId;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                if (pk > 0)
                {
                    List<SqlParameter> aSQLdel = new List<SqlParameter>();
                    aSQLdel.Add(new SqlParameter("@ProductId", pk));
                    aInformation.isSuccess = accessManager.SaveData("sp_Delete_ProductDCDetails", aSQLdel);

                    if (_ProLineArray != "")
                    {
                        string[] ProLine = _ProLineArray.Split(',');

                        foreach (String item in ProLine)
                        {
                            if (item != "")
                            {
                                List<SqlParameter> aSQL = new List<SqlParameter>();
                                aSQL.Add(new SqlParameter("@ProductId", pk));
                                aSQL.Add(new SqlParameter("@ComUnitId", item ?? (object)DBNull.Value));
                                aInformation.isSuccess = accessManager.SaveData("sp_Save_ProductDCDetails", aSQL);
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

        public ResultInfo SaveInfo(CustMasterInfoDAO master, String _ProLineArray, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@CustomerMasterId", master.CustomerMasterId));
                gSqlParameterList.Add(new SqlParameter("@CustomerName", master.CustomerName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CustomerTypeId", master.CustomerTypeId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@CustomerType", master.CustomerType ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@DistributionRouteId", master.DistributionRouteId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Email", master.Email ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@CellNo", master.CellNo ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@OwnerName", master.OwnerName ?? (object)DBNull.Value));

              


                gSqlParameterList.Add(new SqlParameter("@Address", master.Address ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@VoterID", master.VoterID ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@TradeLicense", master.TradeLicense ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@DrugLicense", master.DrugLicense ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@PharmacyCouncilCertificate", master.PharmacyCouncilCertificate ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@BCDS", master.BCDS ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@Reamrks", master.Reamrks ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@IsActive", master.IsActive ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MarketId", master.MarketId ?? (object)DBNull.Value));
            
                gSqlParameterList.Add(new SqlParameter("@MarketName", master.MarketName ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@StationTypeId", master.StationTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ComUnitId", master.ComUnitId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@NSMStationTypeId", master.NSMStationTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DZSMStationTypeId", master.DZSMStationTypeId ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@ProgramTypeId", master.ProgramTypeId ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@DivisionId", master.DivisionId ?? (object)DBNull.Value));




                gSqlParameterList.Add(new SqlParameter("@Division", master.Division ?? (object)DBNull.Value));



                gSqlParameterList.Add(new SqlParameter("@DistrictId", master.DistrictId ?? (object)DBNull.Value));



                gSqlParameterList.Add(new SqlParameter("@District", master.District ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@ThanaId", master.ThanaId ?? (object)DBNull.Value));



                gSqlParameterList.Add(new SqlParameter("@Thana", master.Thana ?? (object)DBNull.Value));




                if (master.CustomerMasterId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_CustomerMaster", gSqlParameterList);

                    pk = master.CustomerMasterId;

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_CustomerMaster", gSqlParameterList);
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
                    if (_ProLineArray != "")
                    {
                        string[] ProLine = _ProLineArray.Split(',');

                        foreach (String item in ProLine)
                        {
                            if (item != "")
                            {
                                List<SqlParameter> aSQL = new List<SqlParameter>();
                                aSQL.Add(new SqlParameter("@CustomerMasterId", pk));
                                aSQL.Add(new SqlParameter("@ProductLineID", item ?? (object)DBNull.Value));
                                aInformation.isSuccess = accessManager.SaveData("sp_Save_CustProductLineDetail", aSQL);
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


        public DataTable GetMarketListBySubTerritoryId(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_CustMasterList_Approve", aSqlParameterlist);
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

        public DataTable GetOrderList_ApplogDAL(string pram, string Role, string AppStatus, DateTime? FromDt, DateTime? ToDt, int? EmpId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@param", pram ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Role", Role ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AppStatus", AppStatus ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@FromDt", FromDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToDt", ToDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpId", EmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_OrderApp", gSqlParameterList);
                //SqlDataReader dr = accessManager.GetSqlDataReader("sp_Webapi_Get_DoctorClaimApp", gSqlParameterList);
                return dt;
                //DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_AttendanceInformation", gSqlParameterList);
                //return dt;
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



        public DataTable GetLeave_AppLogDAL(string pram, string Role, string AppStatus, DateTime? FromDt, DateTime? ToDt, int? EmpId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@param", pram ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Role", Role ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AppStatus", AppStatus ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@FromDt", FromDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToDt", ToDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpId", EmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_Leave_AppLog", gSqlParameterList);
                //SqlDataReader dr = accessManager.GetSqlDataReader("sp_Webapi_Get_DoctorClaimApp", gSqlParameterList);
                return dt;
                //DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_AttendanceInformation", gSqlParameterList);
                //return dt;
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

        public DataTable GetCustomer_ApplogDAL(string pram, string Role, string AppStatus, DateTime? FromDt, DateTime? ToDt, int? EmpId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@param", pram ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Role", Role ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AppStatus", AppStatus ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@FromDt", FromDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToDt", ToDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpId", EmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_CustomerApp", gSqlParameterList);
                //SqlDataReader dr = accessManager.GetSqlDataReader("sp_Webapi_Get_DoctorClaimApp", gSqlParameterList);
                return dt;
                //DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_AttendanceInformation", gSqlParameterList);
                //return dt;
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

        public ResultInfo SaveCustomer_ApplogDAL(CustomerSaveAppLog_DAO atten)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@CustomerApprovalId", atten.CustomerApprovalId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Date", atten.Date ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@FromEmpId", atten.FromEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToEmpId", atten.ToEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TableId", atten.TableId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Status", atten.Status ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Comments", atten.Comments ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Type", atten.Type ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Step", atten.Step ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@GroupId", atten.GroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RegionId", atten.RegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AreaId", atten.AreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TerritoryId", atten.TerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@ToGroupId", atten.ToGroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToRegionId", atten.ToRegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToAreaId", atten.ToAreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToTerritoryId", atten.ToTerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByS", atten.EntryByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateS", atten.EntryDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeS", atten.EntryTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByS", atten.ApproveByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateS", atten.ApproveDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeS", atten.ApproveTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByApp", atten.EntryByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateApp", atten.EntryDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeApp", atten.EntryTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByApp", atten.ApproveByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateApp", atten.ApproveDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeApp", atten.ApproveTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MenuId", atten.MenuId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                aInformation.isSuccess = accessManager.SaveData("sp_webapi_SaveCustomerAppLog", gSqlParameterList);

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

        public ResultInfo SaveOrder_ApplogDAL(OrderSaveApprovalLogDAO atten)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@OrderApprovalId", atten.OrderApprovalId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Date", atten.Date ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@FromEmpId", atten.FromEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToEmpId", atten.ToEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TableId", atten.TableId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Status", atten.Status ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Comments", atten.Comments ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Type", atten.Type ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Step", atten.Step ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@GroupId", atten.GroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RegionId", atten.RegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AreaId", atten.AreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TerritoryId", atten.TerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@ToGroupId", atten.ToGroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToRegionId", atten.ToRegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToAreaId", atten.ToAreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToTerritoryId", atten.ToTerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByS", atten.EntryByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateS", atten.EntryDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeS", atten.EntryTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByS", atten.ApproveByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateS", atten.ApproveDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeS", atten.ApproveTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByApp", atten.EntryByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateApp", atten.EntryDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeApp", atten.EntryTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByApp", atten.ApproveByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateApp", atten.ApproveDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeApp", atten.ApproveTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MenuId", atten.MenuId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                aInformation.isSuccess = accessManager.SaveData("sp_webapi_SaveOrderAppLog", gSqlParameterList);

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



        public ResultInfo SaveLeave_ApplogDAL(LeaveApplo_Save atten)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@LeaveApprovalId", atten.LeaveApprovalId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Date", atten.Date ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@FromEmpId", atten.FromEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToEmpId", atten.ToEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TableId", atten.TableId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Status", atten.Status ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Comments", atten.Comments ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Type", atten.Type ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Step", atten.Step ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@GroupId", atten.GroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RegionId", atten.RegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AreaId", atten.AreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TerritoryId", atten.TerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@ToGroupId", atten.ToGroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToRegionId", atten.ToRegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToAreaId", atten.ToAreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToTerritoryId", atten.ToTerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByS", atten.EntryByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateS", atten.EntryDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeS", atten.EntryTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByS", atten.ApproveByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateS", atten.ApproveDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeS", atten.ApproveTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByApp", atten.EntryByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateApp", atten.EntryDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeApp", atten.EntryTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByApp", atten.ApproveByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateApp", atten.ApproveDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeApp", atten.ApproveTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MenuId", atten.MenuId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                aInformation.isSuccess = accessManager.SaveData("sp_webapi_SaveLeaveAppLog", gSqlParameterList);

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
