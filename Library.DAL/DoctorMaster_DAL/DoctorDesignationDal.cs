using Library.DAL.DataManager;
using Library.DAO.DoctorModule_DAO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using SalesSolution.Web.Models;

namespace Library.DAL.DoctorModule_DAL
{
   public class DoctorDesignationDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();

        public DoctorDesignation GetDoctorDesignationForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DoctorDesignation master = new DoctorDesignation();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorDesignation_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.DesignationId = (int)dr["DesignationId"];
                    master.DesignationName = dr["DesignationName"].ToString();
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
        public ResultInfo SaveDoctorDesignation(DoctorDesignation doctorDesignation, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@DesignationId ", doctorDesignation.DesignationId));
                gSqlParameterList.Add(new SqlParameter("@DesignationName", doctorDesignation.DesignationName));
                gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorDesignation.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", doctorDesignation.Activedate));

                if (doctorDesignation.DesignationId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@DesignationId ", doctorDesignation.DesignationId));
                    aSqlParameterlist.Add(new SqlParameter("@DesignationName", doctorDesignation.DesignationName));
                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorDesignation", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_Update_DoctorDesignation", gSqlParameterList);


                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorDesignation", gSqlParameterList);
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
        public DataTable GetDoctorDesignationList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorDesignationList");
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


        public ResultInfo DeleteDoctorDesignation(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@DesignationId", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                bool result = accessManager.DeleteData("sp_Delete_DoctorDesignation", gSqlParameterList);
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
