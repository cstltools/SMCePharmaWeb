using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.DoctorVisit_DAL
{
  public  class DoctorVisitDAL
    {

        private DataAccessManager  accessManager = new DataAccessManager ();


        public DataTable GetDoctorPlanDetailsViewDatabyID(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);


                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorPlanDetailsById", aSqlParameters);
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


        public DataTable GetDCRReportDataById(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);


                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                DataTable dt = accessManager.GetDataTable("sp_Rpt_DCRInfo_ById", aSqlParameters);
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

        public DataTable GetDoctorVisitList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorTourPlanMasteList", aSqlParameters);
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

        public DataTable DynamicPivotDoctorWiseDoctorVisitPlan(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDoctorVisitPlan", aSqlParameters);
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

        public DataTable GetDoctorDailyVisitList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_DCRInfoList", aSqlParameters);
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

        public DataTable GetDCRList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_DCRInfoListForView", aSqlParameters);
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
                    master.Activedate = (DateTime)dr["Activedate"];
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


        internal DataTable GetTourPlanUserYear_Active()
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
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPurpose");
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
                gSqlParameterList.Add(new SqlParameter("@TPName", tourPurpose.TPName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", tourPurpose.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", tourPurpose.Activedate));
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


        public ResultInfo Approve_DoctorPlanList(string Id, string rbValue, string SessionUser)
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
                aInformation.isSuccess = accessManager.UpdateData("sp_ApproveDoctorTourPlanMaster", gSqlParameterList);

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
 