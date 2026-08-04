using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class CompanySalesReportBLL
    {
        CompanySalesReportDAL aCompanySalesReportDal = new CompanySalesReportDAL();



        public DataTable SalesReturnReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.SalesReturnReportDAl(districtId, fromDate, toDate);
        }
        public DataTable SalesReturnReportNationalDAl( DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.SalesReturnReportNationalDAl(fromDate, toDate);
        }





        public DataTable CompanySalesReportMainDataBLL(DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.CompanyReportMainDataDAL(fromDate, toDate);
        }
        public DataTable CompanySalesReportDetailDataBLL(DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.CompanyReportDetailDataDAL(fromDate, toDate);
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable SalesReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.SalesReportDAl(districtId, fromDate, toDate);
        }
        public DataTable GetInvoceLifecycleReport(int districtId, DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.GetInvoceLifecycleReport(districtId, fromDate, toDate);
        }
        public DataTable SalesRejecionReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.SalesReectionReportDAl(districtId, fromDate, toDate);
        }
        public DataTable SalesRejecionReportDAl(DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.SalesReectionReportDAl(fromDate, toDate);
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable DeliveryReturnReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.DeliveryReturnReportDAl(districtId, fromDate, toDate);
        }
        public DataTable DeliveryReturnReportDAl(DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.DeliveryReturnReportDAl(fromDate, toDate);
        }

        public DataTable SalesReportDAl(DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.SalesReportDAl(fromDate, toDate);
        }
        public DataTable CustomerPaymentBLL(string PaymentStatus, DateTime fromDate, DateTime toDate, string salesCenter)
        {
            return aCompanySalesReportDal.CustomerPaymentDAl(PaymentStatus, fromDate, toDate, salesCenter);
        }
        public DataTable CustomerPaymentBLL(string PaymentStatus, DateTime fromDate, DateTime toDate)
        {
            return aCompanySalesReportDal.CustomerPaymentDAl(PaymentStatus, fromDate, toDate);
        }
        public DataTable SalesReportDAlParameter(DateTime fromDate, DateTime toDate, string parameter)
        {
            return aCompanySalesReportDal.SalesReportDAlParameter(fromDate, toDate, parameter);
        }
    }
}
