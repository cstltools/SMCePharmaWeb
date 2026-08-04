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
    public class DoctorSpecailDayDal
    {


        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo SaveDoctorSpeacialDay(DoctorSpecailDay doctorSpecailDay, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@SpecialDayId", doctorSpecailDay.SpecialDayId));
                gSqlParameterList.Add(new SqlParameter("@SpecialDay", doctorSpecailDay.SpecialDay));
                gSqlParameterList.Add(new SqlParameter("@IsActive", doctorSpecailDay.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", doctorSpecailDay.Activedate));
                if (doctorSpecailDay.SpecialDayId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@SpecialDayId", doctorSpecailDay.SpecialDayId));
                    aSqlParameterlist.Add(new SqlParameter("@SpecialDay", doctorSpecailDay.SpecialDay));
                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorSpecialDay", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_Update_DoctorSpecialDay", gSqlParameterList);
                     
                        pk = doctorSpecailDay.SpecialDayId;
                      
                    }

                    else
                    {

                        aInformation.isSuccess = false;
                    }

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorSpecialDay", gSqlParameterList);

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

        public DoctorSpecailDay GetDoctorSpecialDayForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DoctorSpecailDay master = new DoctorSpecailDay();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorSpeacialDay_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.SpecialDayId = (int)dr["SpecialDayId"];
                    master.SpecialDay = dr["SpecialDay"].ToString();
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

        public DataTable GetDoctorSpecialDayList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorSpecailDayList");
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

        public ResultInfo DeleteDoctorSpecialDay(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@SpecialDayId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_DoctorSpecailDay", gSqlParameterList);
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
