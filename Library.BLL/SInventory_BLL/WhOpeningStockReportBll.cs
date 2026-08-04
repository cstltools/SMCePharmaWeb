using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class WhOpeningStockReportBll
    {
        WhOpeningStockReportDal aOpeningStockReportDal = new WhOpeningStockReportDal();

        public DataTable LoadAllWhOpeningStockReport(string date)
        {
            return aOpeningStockReportDal.GetWhOpeningStockReport(date);
        }

        public DataTable CompanyInfoBLL()
        {
            return aOpeningStockReportDal.CompanyInformation();
        }
    }
}
