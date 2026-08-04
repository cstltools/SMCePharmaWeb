using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class AuditReportOneBll
    {
        AuditReportOneDal aOrderReportDal = new AuditReportOneDal();

        public void LoadSalesCenter(DropDownList ddl)
        {
            aOrderReportDal.GetSalesCenter(ddl);
        }

        public void LoadCustomer(DropDownList ddl)
        {
            aOrderReportDal.GetCustomer(ddl);
        }

        public DataTable LoadDeleteOrderReport(string parameter)
        {
            return aOrderReportDal.GetDeleteOrderReport(parameter);
        }

        public DataTable LoadDeleteOrderNationalReport(string parameter)
        {
            return aOrderReportDal.GetDeleteOrderNationalReport(parameter);
        }
    }
}
