using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class SalesTrendReportDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetSalesTrendInfo(DateTime fromDate, DateTime toDate)
        {
            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@FromDate", fromDate));
            aSqlParameters.Add(new SqlParameter("@ToDate", toDate));

            return aCommonInternalDal.GetDataTableAction("sp_GET_MonthwiseSale", aSqlParameters, "SSIDB");
        }
    }
}
