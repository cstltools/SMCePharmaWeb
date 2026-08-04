using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class DeleteInvoiceReportDAL
    {
        ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

        public void GetSalesCenter(DropDownList ddl)
        {
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName +':'+ ComUnitCode as ComUnitName FROM dbo.tblCompanyUnit  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitCode", queryStr);
        }

        public void GetCustomer(DropDownList ddl)
        {
            string queryStr = "SELECT CustomerMasterId ,CustomerCode FROM dbo.tblCustMaster";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CustomerCode", "CustomerMasterId", queryStr); ;
        }

        public DataTable GetDeleteOrderReport(string comUnitCode, string fromDate, string toDate)
        {
            string queryStr = @"SELECT com.ComUnitName, mas.InvoiceNo, RIGHT(mas.DelInvoiceNo, LEN(mas.DelInvoiceNo)-4) DelInvoiceNo, FORMAT(mas.DeleteDateTime,'dd-MM-yyyy') AS  DeleteDateTime, 
FORMAT(dtls.ReceiveDate,'dd-MM-yyyy') ReceiveDate, FORMAT(dtls.ExpDate,'dd-MM-yyyy') ExpDate, * FROM [dbo].[tblInvoiceDeleteLog] mas WITH (NOLOCK)
 
inner   JOIN tblInvoiceDetail_DeleterRecord dtls ON mas.InvoiceId = dtls.InvoiceId
LEFT JOIN dbo.tblCompanyUnit com ON com.ComUnitId = mas.ComUnitId
 
WHERE mas.InvoiceId IS NOT NULL ";
            List<SqlParameter> parameters = ReportParameters(ref queryStr, comUnitCode, fromDate, toDate);
            return SInventorySql.GetDataTable(queryStr, parameters);
        }

        public DataTable GetDeleteOrderNationalReport(string comUnitCode, string fromDate, string toDate)
        {
            string queryStr = @"SELECT com.ComUnitName, mas.InvoiceNo, RIGHT(mas.DelInvoiceNo, LEN(mas.DelInvoiceNo)-4) DelInvoiceNo, FORMAT(mas.DeleteDateTime,'dd-MM-yyyy') AS  DeleteDateTime, 
FORMAT(dtls.ReceiveDate,'dd-MM-yyyy') ReceiveDate, FORMAT(dtls.ExpDate,'dd-MM-yyyy') ExpDate, * FROM [dbo].[tblInvoiceDeleteLog] mas WITH (NOLOCK)
 
inner   JOIN tblInvoiceDetail_DeleterRecord dtls ON mas.InvoiceId = dtls.InvoiceId
LEFT JOIN dbo.tblCompanyUnit com ON com.ComUnitId = mas.ComUnitId
 
WHERE mas.InvoiceId IS NOT NULL  ";
            List<SqlParameter> parameters = ReportParameters(ref queryStr, comUnitCode, fromDate, toDate);
            return SInventorySql.GetDataTable(queryStr, parameters);
        }

        private List<SqlParameter> ReportParameters(ref string queryStr, string comUnitCode, string fromDate, string toDate)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();

            if (!string.IsNullOrWhiteSpace(comUnitCode))
            {
                queryStr += " AND com.ComUnitCode = @ComUnitCode";
                parameters.Add(new SqlParameter("@ComUnitCode", SInventorySql.DbValue(comUnitCode.Trim())));
            }

            if (!string.IsNullOrWhiteSpace(fromDate) && !string.IsNullOrWhiteSpace(toDate))
            {
                queryStr += " AND mas.DeleteDateTime BETWEEN @FromDate AND @ToDate";
                parameters.Add(new SqlParameter("@FromDate", SInventorySql.DbValue(fromDate.Trim())));
                parameters.Add(new SqlParameter("@ToDate", SInventorySql.DbValue(toDate.Trim())));
            }

            return parameters;
        }
    }
}
