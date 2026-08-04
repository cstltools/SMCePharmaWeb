using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System.Web;
using System.Net.NetworkInformation;

namespace Library.DAL.SAP_IntegrationDAL
{
    public class SAP_IntrigationPointDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();



        public DataTable GetDepositCodeByDIC(string pram)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                int ComId = 0;


                if (HttpContext.Current.Session["RoleTypeName"].ToString() == "DIC")
                {
                    try
                    {
                        ComId = Convert.ToInt32(HttpContext.Current.Session["DICCompanyUnitId"].ToString());
                    }
                    catch
                    {

                    }

                }
                aSqlParameterlist.Add(new SqlParameter("@Parm", ComId.ToString()));

                DataTable dt = accessManager.GetDataTable("sp_Get_DepositCodeByDIC", aSqlParameterlist);

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

        public DataTable GetSAP_IntrigationPointHeaderDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_IntrigationPointHeader", aSqlParameterlist);
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

        public DataTable GetProviderDropoutIntrigrationListDAL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DataTable dt = accessManager.GetDataTable("sp_Get_ProviderDropoutIntrigrationList");
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

        public DataTable GetSAP_EmpSApCodebyTerritory(string TerritoryCode)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@TerritoryCode", TerritoryCode));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_EmpSApCodebyTerritory", aSqlParameterlist);

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
        public DataTable GetBankSAPMappingAccounTNo(string TerritoryCode)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@BankAccNo", TerritoryCode));

                DataTable dt = accessManager.GetDataTable("sp_Get_BankSAPMappingAccounTNo", aSqlParameterlist);

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
            public DataTable GetBankAccounTNo(string BankAccNo, string ComUnitId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@BankAccNo", BankAccNo));
                aSqlParameterlist.Add(new SqlParameter("@ComUnitId", ComUnitId));

                DataTable dt = accessManager.GetDataTable("sp_GET_BAnkInfoById_ByIdExcel", aSqlParameterlist);

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
        
        public DataTable GetEMPMap(string  EmpCode )
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@EmpCode", EmpCode)); 

                DataTable dt = accessManager.GetDataTable("sp_Get_Chk_EmpCode", aSqlParameterlist);

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
        
        
        public DataTable GetEMPDataExistCheck(string  EmpCode, string MonthValue , string YearValue )
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@EmpCode", EmpCode)); 
                aSqlParameterlist.Add(new SqlParameter("@MonthValue", MonthValue)); 
                aSqlParameterlist.Add(new SqlParameter("@YearValue", YearValue)); 

                DataTable dt = accessManager.GetDataTable("sp_Get_Chk_EMPDataExistCheck", aSqlParameterlist);

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
        
        public DataTable GetTerriMap( string TerritoryCode )
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                 
                aSqlParameterlist.Add(new SqlParameter("@TerritoryCode", TerritoryCode));

                DataTable dt = accessManager.GetDataTable("sp_Get_Chk_TerritoryCode", aSqlParameterlist);

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

        public DataTable GetSAP_StockReceivePendingData(string pram)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@Parm", pram));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_StockReceivePendingData", aSqlParameterlist);

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
        
        public DataTable GetSAP_StockReceivePendingDataDIC(string pram)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            int ComId= 0;


                if(HttpContext.Current.Session["RoleTypeName"].ToString()== "DIC")
                {
                    try
                    {
                        ComId = Convert.ToInt32(HttpContext.Current.Session["DICCompanyUnitId"].ToString());
                    }
                    catch
                    {

                    }

                }
                aSqlParameterlist.Add(new SqlParameter("@Parm", ComId.ToString()));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_DICStockReceivePendingData", aSqlParameterlist);

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
        public ResultInfo SaveStockReceive(string challanNo)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@ChallanNo", challanNo ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveBy", HttpContext.Current.Session["UserId"].ToString()));

                aInformation.isSuccess = accessManager.SaveData("sp_SAP_StockReceive", gSqlParameterList);

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



        public ResultInfo UpdateSAPQtyStockReceive(int ? StockMovementDetailId, Decimal ? quantity)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@StockMovementDetailId", StockMovementDetailId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@quantity", quantity ?? (object)DBNull.Value ?? (object)DBNull.Value));

                aInformation.isSuccess = accessManager.SaveData("sp_SAP_Up_StockReceiveQty", gSqlParameterList);

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
        public DataTable GetSAPStockDataById(string stockMovementId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@StockMovementMasterId", stockMovementId));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_StockReceivePendingDataById", aSqlParameterlist);

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


        public DataTable HideChallanByChallanNo(string ChallanNo)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@ChallanNo", ChallanNo));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_HideChallanByChallanNo", aSqlParameterlist);

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
        public DataTable GetSAP_EmpInfoDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_EmpInfo", aSqlParameterlist);
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

        public DataTable GetSAP_ProductInfoDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_SAP_ProductInfo", aSqlParameterlist);
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
        public DataTable CheckSAP_EmpInfoDAL(string femployee_id, string employee_code, string RoleType, string ActionStatus)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@femployee_id", femployee_id));
                aSqlParameterlist.Add(new SqlParameter("@employee_code", employee_code));
                aSqlParameterlist.Add(new SqlParameter("@RoleType", RoleType));
                aSqlParameterlist.Add(new SqlParameter("@ActionStatus", ActionStatus));

                DataTable dt = accessManager.GetDataTable("sp_Chk_SAP_EmpInfoCondition", aSqlParameterlist);
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


        public DataTable CheckSAP_ProductDAL(string femployee_id, string employee_code, string RoleType, string ActionStatus)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@femployee_id", femployee_id));
                aSqlParameterlist.Add(new SqlParameter("@employee_code", employee_code));
                aSqlParameterlist.Add(new SqlParameter("@RoleType", RoleType));
                aSqlParameterlist.Add(new SqlParameter("@ActionStatus", ActionStatus));

                DataTable dt = accessManager.GetDataTable("sp_Chk_SAP_EmpInfoCondition", aSqlParameterlist);
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
        public ResultInfo SaveEmpInfoDAL(string femployee_id, string employee_code, string RoleType, string ActionStatus)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@employee_id", femployee_id ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@employee_code", employee_code ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RoleType", RoleType ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ActionStatus", ActionStatus ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@UpdateBy", HttpContext.Current.Session["UserId"].ToString()));
                aInformation.isSuccess = accessManager.SaveData("sp_Upsertdate_EmpInfo", gSqlParameterList);

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


        public ResultInfo MakeRESTRequestWithUpdateChallan(string StoNo)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@StoNo", StoNo ?? (object)DBNull.Value ?? (object)DBNull.Value)); 
                gSqlParameterList.Add(new SqlParameter("@RcvBy", HttpContext.Current.Session["UserId"].ToString()));
                aInformation.isSuccess = accessManager.SaveData("MakeRESTRequest", gSqlParameterList);

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

        public ResultInfo SaveProductInfoDAL(string product_id , string  product_code , string  status )
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@product_id", product_id ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@product_code", product_code ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@status", status ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@UpdateBy", HttpContext.Current.Session["UserId"].ToString()));
                aInformation.isSuccess = accessManager.SaveData("sp_Upsertdate_ProductInfo", gSqlParameterList);

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

        public ResultInfo ApproveProviderDropoutIntrigrationDAL(long providerIDropoutIntrigrationd)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                gSqlParameterList.Add(new SqlParameter("@providerIDropoutIntrigrationd", providerIDropoutIntrigrationd));
                gSqlParameterList.Add(new SqlParameter("@ApproveBy", HttpContext.Current.Session["UserId"].ToString()));

                aInformation.isSuccess = accessManager.SaveData("sp_Up_ProviderDropoutIntrigrationApprove", gSqlParameterList);
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
