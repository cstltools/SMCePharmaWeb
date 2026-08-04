using Library.DAL.DataManager;
using Library.DAO.DoctorModule_DAO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using SalesSolution.Web.Models;

namespace Library.DAL.DoctorMaster_DAL
{
    public class DoctorSpecialityDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo SaveDoctorSpeaciality(DoctorSpeciality speciality, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@SpecialityId", speciality.SpecialityId));
                gSqlParameterList.Add(new SqlParameter("@SpecialityName", speciality.SpecialityName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", speciality.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", speciality.Activedate));
                if (speciality.SpecialityId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@SpecialityId", speciality.SpecialityId));
                    aSqlParameterlist.Add(new SqlParameter("@SpecialityName", speciality.SpecialityName));
                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorSpeciality", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        bool result = accessManager.UpdateData("sp_Update_DoctorSpeciality", gSqlParameterList);
                        aInformation.isSuccess = result;
                        pk = speciality.SpecialityId;
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
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorSpeciality", gSqlParameterList);
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

        public DoctorSpeciality GetDoctorSpecialityForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DoctorSpeciality master = new DoctorSpeciality();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorSpeciality_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.SpecialityId = (int)dr["SpecialityId"];
                    master.SpecialityName = dr["SpecialityName"].ToString();
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

        public DataTable GetDoctorSpecialityList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorSpecialityList");
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

        public ResultInfo DeleteDoctorSpeciality(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@SpecialityId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_DoctorSpeciality", gSqlParameterList);
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
