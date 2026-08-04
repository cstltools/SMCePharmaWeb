using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.DataManager;

namespace Library.DAL.DoctorInfo_DAL
{   
    
    public class DoctorInfoReportDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();
        public DataTable Get_Dactor_Information_Report(string frmDate, string toDate, string Url)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();




                aSqlParameterlist.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Url));
                DataTable dt = accessManager.GetDataTable("sp_RPT_DoctorInfoReport", aSqlParameterlist);
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


        public DataTable GetLastProessDate(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_SMCFamilyDoctorLastProcessDate", aSqlParameterlist);
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


        public DataTable GetTerritoryWiseLastProessDate(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_DZSMProcessDate", aSqlParameterlist);
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

        public DataTable Get_Dactor_Information_MIO_Wise(string frmDate, string toDate, string Zone, string Area, string Teritory, string Url)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();


                aSqlParameterlist.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Url));
                aSqlParameterlist.Add(new SqlParameter("@Zone", Zone ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Area", Area ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Teritory", Teritory ?? (object)DBNull.Value));


                DataTable dt = accessManager.GetDataTable("sp_Rpt_MIOwiseDoctorWeek", aSqlParameterlist);
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


        public DataTable Get_Dactor_Information_Zone_Wise(string frmDate, string toDate, string Zone,  string Url)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();


                aSqlParameterlist.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Url));
                aSqlParameterlist.Add(new SqlParameter("@Zone", Zone ?? (object)DBNull.Value));
              

                DataTable dt = accessManager.GetDataTable("sp_Rpt_ZonewiseDoctorWeek", aSqlParameterlist);
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



        public DataTable Get_Dactor_Information_Area_Wise(string frmDate, string toDate, string Zone, string Area, string Url)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();


                aSqlParameterlist.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Url));
                aSqlParameterlist.Add(new SqlParameter("@Zone", Zone ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Area", Area ?? (object)DBNull.Value));


                DataTable dt = accessManager.GetDataTable("sp_Rpt_AreawiseDoctorWeek", aSqlParameterlist);
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


        public DataTable Get_Dactor_Information_Doc_Wise(string frmDate, string toDate, string Zone, string Area,   string Teritory, string Url)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Url));
                aSqlParameterlist.Add(new SqlParameter("@Zone", Zone ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Area", Area ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Teritory", Teritory ?? (object)DBNull.Value));

                DataTable dt = accessManager.GetDataTable("sp_Rpt_DoctorwiseDoctorWeek", aSqlParameterlist);
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


        public DataTable Get_Dactor_Information_Details(string frmDate, string toDate, string Zone, string Area, string Teritory, string Url)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Url));
                aSqlParameterlist.Add(new SqlParameter("@Zone", Zone ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Area", Area ?? (object)DBNull.Value));
                aSqlParameterlist.Add(new SqlParameter("@Teritory", Teritory ?? (object)DBNull.Value));

                DataTable dt = accessManager.GetDataTable("sp_Rpt_SMCFamilyDoctorReport_ProcessData", aSqlParameterlist);
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




        

    }
}
