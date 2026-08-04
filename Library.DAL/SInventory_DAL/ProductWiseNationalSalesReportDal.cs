using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.SInventory_DAL
{
    public class ProductWiseNationalSalesReportDal
    {
        public DataTable GetProductWiseNationalSalesInfo(DateTime fromDate)
        {
            string query = @"SELECT P.ProductCode ,P.ProductName ,P.PackSize,ISNULL(DeliveryTotal3,0)DeliveryTotal3,ISNULL(vPreviousMonth3.PreviousMonthSaleValue3,0) PreviousMonthSaleValue3," +
      " ISNULL(DeliveryTotal2,0)DeliveryTotal2,ISNULL(vPreviousMonth2.PreviousMonthSaleValue2,0) PreviousMonthSaleValue2,ISNULL(DeliveryTotal1,0)DeliveryTotal1,ISNULL(vPreviousMonth1.PreviousMonthSaleValue1,0) PreviousMonthSaleValue1," +
	  " ISNULL(DeliveryTotal,0)DeliveryTotal,ISNULL(vCurrentMonth.SaleValue,0)CurrentMonthSaleValue,ROUND(CONVERT(DECIMAL(18,2),(vCurrentMonth.SaleValue/((SELECT SUM(ID.DeliveryNetAmount)SaleValue FROM dbo.tblInvoice I WITH (NOLOCK)" +
      " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND ID.DeliveryStatus IN ('Full','Partial'))/100))),2)" +
      " ContributionPercent FROm dbo.tblProduct P LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal,SUM(ID.DeliveryNetAmount)SaleValue FROM dbo.tblInvoice I WITH (NOLOCK) " +
      " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND ID.DeliveryStatus IN ('Full','Partial')" +
      " GROUP BY ID.ProductCode)vCurrentMonth ON P.ProductCode=vCurrentMonth.ProductCode " +
      " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal1,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue1 FROM dbo.tblInvoice I WITH (NOLOCK) " +
      " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(DATEADD(MONTH,-1,@FromDate)) AND MONTH(InvoiceDate)= MONTH(DATEADD(MONTH,-1,@FromDate)) AND ID.DeliveryStatus IN ('Full','Partial') " +
      " GROUP BY ID.ProductCode)vPreviousMonth1 ON P.ProductCode=vPreviousMonth1.ProductCode " +
      " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal2,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue2 FROM dbo.tblInvoice I WITH (NOLOCK) " +
      " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(DATEADD(MONTH,-2,@FromDate)) AND MONTH(InvoiceDate)= MONTH(DATEADD(MONTH,-2,@FromDate)) AND ID.DeliveryStatus IN ('Full','Partial') " +
      " GROUP BY ID.ProductCode)vPreviousMonth2 ON P.ProductCode=vPreviousMonth2.ProductCode " +
      " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal3,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue3 FROM dbo.tblInvoice I WITH (NOLOCK)  " +
      " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(DATEADD(MONTH,-3,@FromDate)) AND MONTH(InvoiceDate)= MONTH(DATEADD(MONTH,-3,@FromDate)) AND ID.DeliveryStatus IN ('Full','Partial') " +
      " GROUP BY ID.ProductCode)vPreviousMonth3 ON P.ProductCode=vPreviousMonth3.ProductCode ORDER BY vCurrentMonth.SaleValue desc";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate)
            });
        }

        public DataTable GetProductWiseNationalSalesInfoZoneWise(DateTime fromDate)
        {
            string query = @"SELECT P.ProductCode ,P.ProductName ,P.PackSize,ISNULL(DeliveryTotal4,0)[DeliveryTotal-KL-100],ISNULL(vPreviousMonth4.PreviousMonthSaleValue4,0) [SaleValue-KL-100],ISNULL(DeliveryTotal3,0)[DeliveryTotal-BG-100], " +
	   " ISNULL(vPreviousMonth3.PreviousMonthSaleValue3,0) [SaleValue-BG-100],ISNULL(DeliveryTotal2,0)[DeliveryTotal-SL-100], ISNULL(vPreviousMonth2.PreviousMonthSaleValue2,0) [SaleValue-SL-100],ISNULL(DeliveryTotal1,0)[DeliveryTotal-CM-100], " +
       " ISNULL(vPreviousMonth1.PreviousMonthSaleValue1,0) [SaleValue-CM-100],ISNULL(DeliveryTotal,0)[DeliveryTotal-DK-100],ISNULL(vCurrentMonth.SaleValue,0)[SaleValue-DK-100],ISNULL(vCurrentMonthTotal.DeliveryTotalMonth,0)DeliveryTotalMonth, " +
	  "  ISNULL(vCurrentMonthTotal.SaleValueMonth,0)SaleValueMonth,ROUND(CONVERT(DECIMAL(18,2),(vCurrentMonthTotal.SaleValueMonth/((SELECT SUM(ID.DeliveryNetAmount)SaleValue FROM dbo.tblInvoice I WITH (NOLOCK) " +
      "  INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND ID.DeliveryStatus IN ('Full','Partial'))/100))),2) " +
 " ContributionPercent FROM dbo.tblProduct P LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotalMonth,SUM(ID.DeliveryNetAmount)SaleValueMonth FROM dbo.tblInvoice I WITH (NOLOCK) " +
 " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate)  AND ID.DeliveryStatus IN ('Full','Partial')" +
 " GROUP BY ID.ProductCode)vCurrentMonthTotal ON P.ProductCode=vCurrentMonthTotal.ProductCode " +
 " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal,SUM(ID.DeliveryNetAmount)SaleValue FROM dbo.tblInvoice I WITH (NOLOCK) " +
 " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND I.RegionCode='DK-100' AND ID.DeliveryStatus IN ('Full','Partial') " +
 " GROUP BY ID.ProductCode)vCurrentMonth ON P.ProductCode=vCurrentMonth.ProductCode " +
 " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal1,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue1 FROM dbo.tblInvoice I WITH (NOLOCK) " +
 " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND I.RegionCode='CM-100' AND ID.DeliveryStatus IN ('Full','Partial') " +
 " GROUP BY ID.ProductCode)vPreviousMonth1 ON P.ProductCode=vPreviousMonth1.ProductCode " +
 " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal2,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue2 FROM dbo.tblInvoice I WITH (NOLOCK) " +
 " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId " +
 " WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND I.RegionCode='SL-100' AND ID.DeliveryStatus IN ('Full','Partial') " +
 " GROUP BY ID.ProductCode)vPreviousMonth2 ON P.ProductCode=vPreviousMonth2.ProductCode " +
 " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal3,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue3 FROM dbo.tblInvoice I WITH (NOLOCK) " +
 " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId " +
 " WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND I.RegionCode='BG-100' AND ID.DeliveryStatus IN ('Full','Partial') " +
 " GROUP BY ID.ProductCode)vPreviousMonth3 ON P.ProductCode=vPreviousMonth3.ProductCode " +
 " LEFT JOIN (SELECT ID.ProductCode,SUM(ID.DeliveryTotalQuantity)DeliveryTotal4,SUM(ID.DeliveryNetAmount)PreviousMonthSaleValue4 FROM dbo.tblInvoice I WITH (NOLOCK) " +
 " INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId " +
 " WHERE YEAR(InvoiceDate)= YEAR(@FromDate) AND MONTH(InvoiceDate)= MONTH(@FromDate) AND I.RegionCode='KL-100' AND ID.DeliveryStatus IN ('Full','Partial') " +
 " GROUP BY ID.ProductCode)vPreviousMonth4 ON P.ProductCode=vPreviousMonth4.ProductCode";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate)
            });
        }
    }
}
