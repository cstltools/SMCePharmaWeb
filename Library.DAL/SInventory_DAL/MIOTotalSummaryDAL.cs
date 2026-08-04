using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class MIOTotalSummaryDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        private static DataTable GetReportTable(string query, DateTime fromdate, DateTime todate, string zone = null, string branch = null, string territory = null)
        {
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromdate),
                new SqlParameter("@ToDate", todate),
                new SqlParameter("@Zone", SInventorySql.DbValue(zone)),
                new SqlParameter("@Branch", SInventorySql.DbValue(branch)),
                new SqlParameter("@Territory", SInventorySql.DbValue(territory))
            });
        }


        public DataTable LoadSummaryDAL(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,

tblORD.NumberofOrder,tblORD.NumberOfOrderValue, C.ComUnitCode,C.ComUnitId,C.ShortName,
ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ComUnitId,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ComUnitId,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 


,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt



,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) AS salesTP
,((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesVat
,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) +
  ((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesTotal


 ,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
  - ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
   - (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
    AS Outstanding1

	
  ,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
   - (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
    AS Outstanding2

	, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
  - ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
   - (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +

   ((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
   - (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3


FROM dbo.tblCompanyUnit C with(NoLock) 
LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId = C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId = C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblD ON tblD.ComUnitId = C.ComUnitId    LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN (SELECT I.ComUnitId, (SUM(GrossValue)) AS NumberOfOrderValue,count(DISTINCT I.OrderCode) NumberofOrder FROM dbo.tblOrder I WITH (NOLOCK)  where  I.SubmissionDate  BETWEEN @FromDate and @ToDate GROUP BY I.ComUnitId)tblORD ON tblORD.ComUnitId = C.ComUnitId  LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId   )tblUnD ON tblUnD.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId  FROM dbo.tblCustMaster GROUP BY ComUnitId) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov  ON tblCov.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId  FROM dbo.tblCustMaster GROUP BY ComUnitId) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId  FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov2  ON tblCov.ComUnitId = C.ComUnitId ORDER BY C.ComUnitName";



            return GetReportTable(query, fromdate, todate);

        }

        public DataTable LoadSummaryProductcodewise(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,

tblC.ProductCode,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,
--ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
--,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
--,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 


,tblD.ProductCode,
ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,

tblC.ProductCode,

--ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmount
--,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVat 
--,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSales,





(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales

,ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection

FROM dbo.tblProduct C with(NoLock) 

 LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate)  GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ProductCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


            return GetReportTable(query, fromdate, todate);
        
        }

        public DataTable LoadSummaryProductcodewiseGyash(string zone, DateTime fromdate, DateTime todate)
        {

            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@fromDate", fromdate));
            aSqlParameters.Add(new SqlParameter("@toDate", todate));
            aSqlParameters.Add(new SqlParameter("@unitid", zone));

            return aCommonInternalDal.GetDataTableAction("sp_MiowiseMISReport", aSqlParameters, "SSIDB"); 


//            string query = @"SELECT 
//ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
//ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
//ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
//
//
//
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
//ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
//,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
//,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
//,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt
//
//
//,(ISNULL(tblActualSales.SumTpSales,0) + ISNULL(tblActualSalesSub.SumTpSales,0)) AS salesTP
//,(ISNULL(tblActualSales.vat,0) + ISNULL(tblActualSalesSub.vat,0)) AS SalesVat
//,((ISNULL(tblActualSales.SumTpSales,0) + ISNULL(tblActualSalesSub.SumTpSales,0)) + (ISNULL(tblActualSales.vat,0) + ISNULL(tblActualSalesSub.vat,0))) AS SalesTotal
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
//AS Outstanding1
//
//	
//,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
//AS Outstanding2
//
//, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +
//
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3,
//
//
//C.MIAName
//FROM dbo.tblMIAInfo C with(NoLock) 
//
//LEFT JOIN (SELECT I.ComUnitId,I.MIACode,I.MiaName,COUNT(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
//WHERE I.ComUnitId=@Zone AND I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN  @FromDate and @ToDate  GROUP BY I.ComUnitId,I.MIACode,I.MiaName)tblA ON tblA.MIACode=C.MIACode LEFT JOIN   (SELECT ComUnitId,MIACode,MiaName,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Zone AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN  @FromDate and @ToDate   GROUP BY  ComUnitId,MIACode,MiaName)tblc  ON tblc.MIACode=C.MIACode   LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Zone AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN  @FromDate and @ToDate   GROUP BY  ComUnitId,MIAName,MIACode)tblcc ON tblcc.MIACode=C.MIACode  LEFT JOIN (SELECT I.ComUnitId,MIAName,MiaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where I.ComUnitId=@Zone AND ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN  @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId,MIAName,MiaCode)tblD ON tblD.MiaCode=C.MiaCode    LEFT JOIN (SELECT I.ComUnitId,MIAName,MiaCode,COUNT(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount, SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.ComUnitId=@Zone  AND I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN  @FromDate and @ToDate  GROUP BY I.ComUnitId,MIAName,MiaCode)tblAA ON tblAA.MiaCode=C.MiaCode   LEFT JOIN (SELECT I.ComUnitId,MIAName,MiaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ComUnitId=@Zone AND ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate   BETWEEN  @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId,MIAName,I.MIACode)tblDD ON tblDD.MIACode = C.MiaCode  LEFT JOIN   (  SELECT ComUnitId,MIAName,MiaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Zone and DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN  @FromDate and @ToDate   GROUP BY  ComUnitId,MIAName,MIACode  )tblUn ON tblUn.MIACode = C.MiaCode   LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount ,  SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Zone AND   DeliveryInvoiceStatus IS null AND InvoiceDate  BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId,MIAName,MiaCode )tblUnD ON tblUnD.MiaCode = C.MiaCode LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode, SUM(D.DeliveryNetAmount ) SumTpSales , SUM(D.DeliveryTotalPriceVatAmount)vat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Zone AND   DeliveryInvoiceStatus IS not null AND UpdateDate  BETWEEN  @FromDate and @ToDate  GROUP BY  ComUnitId,MIAName,MiaCode )tblActualSales ON tblActualSales.MiaCode = C.MiaCode  LEFT JOIN   (SELECT ComUnitId,MIAName,MIACode, SUM(D.DeliveryNetAmount ) SumTpSales , 	 SUM(D.DeliveryTotalPriceVatAmount)vat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Zone AND    DeliveryInvoiceStatus IS not null AND UpdateDate  BETWEEN  @FromDate and @ToDate  GROUP BY  ComUnitId,MIAName,MiaCode )tblActualSalesSUb ON tblActualSalesSUb.MiaCode = C.MiaCode   WHERE tblActualSales.ComUnitId=@Zone OR tblActualSalesSub.ComUnitId=@Zone OR      tblA.ComUnitId=@Zone OR tblc.ComUnitId=@Zone OR tblcc.ComUnitId=@Zone OR tblD.ComUnitId=@Zone OR tblAA.ComUnitId=@Zone OR tblDD.ComUnitId=@Zone OR tblUnD.ComUnitId=@Zone ORDER BY C.MIACode";


//            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");

        }

        public DataTable BranchwiseLoadSummaryBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            //            string query = @"
            ////SELECT C.ComUnitCode,C.ComUnitId,C.ShortName,
            ////ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ComUnitId,
            ////ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ComUnitId,
            ////ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
            ////,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
            ////,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
            ////,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat FROM dbo.tblCompanyUnit C with(NoLock) 
            ////LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  as SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId = C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblD ON tblD.ComUnitId = C.ComUnitId    LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  as SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId = C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId     ";

            //            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            string query = @"SELECT ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,

tblORD.NumberofOrder,tblORD.NumberOfOrderValue, C.ComUnitCode,C.ComUnitId,C.ShortName,
ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ComUnitId,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ComUnitId,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 

FROM dbo.tblCompanyUnit C with(NoLock) 
LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId = C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId = C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblD ON tblD.ComUnitId = C.ComUnitId    LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN (SELECT I.ComUnitId, (SUM(GrossValue)) AS NumberOfOrderValue,count(DISTINCT I.OrderCode) NumberofOrder FROM dbo.tblOrder I WITH (NOLOCK)  where  I.SubmissionDate  BETWEEN @FromDate and @ToDate GROUP BY I.ComUnitId)tblORD ON tblORD.ComUnitId = C.ComUnitId  LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId   )tblUnD ON tblUnD.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId  FROM dbo.tblCustMaster GROUP BY ComUnitId) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov  ON tblCov.ComUnitId = C.ComUnitId LEFT JOIN (SELECT ((CustomerMasterId * 100 ) / CustomerMasterId1) CustomerCoverPer ,T2.ComUnitId from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,ComUnitId  FROM dbo.tblCustMaster GROUP BY ComUnitId) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,ComUnitId  FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE InvoiceDate BETWEEN @FromDate and @ToDate) GROUP BY ComUnitId) ) AS T2 WHERE T1.ComUnitId=T2.ComUnitId    ) tblCov2  ON tblCov2.ComUnitId = C.ComUnitId where C.ComUnitId=@Branch";

            return GetReportTable(query, fromdate, todate, branch: Branch);

        }


        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate, string Branch)
        {

            string query = @"select ISNULL(tblA.RegionCode,tblcc.RegionCode)RegionCode ,ISNULL(tblA.AreaCode,C.AreaCode)AreaCode  ,ISNULL(tblA.AreaName,C.AreaName)AreaName,
ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,

ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,
((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales,

ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2


FROM dbo.tblArea C with(NoLock) 
LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
 INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblc ON tblc.AreaCode = C.AreaCode LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc ON tblcc.AreaCode = C.AreaCode      LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode  LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode     LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON tblCampPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode  LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode  where  tblAA.RegionCode= @Branch or tblcc.RegionCode= @Branch or tblA.RegionCode= @Branch    and (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0      order by AreaCode ";


 
            return GetReportTable(query, fromdate, todate, branch: Branch);

        }
        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate)
        {

            string query = @"Select ISNULL(tblA.RegionCode,tblcc.RegionCode)RegionCode ,ISNULL(tblA.AreaCode,C.AreaCode)AreaCode  ,ISNULL(tblA.AreaName,C.AreaName)AreaName,
ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,

((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales

,ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2



FROM dbo.tblArea C with(NoLock) 
LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
 INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblc ON tblc.AreaCode = C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1   AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON tblCampPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode   LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc ON tblcc.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode  LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode WHERE (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0 order by AreaCode ";




            return GetReportTable(query, fromdate, todate);

        }



        public DataTable BranchwiseTotalSalesBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,UpdateDate,NumberofInvoiceSold,SumofNetSalesAmount,DataColumn2

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount- D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount,  SUM(D.DeliveryTotalPriceVatAmount)DataColumn2  
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND 
			 UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,UpdateDate union all  SELECT 'SubDepo' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount- D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount,  SUM(D.DeliveryTotalPriceVatAmount)DataColumn2   FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId,UpdateDate)tblc ON tblc.ComUnitId = C.ComUnitId   where C.ComUnitId= @Branch order by UpdateDate ";

            return GetReportTable(query, fromdate, todate, branch: Branch);

        }
        public DataTable BranchwiseTotalSalesBLL(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,UpdateDate,NumberofInvoiceSold,SumofNetSalesAmount,DataColumn2

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount- D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount,  SUM(D.DeliveryTotalPriceVatAmount)DataColumn2 
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND 
			 UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,UpdateDate union all  SELECT 'SubDepo' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount- D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount,  SUM(D.DeliveryTotalPriceVatAmount)DataColumn2   FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId,UpdateDate)tblc ON tblc.ComUnitId = C.ComUnitId   order by UpdateDate ";

            return GetReportTable(query, fromdate, todate);

        }

        public DataTable BranchwiseTotalProformaBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,InvoiceDate as UpdateDate,NumberofInvoiceSold,SumofNetSalesAmount,DataColumn2

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2 
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND 
			 InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,InvoiceDate union all  SELECT 'SubDepo' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2    FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId,InvoiceDate)tblc ON tblc.ComUnitId = C.ComUnitId   where C.ComUnitId= @Branch order by InvoiceDate ";

            return GetReportTable(query, fromdate, todate, branch: Branch);

        }
        public DataTable BranchwiseTotalProformaBLL(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,InvoiceDate as UpdateDate,NumberofInvoiceSold,SumofNetSalesAmount,DataColumn2

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2 
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND 
			 InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,InvoiceDate union all  SELECT 'SubDepo' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2    FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId,InvoiceDate)tblc ON tblc.ComUnitId = C.ComUnitId    order by InvoiceDate ";

            return GetReportTable(query, fromdate, todate);

        }



        public DataTable MarketBranchwiseTotalProformaBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,InvoiceDate as ProformaDate,NumberofInvoiceSold,SumofNetSalesAmount AS ProformaAmountTP,DataColumn2 AS ProformaAmountVAt,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2 ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND 
			 InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,InvoiceDate ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode UNION all  SELECT 'SubDepo' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2 ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId,InvoiceDate,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode) tblc ON tblc.ComUnitId = C.ComUnitId   where C.ComUnitId=@Branch  order by InvoiceDate  ";

            return GetReportTable(query, fromdate, todate, branch: Branch);

        }
        public DataTable MarketBranchwiseTotalProformaBLL(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,InvoiceDate as ProformaDate,NumberofInvoiceSold,SumofNetSalesAmount AS ProformaAmountTP,DataColumn2 AS ProformaAmountVAt,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2 ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND 
			 InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,InvoiceDate ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode UNION all  SELECT 'SubDepo' as Depo,InvoiceDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,(SUM(D.NetAmount)-sum(D.TotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.TotalPriceVatAmount)DataColumn2 ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId,InvoiceDate,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode) tblc ON tblc.ComUnitId = C.ComUnitId  order by InvoiceDate  ";

            return GetReportTable(query, fromdate, todate);

        }





        public DataTable saleshwiseTotalProformaBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,UpdateDate as ProformaDate,NumberofInvoiceSold,SumofNetSalesAmount AS ProformaAmountTP,DataColumn2 AS ProformaAmountVAt,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryNetAmount)-sum(D.DeliveryTotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.DeliveryTotalPriceVatAmount)DataColumn2 ,
             MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND 
			 UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,UpdateDate ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode UNION all  SELECT 'SubDepo' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryNetAmount)-sum(D.DeliveryTotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.DeliveryTotalPriceVatAmount)DataColumn2 ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId,UpdateDate,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode) tblc ON tblc.ComUnitId = C.ComUnitId   where C.ComUnitId=@Branch  ORDER by UpdateDate   ";

            return GetReportTable(query, fromdate, todate, branch: Branch);

        }
        public DataTable salesBranchwiseTotalProformaBLL(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT ComUnitCode,ComUnitName,UpdateDate as ProformaDate,NumberofInvoiceSold,SumofNetSalesAmount AS ProformaAmountTP,DataColumn2 AS ProformaAmountVAt,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode

FROM dbo.tblCompanyUnit C with(NoLock) 

LEFT JOIN   (SELECT 'Kustia' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryNetAmount)-sum(D.DeliveryTotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.DeliveryTotalPriceVatAmount)DataColumn2 ,
             MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode
             FROM dbo.tblInvoice  WITH (NOLOCK) 
             INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND 
			 UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ComUnitId,UpdateDate ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode UNION all  SELECT 'SubDepo' as Depo,UpdateDate,ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold,(SUM(D.DeliveryNetAmount)-sum(D.DeliveryTotalPriceVatAmount))  SumofNetSalesAmount  ,SUM(D.DeliveryTotalPriceVatAmount)DataColumn2 ,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE  TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId,UpdateDate,MarketName,MarketCode,MIACode,MIAName,AreaCode,RegionCode,DisCode) tblc ON tblc.ComUnitId = C.ComUnitId    ORDER by UpdateDate   ";

            return GetReportTable(query, fromdate, todate);

        }



        public DataTable LoadSummaryzonewiseDAL(DateTime fromdate, DateTime todate, string zone)
        {

            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,

tblC.ProductCode,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,
ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 


,tblD.ProductCode,
ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,

tblC.ProductCode,

ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection

FROM dbo.tblProduct C with(NoLock) 

LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone)  GROUP BY ID.ProductCode,RegionCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone  GROUP BY ID.ProductCode,RegionCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone GROUP BY  ProductCode,RegionCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone  GROUP BY  ProductCode,RegionCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone   GROUP BY  ProductCode,RegionCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone  GROUP BY  ProductCode,RegionCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


