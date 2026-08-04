using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text; 

namespace Library.DAL.Doctor_Monitoring_DAL
{
    public class DoctorMonitoringDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public DataTable GetDoctorVisitMonitoringApprovalList(string param, string FromDate, string ToDate,string GroupId, string ZonId, string Area, string Terr)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@param", param));
                aSqlParameterlist.Add(new SqlParameter("@frmDate", FromDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", ToDate));
                aSqlParameterlist.Add(new SqlParameter("@GroupId", GroupId));
                aSqlParameterlist.Add(new SqlParameter("@ZonId", ZonId));
                aSqlParameterlist.Add(new SqlParameter("@AreaId", Area));
                aSqlParameterlist.Add(new SqlParameter("@TerrId", Terr));

                DataTable dt = accessManager.GetDataTable("sp_Get_AllDoctorVisitMonitoringApprovalList", aSqlParameterlist);
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
