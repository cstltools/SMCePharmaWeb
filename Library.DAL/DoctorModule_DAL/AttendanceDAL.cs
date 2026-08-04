
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;

namespace SalesSolution.Web.DataLayer
{
    public class AttendanceDAL
    {

        private DataAccessManager  accessManager = new DataAccessManager ();
        public ResultInfo Save_ShiftInfo(Employee_ShiftInfosDAO doctorDegree, string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ShiftId ", doctorDegree.ShiftId));
                gSqlParameterList.Add(new SqlParameter("@ShiftText", doctorDegree.ShiftText));
                gSqlParameterList.Add(new SqlParameter("@ShiftInTime", doctorDegree.ShiftInTime));
                gSqlParameterList.Add(new SqlParameter("@ShiftOutTime", doctorDegree.ShiftOutTime));
         



                gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorDegree.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", doctorDegree.Activedate));

                if (doctorDegree.ShiftId > 0)
                {


                    aSqlParameterlist.Add(new SqlParameter("@ShiftId ", doctorDegree.ShiftId));
                    aSqlParameterlist.Add(new SqlParameter("@ShiftText", doctorDegree.ShiftText));
                    DataTable dt = accessManager.GetDataTable("sp_check_Employee_ShiftInfos", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        bool result = accessManager.UpdateData("sp_Update_Employee_ShiftInfos", gSqlParameterList);
                        pk = doctorDegree.ShiftId;
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
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ShiftInfos", gSqlParameterList);
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

        public Employee_ShiftInfosDAO GetShiftInfoEditData(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                Employee_ShiftInfosDAO master = new Employee_ShiftInfosDAO();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));

                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Employee_ShiftInfos_ById", aSqlParameters);

                while (dr.Read())
                {
                    master.ShiftId = (int)dr["ShiftId"];
                    master.ShiftText = dr["ShiftText"].ToString();
                    master.ShiftInTime =  dr["ShiftInTime"].ToString();
                    master.ShiftOutTime =  dr["ShiftOutTime"].ToString();
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


        public DataTable GetShiftList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_Employee_ShiftInfosList");
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

        public DataTable Get_Emp_AttendanceInfoList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_Emp_AttendanceInfoList", aSqlParameters);
                //for(int i;)
                //string imagefullpath = (dt.Rows[i]["ImagePreName"].ToString() + ((int)dr["PrescriptionId"]).ToString() + ".jpg");


                //try
                //{
                //    byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
                //    master.ImageString = Convert.ToBase64String(imageArray);
                //    master.ImagePreName = imagefullpath;

                //}
                //catch (Exception ex)
                //{

                //}
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


        public DataTable Get_Emp_AttendanceInfoListRowDay(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_Emp_AttendanceInfoDayRow", aSqlParameters);
                //for(int i;)
                //string imagefullpath = (dt.Rows[i]["ImagePreName"].ToString() + ((int)dr["PrescriptionId"]).ToString() + ".jpg");


                //try
                //{
                //    byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
                //    master.ImageString = Convert.ToBase64String(imageArray);
                //    master.ImagePreName = imagefullpath;

                //}
                //catch (Exception ex)
                //{

                //}
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


        public DataTable Get_AttendanceList_Approval()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_Emp_AttendanceInfoListPending");
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

        public ResultInfo ApprovalAttendanceListInfo(string Id, bool? rbValue, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@AttendanceId", Id));
                gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
                aInformation.isSuccess = accessManager.UpdateData("sp_ApproveAttendanceInformation", gSqlParameterList);

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