//            string query = @"SELECT tblA.RegionCode,
//ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
//ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
//ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
//
//
//( C.ProductCode) AS ProductCode, C.ProductName AS ProductName,
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ProductCode,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ProductCode,
//ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
//,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
//,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
//,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) AS salesTP
//,((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesVat
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) +
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesTotal
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
//AS Outstanding1
//
//	
//,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
//AS Outstanding2
//
//, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +
//
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3
//
//
//FROM dbo.tblProduct C with(NoLock) 
//
//LEFT JOIN (SELECT I.RegionCode,ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
//WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.RegionCode=@Zone GROUP BY ID.ProductCode,I.RegionCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   AND RegionCode= @Zone GROUP BY  RegionCode,ProductCode)tblc ON tblc.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  AND RegionCode=@Zone GROUP BY  RegionCode,ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.RegionCode= @Zone AND I.TpGrandTotal>0  GROUP BY RegionCode,ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode    LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  AND I.RegionCode=@Zone GROUP BY RegionCode,ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode  LEFT JOIN (SELECT ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0 AND I.RegionCode=@Zone GROUP BY RegionCode,ID.ProductCode)tblDD ON tblDD.ProductCode = C.ProductCode   LEFT JOIN   (  SELECT ProductCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode=@Zone GROUP BY  RegionCode,ProductCode  )tblUn ON tblUn.ProductCode = C.ProductCode LEFT JOIN   (  SELECT ProductCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode=@Zone GROUP BY  ProductCode,RegionCode  )tblUnD ON tblUnD.ProductCode = C.ProductCode ORDER BY C.ProductCode";

            return GetReportTable(query, fromdate, todate, zone: zone);
        }

        public DataTable LoadSummaryzoneBranchwiseBLL(DateTime fromdate, DateTime todate, string zone, string Branch)
        {

            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,

tblC.ProductCode,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,
ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 


,tblD.ProductCode,
ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,

tblC.ProductCode,

ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection

FROM dbo.tblProduct C with(NoLock) 

LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.RegionCode=@Zone AND I.ComUnitId=@Branch)  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  GROUP BY  ProductCode,RegionCode,ComUnitId)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch   GROUP BY  ProductCode,RegionCode,ComUnitId)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch   GROUP BY  ProductCode,RegionCode,ComUnitId)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  GROUP BY  ProductCode,RegionCode,ComUnitId)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


