using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class DeleteOrderReportBll
    {
        DeleteOrderReportDal aOrderReportDal = new DeleteOrderReportDal();

        public void LoadSalesCenter(DropDownList ddl)
        {
            aOrderReportDal.GetSalesCenter(ddl);
        }

        public void LoadCustomer(DropDownList ddl)
        {
            aOrderReportDal.GetCustomer(ddl);
        }

        public DataTable LoadDeleteOrderReport(string comUnitCode, string fromDate, string toDate)
        {
            return aOrderReportDal.GetDeleteOrderReport(comUnitCode, fromDate, toDate);
        }

        public DataTable LoadDeleteOrderNationalReport(string comUnitCode, string fromDate, string toDate)
        {
            return aOrderReportDal.GetDeleteOrderNationalReport(comUnitCode, fromDate, toDate);
        }
    }
}
