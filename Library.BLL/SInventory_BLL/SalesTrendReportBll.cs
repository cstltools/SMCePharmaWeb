using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class SalesTrendReportBll
    {
        SalesTrendReportDal aTrendReportDal = new SalesTrendReportDal();

        public DataTable LoadSalesTrendInfo(DateTime fromDate, DateTime toDate)
        {
            return aTrendReportDal.GetSalesTrendInfo(fromDate, toDate);
        }

    }
}