//            string query = @"SELECT tblA.RegionCode,
//ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
//ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
//ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
//
//
//( C.ProductCode) AS ProductCode, C.ProductName AS ProductName,
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ProductCode,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ProductCode,
//ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
//,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
//,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
//,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) AS salesTP
//,((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesVat
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) +
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesTotal
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
//AS Outstanding1
//
//	
//,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
//AS Outstanding2
//
//, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +
//
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3
//
//
//FROM dbo.tblProduct C with(NoLock) 
//
//LEFT JOIN (SELECT I.ComUnitId,I.RegionCode,ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
//WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.RegionCode=@Zone AND I.ComUnitId=@Branch GROUP BY ID.ProductCode,I.RegionCode,I.ComUnitId)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId)tblc ON tblc.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate  AND I.TpGrandTotal>0  AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId)tblD ON tblD.ProductCode = C.ProductCode    LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId)tblAA ON tblAA.ProductCode=C.ProductCode  LEFT JOIN (SELECT ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0 AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId)tblDD ON tblDD.ProductCode = C.ProductCode   LEFT JOIN   (  SELECT ProductCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId )tblUn ON tblUn.ProductCode = C.ProductCode LEFT JOIN   (  SELECT ProductCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch GROUP BY ProductCode,RegionCode,ComUnitId )tblUnD ON tblUnD.ProductCode = C.ProductCode ORDER BY C.ProductCode";


            return GetReportTable(query, fromdate, todate, zone: zone, branch: Branch);

        }


        public DataTable LoadSummaryzoneBranchTerritorywiseBLL(DateTime fromdate, DateTime todate, string zone, string Branch, string territory)
        {

            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,

ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,

tblC.ProductCode,
ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,
ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 


,tblD.ProductCode,
ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,

tblC.ProductCode,

ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection

FROM dbo.tblProduct C with(NoLock) 

LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.RegionCode=@Zone AND I.ComUnitId=@Branch AND I.AreaCode=@Territory)  GROUP BY ID.ProductCode,RegionCode,ComUnitId,AreaCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory  GROUP BY ID.ProductCode,RegionCode,ComUnitId,AreaCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory   GROUP BY  ProductCode,RegionCode,ComUnitId,AreaCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory    GROUP BY  ProductCode,RegionCode,ComUnitId,AreaCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory   AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode,ComUnitId,AreaCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory  AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode,ComUnitId,AreaCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory   GROUP BY  ProductCode,RegionCode,ComUnitId,AreaCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND AreaCode=@Territory   GROUP BY  ProductCode,RegionCode,ComUnitId,AreaCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";



