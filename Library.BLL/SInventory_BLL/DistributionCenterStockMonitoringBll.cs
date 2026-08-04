using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class DistributionCenterStockMonitoringBll
    {
        DistributionCenterStockMonitoringDal aStockMonitoringDal = new DistributionCenterStockMonitoringDal();

        public DataTable LoadDcStockMonitoringInfo()
        {
            return aStockMonitoringDal.GetDcStockMonitoringInfo();
        }
        public DataTable EmployeewiseProductSales()
        {
            return aStockMonitoringDal.EmployeewiseProductSales();
        }
    }
}
