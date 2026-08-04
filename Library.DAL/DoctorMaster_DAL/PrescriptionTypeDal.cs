using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using SalesSolution.Web.Models;

namespace Library.DAL.DoctorMaster_DAL
{
    public class PrescriptionTypeDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public PrescriptionType GetPrescriptionForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                PrescriptionType master = new PrescriptionType();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_PrescriptionType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.PrescriptionTypeId = (int)dr["PrescriptionTypeId"];
                    master.PrescriptionTypename = dr["PrescriptionType"].ToString();

                    master.Activedate = (DateTime)dr["ActiveInactiveDate"];
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

        public DataTable GetPrescriptionTypeList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_PrescriptionTypeList");
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

    

        public ResultInfo Save_PrescriptionType(PrescriptionType prescription, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", prescription.PrescriptionTypeId));
                gSqlParameterList.Add(new SqlParameter("@PrescriptionType", prescription.PrescriptionTypename));

                gSqlParameterList.Add(new SqlParameter("@IsActive", prescription.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", prescription.Activedate));
                if (prescription.PrescriptionTypeId > 0)
                {

                    aSqlParameterList.Add(new SqlParameter("PrescriptionTypeId", prescription.PrescriptionTypeId));
                    aSqlParameterList.Add(new SqlParameter("PrescriptionType", prescription.PrescriptionTypename));
                    DataTable dt = accessManager.GetDataTable("sp_check_PrescriptionType", aSqlParameterList);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_Update_PrescriptionType", gSqlParameterList);
                        pk = prescription.PrescriptionTypeId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionType", gSqlParameterList);
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


        public ResultInfo Delete_PrescriptionType( Int32 DeleteId)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_PrescriptionType", gSqlParameterList);
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
