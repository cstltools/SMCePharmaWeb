using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAL.MAIN_FUNCTION;
using Library.DAO.SInventory_Entities;
namespace Library.DAL.SInventory_DAL
{
    public class CustomerPaymentDeleteDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public void LoadInvoicesByDateRange(DropDownList ddl, string ComUnitId, string selectedFromDateText, string selectedToDateText)
        {
            DateTime fromDate = Convert.ToDateTime(selectedFromDateText);
            DateTime toDate = Convert.ToDateTime(selectedToDateText);
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT INV.InvoiceNo, INV.InvoiceId 
                                FROM tblInvoice AS INV 
                                INNER JOIN tblCustPayDetail AS CPD ON INV.InvoiceId = CPD.InvoiceId
                                WHERE INV.InvoiceDate BETWEEN @FromDate AND @ToDate AND INV.ComUnitId = @ComUnitId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "InvoiceNo", "InvoiceId", queryStr, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate),
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId))
            });
        }
          public void LoadInvoicesByRoute(DropDownList ddl, string ComUnitId,  string routeID)
        {
            
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT mas.CustomerCode+' : '+mas.CustomerName+' ['+ INV.InvoiceNo+']' InvoiceNo, INV.InvoiceId 
                                FROM tblInvoice AS INV  with (nolock)
                                INNER JOIN tblOrder AS mas   with (nolock) ON INV.OrderId = mas.OrderId
                                INNER JOIN tblCustPayDetail AS CPD   with (nolock) ON INV.InvoiceId = CPD.InvoiceId  where mas.ComUnitId=@ComUnitId and mas.DistributionRouteId=@DistributionRouteId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "InvoiceNo", "InvoiceId", queryStr, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId)),
                new SqlParameter("@DistributionRouteId", SInventorySql.DbValue(routeID))
            });
        }

        public DataTable LoadInvoiceReturn(int invoiceId)
        {
            string query = @"select INV.InvoiceNo,CPD.CustPayDetailId,CPD.InvoiceId, CPD.PaymentAmount,CPD.custPaymentDate from tblCustPayDetail as CPD 
	                            LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	                            Where CPD.InvoiceId = @InvoiceId";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", invoiceId)
            });
        }

        public bool DeleteCustomerPaymentDetail(int id, string remarks, string LoginName)
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            List<SqlParameter> aSqlParameters = new List<SqlParameter>();
            aSqlParameters.Add(new SqlParameter("@Remarks", remarks));
            aSqlParameters.Add(new SqlParameter("@CustPayDetailId", id));
            aSqlParameters.Add(new SqlParameter("@LoginName", LoginName ));
            return aCommonInternalDal.UpdateAction("sp_InsertCustPayDetail_DeleteLog", aSqlParameters);
        }
    }
}
