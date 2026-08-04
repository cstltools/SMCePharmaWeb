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
   public  class DoctorCategoryDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();
        public ResultInfo SaveDoctorCategory(DoctorCategory doctorCategory, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@CategoryId ", doctorCategory.CategoryId));
                gSqlParameterList.Add(new SqlParameter("@CategoryName", doctorCategory.CategoryName));
                gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorCategory.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", doctorCategory.Activedate));
                if (doctorCategory.CategoryId > 0)
                {

                    aSqlParameterlist.Add(new SqlParameter("@CategoryId ", doctorCategory.CategoryId));
                    aSqlParameterlist.Add(new SqlParameter("@CategoryName", doctorCategory.CategoryName));
                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorCategory", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        bool result = accessManager.UpdateData("sp_Update_DoctorCategory", gSqlParameterList);
                        pk = doctorCategory.CategoryId;
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
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorCategory", gSqlParameterList);
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
        public DataTable GetDoctorCategoryList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorCategoryList");
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
        public DoctorCategory GetDoctorCategoryForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DoctorCategory master = new DoctorCategory();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));

                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Doctorcategory_ById", aSqlParameters);

                while (dr.Read())
                {
                    master.CategoryId = (int)dr["CategoryId"];
                    master.CategoryName = dr["CategoryName"].ToString();
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
        public ResultInfo DeleteDoctorcategory(Int32 DeleteId, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@CategoryId ", DeleteId));
                gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
                aInformation.isSuccess = accessManager.DeleteData("sp_Delete_DoctorCategory", gSqlParameterList);
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

    }
}
