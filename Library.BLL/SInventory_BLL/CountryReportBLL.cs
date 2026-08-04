using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class CountryReportBLL
    {
        CountryStockReportDAL aCountryStockReportDal = new CountryStockReportDAL();

        

        public DataTable CountryReportMainDataBLL(string productCode)
        {
            return aCountryStockReportDal.CountryReportMainDataDAL(productCode);
        }
        public DataTable CountryReportDetailDataBLL(string productCode)
        {
            return aCountryStockReportDal.CountryReportDetailDataDAL(productCode);
        }
        public DataTable CountryReportDetailWithoutProductCodeDataBLL()
        {
            return aCountryStockReportDal.CountryReportWithoutProductCodeDetailDataDAL();
        }
    }
}
