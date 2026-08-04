using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class WhStockMonitoringReportBll
    {
        WhStockMonitoringReportDal aMonitoringReportDal = new WhStockMonitoringReportDal();
        
        public DataTable LoadWhStokMonitoringInformation(DateTime fromDate, DateTime toDate)
        {
            return aMonitoringReportDal.GetWhStokMonitoringInformation(fromDate, toDate);
        }

        public DataTable LoadWhStokMonitoringReportInformation(DateTime fromDate, DateTime toDate)
        {
            return aMonitoringReportDal.GetWhStokMonitoringReportInformation(fromDate, toDate);
        }
    }
}
