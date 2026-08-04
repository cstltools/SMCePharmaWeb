
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;

namespace SalesSolution.Web.DataLayer
{
    public class TourTypeDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
      

        public DataTable GetTourPlanDetailsViewDatabyID(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);


                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPlanDetailsById", aSqlParameters);
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

        public DataTable Get_TourPlanBalanceDAL(int empId, int month, int year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);


                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
            
                aSqlParameters.Add(new SqlParameter("@EmpInfoId", empId));
                aSqlParameters.Add(new SqlParameter("@Month", month));
                aSqlParameters.Add(new SqlParameter("@year", year));
                DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_TourPlanBalance", aSqlParameters);
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
        public DataTable GetTourTypeList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TourType");
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

        public ResultInfo DeleteTourType(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TourTypeId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_TourType", gSqlParameterList);
                aInformation.isSuccess = result;
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
       
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable GetTourPlanList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPlanMasteList", aSqlParameters);
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

        

        public DataTable GetTourPlanReport(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPlanMasteList", aSqlParameters);
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


        public ResultInfo SaveTourType(TourType tourType, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TourTypeId", tourType.TourTypeId));
                gSqlParameterList.Add(new SqlParameter("@TourTypeName", tourType.TourTypeName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", tourType.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", tourType.Activedate));
                if (tourType.TourTypeId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    bool result = accessManager.UpdateData("sp_Update_TourType", gSqlParameterList);
                    aInformation.isSuccess = result;
                    pk = tourType.TourTypeId;
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TourType", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
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
        public TourType GetTourTypeForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                TourType master = new TourType();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_TourType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.TourTypeId = (int)dr["TourTypeId"];
                    master.TourTypeName = dr["TourTypeName"].ToString();
                    try { master.Activedate = (DateTime)dr["Activedate"]; }
                    catch(Exception exx)
                    {
                        master.Activedate = null;
                    }
                    master.IsActive = Convert.ToBoolean(dr["IsActive"]);
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


        public DataTable GetTourPlanUserYear_Active()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPlanYear");
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

        public List<TourPlanMaster> GetPurchaseMasterInfoParam(string Parm)
        {
            try
            {
                var aList = new List<TourPlanMaster>();

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_TourPlanUserListByParm", aSqlParameterlist);

                TourPlanMaster aSalesInfo;

                if (dr != null)
                {
                    while (dr.Read())
                    {
                        aSalesInfo = new TourPlanMaster();

                        aSalesInfo.TPMaster = (int)dr["TPMaster"];
                        aSalesInfo.MonthValue = (int)dr["MonthValue"];
                        aSalesInfo.YearValue = (int)dr["YearValue"];
                        aList.Add(aSalesInfo);
                    }
                }

                return aList;
            }
            catch (Exception)
            {

                throw;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }
        }


        #region Tour_Purpose
        public ResultInfo DeleteTourPurpose(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TourPurposeId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_TourPurpose", gSqlParameterList);
                aInformation.isSuccess = result;
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
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }
        public DataTable GetTourPurposeList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPurposeDDL");
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

        public ResultInfo Approve_TourPlanList(string Id, string rbValue, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TPMaster", Id));
                gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
                aInformation.isSuccess = accessManager.UpdateData("sp_ApproveTourPlanInformation", gSqlParameterList);

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


        public ResultInfo Approve_VisitPlanList(string Id, string rbValue, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TPMaster", Id));
                gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
                aInformation.isSuccess = accessManager.UpdateData("sp_ApproveVisitPlanInformation", gSqlParameterList);

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

        public ResultInfo SaveTourPurpose(TourPurpose tourPurpose, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TPId", tourPurpose.TPId));
                gSqlParameterList.Add(new SqlParameter("@TPName", tourPurpose.TPName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsActive", tourPurpose.IsActive ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Activedate", tourPurpose.Activedate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsMarketVisit", tourPurpose.IsMarketVisit ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsOtherVisit", tourPurpose.IsOtherVisit ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MIOAmount", tourPurpose.MIOAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AMAmount", tourPurpose.AMAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DZSMAmount", tourPurpose.DZSMAmount ?? (object)DBNull.Value));
                if (tourPurpose.TPId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    bool result = accessManager.UpdateData("sp_Update_TourPurpose", gSqlParameterList);
                    aInformation.isSuccess = result;
                    pk = tourPurpose.TPId;
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TourPurpose", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
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
        public TourPurpose GetTourPurposeForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                TourPurpose master = new TourPurpose();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_TourPurpose_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.TPId = (int)dr["TPId"];
                    master.TPName = dr["TPName"].ToString();
                    master.Activedate = (DateTime)dr["Activedate"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"]);
                    master.MIOAmount = Convert.ToDecimal(dr["MIOAmount"]);
                    master.AMAmount = Convert.ToDecimal(dr["AMAmount"]);
                    master.DZSMAmount = Convert.ToDecimal(dr["DZSMAmount"]);
                    master.IsMarketVisit = Convert.ToInt32(dr["IsMarketVisit"]);
                    master.IsOtherVisit = Convert.ToInt32(dr["IsOtherVisit"]);
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
        #endregion

    }
}