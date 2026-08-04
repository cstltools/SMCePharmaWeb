using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class SalesComparisoneReportBll
    {
        SalesComparisoneReportDal aStockMonitoringDal = new SalesComparisoneReportDal();

        public DataTable LoadSalesComparisoneInfo(DateTime date)
        {
            return aStockMonitoringDal.LoadSalesComparisoneInfo(date);
        }
    }
}
