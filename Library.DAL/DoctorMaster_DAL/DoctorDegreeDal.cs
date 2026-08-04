using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAO.DoctorModule_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.DoctorMaster_DAL
{
   public class DoctorDegreeDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        //public  static void SaveDoctorDegree(string Name, bool Is, string Activedate)
        //{
        //    string insertQuery = @"insert into tblDoctorDegree (DegreeName,IsActive,Activedate,EntryBy,EntryDate) 
        //    values (" + Name + ",'" + Is + "','" + Activedate + "')";
        //    return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");     
        //}

        public ResultInfo SaveDoctorDegree(DoctorDegreeDao doctorDegree)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@DegreeId ", doctorDegree.DegreeId));
                gSqlParameterList.Add(new SqlParameter("@DegreeName", doctorDegree.DegreeName));
                gSqlParameterList.Add(new SqlParameter("@DoctorTypeId", doctorDegree.DoctorTypeId));

                gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorDegree.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", doctorDegree.Activedate));

                if (doctorDegree.DegreeId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@DegreeId ", doctorDegree.DegreeId));
                    aSqlParameterlist.Add(new SqlParameter("@DegreeName", doctorDegree.DegreeName));
                    aSqlParameterlist.Add(new SqlParameter("@DoctorTypeId", doctorDegree.DoctorTypeId));

                    DataTable dt = accessManager.GetDataTable("sp_check_DoctorDegree", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", HttpContext.Current.Session["UserId"]));
                        bool result = accessManager.UpdateData("sp_Update_DoctorDegree", gSqlParameterList);
                        pk = doctorDegree.DegreeId;
                        aInformation.isSuccess = result;
                    }

                    else
                    {
                        aInformation.isSuccess = false;
                    }

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", HttpContext.Current.Session["UserId"]));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorDegree", gSqlParameterList);
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


        public DataTable GetDoctorDegreeList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorDegreeList");
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

        public DataTable GetDoctorDegreeEditdata(string id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", id));
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorDegree_ById", aSqlParameterlist);
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

    }
}