//            string query = @"SELECT tblA.RegionCode,
//ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
//ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
//ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
//
//
//( C.ProductCode) AS ProductCode, C.ProductName AS ProductName,
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,tblC.ProductCode,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,tblD.ProductCode,
//ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
//,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat 
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) +ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) NetInvoiceAmt
//,(ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) + ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0)) NetReturnAmt
//,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) +ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) NetSalesAmt
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) AS salesTP
//,((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesVat
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) ) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) ) +
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) AS SalesTotal
//
//
//,(ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))
//AS Outstanding1
//
//	
//,(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))
//AS Outstanding2
//
//, ((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) 
//- ((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))
//- (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) +
//
//((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0)) 
//- (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) )
//- (ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0))) AS Outstanding3
//
//
//FROM dbo.tblProduct C with(NoLock) 
//
//LEFT JOIN (SELECT I.AreaCode,I.ComUnitId,I.RegionCode,ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
//WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.RegionCode=@Zone AND I.ComUnitId=@Branch AND I.AreaCode=@Territory GROUP BY AreaCode,ID.ProductCode,I.RegionCode,I.ComUnitId)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblc ON tblc.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate  AND I.TpGrandTotal>0  AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblD ON tblD.ProductCode = C.ProductCode    LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblAA ON tblAA.ProductCode=C.ProductCode  LEFT JOIN (SELECT ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0 AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblDD ON tblDD.ProductCode = C.ProductCode   LEFT JOIN   (  SELECT ProductCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblUn ON tblUn.ProductCode = C.ProductCode LEFT JOIN   (  SELECT ProductCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate  AND RegionCode= @Zone AND ComUnitId=@Branch AND AreaCode=@Territory GROUP BY AreaCode,ProductCode,RegionCode,ComUnitId)tblUnD ON tblUnD.ProductCode = C.ProductCode ORDER BY C.ProductCode";


            return GetReportTable(query, fromdate, todate, zone: zone, branch: Branch, territory: territory);

        }

    }
}




//SELECT C.ComUnitCode,C.ComUnitId,C.ShortName,tblA.NumberofProformaInvoice,tblA.SumofNetProformaAmount,tblC.ComUnitId,
//ISNULL(tblC.NumberofInvoiceSold,0)NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)SumofNetSalesAmount,tblD.ComUnitId,
//ISNULL(tblD.NumberofReturnInvoice,0)NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0)SumofNetReturnAmount 

//,ISNULL(tblA.ProTpVat,0)ProTpVat 
//,ISNULL(tblc.DelTpVat,0)DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0)DelReTpVat 

//FROM dbo.tblCompanyUnit C with(NoLock) LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  as 
// SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat
//FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
//WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId = C.ComUnitId LEFT JOIN (SELECT I.ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.ComUnitId)tblD ON tblD.ComUnitId = C.ComUnitId   




