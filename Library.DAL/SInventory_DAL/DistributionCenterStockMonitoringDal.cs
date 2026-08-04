using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class DistributionCenterStockMonitoringDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetDcStockMonitoringInfo()
        {
            return aCommonInternalDal.GetDataTableAction("sp_GET_AllStockProductwise", "SSIDB");
        }
        public DataTable EmployeewiseProductSales()
        {
            return aCommonInternalDal.GetDataTableAction("sp_GET_EmployeeWiseProductSale", "SSIDB");
        }
    }
}
