using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class CWMonthlyInventoryReportBll
    {
        CWMonthlyInventoryReportDal aReportDal = new CWMonthlyInventoryReportDal();

        public DataTable LoadCWMonthlyInventoryReport(string fromDate, string toDate)
        {
            return aReportDal.GetCWMonthlyInventoryReport(fromDate, toDate);
        }
    }
}
