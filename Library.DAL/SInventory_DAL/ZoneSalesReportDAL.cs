using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class ZoneSalesReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void LoadComUnit(DropDownList dropDownList)
        {
            string query = @"SELECT * from tblCompanyUnit ";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "ComUnitName", "ComUnitId", query, "SSIDB");
        }

        public void LoadComUnit(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT * from tblCompanyUnit where ComUnitId = @ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "ComUnitName", "ComUnitId", query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId))
            });
        }

        public void LoadZone(DropDownList dropDownList, string ComUnitId)
        {
            string query = @"SELECT * from tblZone where ComUnitId = @ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "ZoneName", "ZoneId", query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId == null ? null : ComUnitId.Trim()))
            });
        }

        public DataTable ZoneReportMainDataDAL(string zoneId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select (ZoneCode+':'+ZoneName) as ZoneDetail,ComUnitName,@FromDate as FromDate,@ToDate as ToDate
                             from tblZone
                             where ZoneId = @ZoneId";

            return SInventorySql.GetDataTable(query, ReportParameters(zoneId, fromDate, toDate));
        }

        public DataTable ZoneReportDetailDataDAL(string zoneId, DateTime fromDate, DateTime toDate)
        {
            string query =
                @"select ProductCode,Product, sum(TotalQuantity) as TotalQty ,sum(Price) as TotalAmount
                  from View_MIAWiseSalesReport
                  where MiaId in (select MiaId from tblMIAInfo where ZoneId = @ZoneId)
                  and InvoiceDate between @FromDate and @ToDate
                  group by ProductCode,Product";

            return SInventorySql.GetDataTable(query, ReportParameters(zoneId, fromDate, toDate));
        }

        private static List<SqlParameter> ReportParameters(string zoneId, DateTime fromDate, DateTime toDate)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ZoneId", SInventorySql.DbValue(zoneId == null ? null : zoneId.Trim())),
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            };
        }
    }
}
