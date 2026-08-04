using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class CustomerPaymentDeleteBLL
    {
        CustomerPaymentDeleteDAL customerPaymentDeleteDAL = new CustomerPaymentDeleteDAL();

        public void LoadInvoicesByDateRange(DropDownList ddl, string ComUnitId, string selectedFromDateText, string selectedToDateText)
        {
            customerPaymentDeleteDAL.LoadInvoicesByDateRange(ddl, ComUnitId, selectedFromDateText, selectedToDateText);
        }
        public void LoadInvoicesByRoute(DropDownList ddl, string ComUnitId, string routeID)
        {
            customerPaymentDeleteDAL.LoadInvoicesByRoute(ddl, ComUnitId, routeID);
        }

        public DataTable LoadData(int invoiceId)
        {
            return customerPaymentDeleteDAL.LoadInvoiceReturn(invoiceId);
        }

        public bool DeleteCustomerPaymentDetail(int id, string remarks, string  LoginName )
        {
            return customerPaymentDeleteDAL.DeleteCustomerPaymentDetail(id,remarks, LoginName);
        }
    }
}
