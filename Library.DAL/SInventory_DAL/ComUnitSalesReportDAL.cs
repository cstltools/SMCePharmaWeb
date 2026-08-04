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
    public class ComUnitSalesReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public void LoadComUnit(DropDownList dropDownList)
        {
            string query = @"SELECT * from tblCompanyUnit ";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "ComUnitName", "ComUnitId", query, "SSIDB");
        }

        public void LoadComUnit(DropDownList dropDownList,string comUnitId)
        {
            string query = @"SELECT * from tblCompanyUnit where ComUnitId=@ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "ComUnitName", "ComUnitId", query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId == null ? null : comUnitId.Trim()))
            });
        }
        
        public DataTable ComUnitReportMainDataDAL(string comunitId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select (ComUnitCode+':'+ComUnitName) as ComUnitDetail,@FromDate as FromDate,@ToDate as ToDate
from tblCompanyUnit where ComUnitId=@ComUnitId";

            return SInventorySql.GetDataTable(query, ComUnitReportParameters(comunitId, fromDate, toDate));
        }

        public DataTable ComUnitReportDetailDataDAL(string comUnitId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select ProductCode,Product, sum(TotalQuantity) as TotalQty ,sum(Price) as TotalAmount
from View_MIAWiseSalesReport
where ComUnitId=@ComUnitId and InvoiceDate between @FromDate and @ToDate
group by ProductCode,Product";


            return SInventorySql.GetDataTable(query, ComUnitReportParameters(comUnitId, fromDate, toDate));
        }

        private List<SqlParameter> ComUnitReportParameters(string comUnitId, DateTime fromDate, DateTime toDate)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId == null ? null : comUnitId.Trim())),
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            };
        }
    }
}
