using Library.DAL.DataManager;
using Library.DAL.InternalCls;
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
   public class DoctorChamberDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo SaveDoctorChamber(DoctorChamber doctorChamber, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ChamberId ", doctorChamber.ChamberId));
                gSqlParameterList.Add(new SqlParameter("@ChamberName", doctorChamber.ChamberName));
                gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorChamber.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", doctorChamber.Activedate));
                if (doctorChamber.ChamberId > 0)
                {

                    aSqlParameterlist.Add(new SqlParameter("@ChamberId ", doctorChamber.ChamberId));
                    aSqlParameterlist.Add(new SqlParameter("@ChamberName", doctorChamber.ChamberName));
                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorChamber", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        bool result = accessManager.UpdateData("sp_Update_DoctorChamber", gSqlParameterList);
                        pk = doctorChamber.ChamberId;
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
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorChamber", gSqlParameterList);
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

        public DataTable GetDoctorChamberList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorChamberList");
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

        public DoctorChamber GetDoctorChamberForEditt(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DoctorChamber master = new DoctorChamber();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorChamber_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.ChamberId = (int)dr["ChamberId"];
                    master.ChamberName = dr["ChamberName"].ToString();
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

        public ResultInfo DeleteDoctorchamber(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ChamberId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_DoctorChamber", gSqlParameterList);
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
