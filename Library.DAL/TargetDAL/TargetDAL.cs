using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;
using Library.DAO.Target_DAO;

namespace Library.DAL.TargetDAL
{
    public class TargetDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveMonthlyTarget(TargetDAO aTargetDao)
        {
            string insertQuery = @"
	 declare @CountData int
SELECT @CountData=COUNT(*) FROM dbo.tblMonthlyTarget WHERE Year='" + aTargetDao.Year + "' and Month='" + aTargetDao.Month + "'"+@" IF(@CountData=0)
 BEGIN 
INSERT INTO dbo.tblMonthlyTarget
                                (
                                    Year,
                                    Month,
                                    Date,
                                    FinYearId,
                                    Amount,EntryBy,EntryDate
                                )
                                VALUES
                                ('" + aTargetDao.Year+ "'," +
                                 "'" + aTargetDao.Month+ "',"+
                                 "'" + aTargetDao.Date+ "',"+
                                 "'" + aTargetDao.FinYearId+ "',"+
                                 "'" + aTargetDao.Amount+ "','" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "'" + DateTime.Now + "') end";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool UpdateMonthlyTarget(TargetDAO aTargetDao)
        {
            string insertQuery = @"UPDATE dbo.tblMonthlyTarget SET Year='" + aTargetDao.Year + "'," +
                                 "Month='" + aTargetDao.Month + "'," +
                                 "Date='" + aTargetDao.Date + "'," +
                                 "FinYearId='" + aTargetDao.FinYearId+ "'," +
                                 "Amount='" + aTargetDao.Amount + "'," +
                                 "UpdateBy='" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "UpdateDate='" + DateTime.Now + "' WHERE MTargetId='"+aTargetDao.MTargetId+"'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }

        public DataTable LoadMonthlyTarget()
        {
            string query = @"SELECT   CASE WHEN mas.Month=1 THEN 'January' WHEN mas.Month=2 THEN 'February' WHEN mas.Month=3 THEN 'March' WHEN mas.Month=4 THEN 'April' WHEN mas.Month=5 THEN 'May' WHEN mas.Month=6 THEN 'June'  WHEN mas.Month=7 THEN 'July' WHEN mas.Month=8 THEN 'August' WHEN mas.Month=9 THEN 'September'  WHEN mas.Month=10 THEN 'October'  WHEN mas.Month=11 THEN 'November'  WHEN mas.Month=12 THEN 'December' ELSE '' END  [MonthName]    ,* FROM dbo.tblMonthlyTarget mas WITH (nolock)";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable CheckLoadMonthlyTarget(string Year, string Month, string Id)
        {
            string query = @"SELECT * FROM dbo.tblMonthlyTarget WHERE Year='"+ Year + "' AND Month='"+ Month + "' AND  MTargetId NOT IN ( '"+ Id + "')";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadMonthlyTargetById(string id)
        {
            string query = @"SELECT * FROM dbo.tblMonthlyTarget WHERE MTargetId='"+id+"' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
