using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class SalesComparisoneReportDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable LoadSalesComparisoneInfo(DateTime date)
        {
            string query = @"SELECT DATENAME(month,@ReportDate) as CurrentMonth,D.DistrictCode ,D.DistrictName ,vPreviousMonth.PreviousMonthSaleValue,ISNULL(vCurrentMonth.SaleValue,0)SaleValue ,(vPreviousMonth.PreviousMonthSaleValue-ISNULL(vCurrentMonth.SaleValue,0)) DiffInAmount ,ROUND(CONVERT(DECIMAL(18,2),(ISNULL(vCurrentMonth.SaleValue,0)/(vPreviousMonth.PreviousMonthSaleValue/100))),2) DiffInPercent FROM tblDistrict D LEFT JOIN (SELECT I.DisCode,SUM(I.DeliveryTpGrandTotal)SaleValue FROM dbo.tblInvoice I WITH (NOLOCK)  WHERE YEAR(InvoiceDate)= YEAR(@ReportDate) AND MONTH(InvoiceDate)= MONTH(@ReportDate) AND DeliveryInvoiceStatus IN ('Full','Partial') GROUP BY I.DisCode)vCurrentMonth ON D.DistrictCode=vCurrentMonth.DisCode LEFT JOIN (SELECT I.DisCode,SUM(I.DeliveryTpGrandTotal)PreviousMonthSaleValue FROM dbo.tblInvoice I WITH (NOLOCK)  WHERE YEAR(InvoiceDate)= YEAR(DATEADD(MONTH,-1,@ReportDate)) AND MONTH(InvoiceDate)= MONTH(DATEADD(MONTH,-1,@ReportDate)) AND DeliveryInvoiceStatus IN ('Full','Partial') GROUP BY I.DisCode)vPreviousMonth ON D.DistrictCode=vPreviousMonth.DisCode";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ReportDate", date)
            });
        }
    }
}
