using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.DoctorMaster_Dao;
using SalesSolution.Web.Models;

namespace Library.DAL.DoctorMaster_DAL
{
    public class PatientTypeDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo SaveDoctorpatientType(PatientTypeDao patientType, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@PatientTypeId", patientType.PatientTypeId));
                gSqlParameterList.Add(new SqlParameter("@PatientType", patientType.PatientType));
                gSqlParameterList.Add(new SqlParameter("@IsActive", patientType.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", patientType.Activedate));
                if (patientType.PatientTypeId > 0)
                {


                    aSqlParameterlist.Add(new SqlParameter("@PatientTypeId", patientType.PatientTypeId));
                    aSqlParameterlist.Add(new SqlParameter("@PatientType", patientType.PatientType));
                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorPatientType", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        bool result = accessManager.UpdateData("sp_Update_DoctorPatientType", gSqlParameterList);
                        pk = patientType.PatientTypeId;
                        aInformation.isSuccess = result;
                    }

                    else
                    {

                        aInformation.isSuccess = false;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorPatientType", gSqlParameterList);
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


        public DataTable GetDoctorPatientTypeList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorPatientList");
                return dt;
            }
            catch (Exception e)
            {
                accessManager.SqlConnectionClose(true);
                throw e;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public PatientTypeDao GetDoctorPatientTypeForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                PatientTypeDao master = new PatientTypeDao();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorPatientType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.PatientTypeId = (int)dr["PatientTypeId"];
                    master.PatientType = dr["PatientType"].ToString();
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

        public ResultInfo DeleteDoctorPatientType(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@PatientTypeId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_DoctorpatientType", gSqlParameterList);
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

    }
}
