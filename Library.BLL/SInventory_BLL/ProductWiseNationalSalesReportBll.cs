using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class ProductWiseNationalSalesReportBll
    {
        ProductWiseNationalSalesReportDal aNationalSalesReportDal = new ProductWiseNationalSalesReportDal();

        public DataTable LoadProductWiseNationalSalesInfo(DateTime fromDate)
        {
            return aNationalSalesReportDal.GetProductWiseNationalSalesInfo(fromDate);
        }

        public DataTable LoadProductWiseNationalSalesInfoZoneWise(DateTime fromDate)
        {
            return aNationalSalesReportDal.GetProductWiseNationalSalesInfoZoneWise(fromDate);
        }
    }
}
