using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class DayWiseBusinessReportBll
    {
        DayWiseBusinessReportDal aBusinessReportDal = new DayWiseBusinessReportDal();

        public DataTable LoadDayWiseBusinessInfo(DateTime fromDate, DateTime toDate)
        {
            return aBusinessReportDal.GetDayWiseBusinessInfo(fromDate, toDate);
        }
    }
}
