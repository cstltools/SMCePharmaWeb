using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class HistoricalReportBll
    {
        HistoricalReportDal aReportDal = new HistoricalReportDal();

        public DataTable  LoadHistoricalReportInfo(string fromDate, string toDate)
        {
            return aReportDal.GetHistoricalReportInfo(fromDate, toDate);
        }
    }
}
