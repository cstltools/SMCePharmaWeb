using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class TotalSummaryDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        private static DataTable GetReportTable(string query, DateTime fromdate, DateTime todate, string zone = null, string branch = null)
        {
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromdate),
                new SqlParameter("@ToDate", todate),
                new SqlParameter("@Zone", SInventorySql.DbValue(zone)),
                new SqlParameter("@Branch", SInventorySql.DbValue(branch))
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
        public DataTable GetMonthYearWiseSale(DateTime fromdate, DateTime todate)
        {
            string query = @"SELECT *	 FROM GetmonthlycustomerSaleDate(@FromDate,@ToDate)";

            return GetReportTable(query, fromdate, todate);

        }

        public DataTable OrderMonitoring_Bizmo(DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_OrderMonitoringPanel_Bizmotion", aSqlParameterList,
                "SSIDB");
        }
        public DataTable LoadBusinessSummaryProductwise(DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_Rpt_BusinessSummaryProductwise", aSqlParameterList, "SSIDB");


        }




        public DataTable LoadSummaryProductcodewiseNew(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZonId", ZonId));
 
                return aCommonInternalDal.GetDataTableAction("sp_ProductWiseBusinessSummaryMISReportByParam", aSqlParameterList, "SSIDB");
            



        }

        public DataTable LoadSummaryProductcodewise(DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_ProductWiseBusinessSummaryMISReport", aSqlParameterList, "SSIDB");



//            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,
//
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
//ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
//ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
//(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,
//
//tblC.ProductCode,
//((ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0))- ((ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0)))  - ((ISNULL(tblBonus.NumberofInvoiceSold,0)+ISNULL(tblSubBonus.NumberofInvoiceSold,0))) ) AS NumberofInvoiceSold,
//--ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
//--,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//--,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
//ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 
//
//
//,tblD.ProductCode,
//ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
//ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
//((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,
//
//tblC.ProductCode
//
//--ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmount
//--,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVat 
//--,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSales,
//
//
//
//
//
//--(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
//--,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
//--,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
//--((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales
//
//,ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
//,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
//,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection
//,(ISNULL(tblBonus.NumberofInvoiceSold,0)+ISNULL(tblSubBonus.NumberofInvoiceSold,0)) AS bouns
//FROM dbo.tblProduct C with(NoLock) 
//
//LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId=0  AND  InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)-(sum(D.Quantity-d.DeliveryQuantity))NumberofInvoiceSold, SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId=0 and  InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate)  GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId<>0 and InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.InvoiceDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ProductCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


//            return GetReportTable(query, fromdate, todate);
        
        }

        public DataTable LoadDepositSlipSummary(DateTime fromdate, DateTime todate, string comUnitId = null)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            if (!string.IsNullOrEmpty(comUnitId))
                aSqlParameterList.Add(new SqlParameter("@ComUnitId", comUnitId));
            return aCommonInternalDal.GetDataTableAction("sp_Rep_DepopsitSlip_BusinessSummary", aSqlParameterList, "SSIDB");
        }
        public int LoadDepositSlipSummaryProcess(DateTime fromdate, DateTime todate, string comUnitId = null)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            if (!string.IsNullOrEmpty(comUnitId))
                aSqlParameterList.Add(new SqlParameter("@ComUnitId", comUnitId));
            int dd = aCommonInternalDal.RunStoreProcedure("sp_Rep_DepopsitSlip_BusinessSummaryClosingReport", aSqlParameterList, "SSIDB");
            return dd;
        }

        public DataTable LoadSalesReturnReportSAP(DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_LoadSalesReturnReportSAP", aSqlParameterList, "SSIDB");
        }
        //public bool BankDeposit_SAP_Process(DateTime fromdate, DateTime todate)
        //{


           

        //    List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
        //    aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
        //    aSqlParameterList.Add(new SqlParameter("@todate", todate));
        //    bool dd= aCommonInternalDal.DeleteDataByDeleteCommand("sp_SAP_BankDeposit_SAP_Process", aSqlParameterList, "SSIDB");

        //    return dd;
        //}
        
        public DataTable BankDepositPosting_SAP(DateTime fromdate, DateTime todate)
        {


           

            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@FrmDate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@ToDate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_SAP_BankDepositPosting", aSqlParameterList, "SSIDB");
        }

        public DataTable LoadSummaryProductcodewiseGyashNew(int DistricId, DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@districtId", DistricId));
            return aCommonInternalDal.GetDataTableAction("sp_Get_AgingReceivableReport", aSqlParameterList, "SSIDB");

        }


        public DataTable LoadSummaryProductcodewiseGyash_dzsm(DateTime fromdate, DateTime todate, string Type, string Area, string Terr)
        {


            string RoleTypeName = "";
            string EmpInfoId = "";
            string ToRoleTypeId = "";
            try
            {
                RoleTypeName = HttpContext.Current.Session["RoleTypeName"].ToString();
                EmpInfoId = HttpContext.Current.Session["EmpInfoId"].ToString();
                ToRoleTypeId = HttpContext.Current.Session["RoleTypeId"].ToString();
            }
            catch
            {

            }

            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));

            if (RoleTypeName == "DZSM")
            {
                List<SqlParameter> aSqlDZSM = new List<SqlParameter>();
                aSqlDZSM.Add(new SqlParameter("@EmployeeId", EmpInfoId));
                aSqlDZSM.Add(new SqlParameter("@RoleId", ToRoleTypeId));

                DataTable dtMarket = aCommonInternalDal.GetDataTableAction("sp_DICByregionid", aSqlDZSM, "SSIDB");

                string DCId = dtMarket.Rows[0]["DCId"].ToString();


                aSqlParameterList.Add(new SqlParameter("@DCId", DCId));

                //return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_All_New", aSqlParameterList, "SSIDB");
                return aCommonInternalDal.GetDataTableAction("sp_RPT_BusinessSummaryMISReport", aSqlParameterList, "SSIDB");

            }
            else
            {
                aSqlParameterList.Add(new SqlParameter("@DCId", ""));
                //return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_All_New", aSqlParameterList, "SSIDB");
                return aCommonInternalDal.GetDataTableAction("sp_RPT_BusinessSummaryMISReport", aSqlParameterList, "SSIDB");
            }

            //            string query = @"SELECT 
            //ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
            //ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
            //ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
            //
            //
            //C.ShortName,
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
            //FROM dbo.tblCompanyUnit C with(NoLock) 
            //
            //LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
            //AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblD ON tblD.ComUnitId=C.ComUnitId     LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId )tblUnD ON tblUnD.ComUnitId = C.ComUnitId ORDER BY C.ShortName";


            //            return GetReportTable(query, fromdate, todate);

        }

        public DataTable LoadSummaryProductcodewiseGyash__New(DateTime fromdate, DateTime todate, string Type, string Area, string Terr, string ZoneId)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZoneId", ZoneId));

            // sp_BusinessSummaryMISReport_All_New
            return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_TT", aSqlParameterList, "SSIDB");


        }



        public DataTable LoadMIOWiseBusinessSummaryDAL(string Depid, DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Depid", Depid));
  

            // sp_BusinessSummaryMISReport_All_New
            return aCommonInternalDal.GetDataTableAction("sp_RPT_MIOWiseBusinessSummary", aSqlParameterList, "SSIDB");


        }

        public DataTable LoadSummaryProductcodewiseGyash(DateTime fromdate, DateTime todate, string Type, string  Area, string Terr,string ZoneId)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type)); 
            aSqlParameterList.Add(new SqlParameter("@Area", Area)); 
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZoneId", ZoneId));

            // sp_BusinessSummaryMISReport_All_New
            return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_All_New_New", aSqlParameterList, "SSIDB");

            //            string query = @"SELECT 
            //ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
            //ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
            //ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
            //
            //
            //C.ShortName,
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
            //FROM dbo.tblCompanyUnit C with(NoLock) 
            //
            //LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
            //AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblD ON tblD.ComUnitId=C.ComUnitId     LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId )tblUnD ON tblUnD.ComUnitId = C.ComUnitId ORDER BY C.ShortName";


            //            return GetReportTable(query, fromdate, todate);

        }



        public DataTable LoadRptBussinessSummary_LoadingDAL(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZonId", ZonId));
           // return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_Loading", aSqlParameterList, "SSIDB");
            return aCommonInternalDal.GetDataTableUsingReader("sp_RPT_MIS_BusinessSummary", aSqlParameterList, "SSIDB");


        }
        public DataTable RptMIOWiseReceiveableReport(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZonId", ZonId));
            //return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_Loading", aSqlParameterList, "SSIDB");
            return aCommonInternalDal.GetDataTableAction("sp_RPT_MIS_RptMIOWiseReceiveableReport", aSqlParameterList, "SSIDB");


        }
        public DataTable Sales_Collection_Reports_AccDAL(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZonId", ZonId));
            //return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_Loading", aSqlParameterList, "SSIDB");
            return aCommonInternalDal.GetDataTableAction("sp_RPT_MIS_BusinessSummary_Acc", aSqlParameterList, "SSIDB");


        }
        public DataTable ProductWiseSalesReportDAL(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            aSqlParameterList.Add(new SqlParameter("@Area", Area));
            aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
            aSqlParameterList.Add(new SqlParameter("@ZonId", ZonId));
            //return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport_Loading", aSqlParameterList, "SSIDB");
            return aCommonInternalDal.GetDataTableAction("sp_RPT_MIS_ProductWiseSalesReport", aSqlParameterList, "SSIDB");


        }
        public DataTable rptMonitoringReport(DateTime fromdate, DateTime todate, string Type)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Type", Type));
            return aCommonInternalDal.GetDataTableAction("sp_RPTMonitoringReport", aSqlParameterList, "SSIDB");

            //            string query = @"SELECT 

            //ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
            //ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
            //ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
            //
            //
            //C.ShortName,
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
            //FROM dbo.tblCompanyUnit C with(NoLock) 
            //
            //LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
            //AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblD ON tblD.ComUnitId=C.ComUnitId     LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId )tblUnD ON tblUnD.ComUnitId = C.ComUnitId ORDER BY C.ShortName";


            //            return GetReportTable(query, fromdate, todate);

        }

        public DataTable LoadSummaryProductcodewiseGyash(DateTime fromdate, DateTime todate)
        {


            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_BusinessSummaryMISReport", aSqlParameterList, "SSIDB");

//            string query = @"SELECT 
//ISNULL(tblUn.NumberofInvoiceun,0) + ISNULL(tblUnD.NumberofInvoiceun,0) AS NumberofUndelInvoice,
//ISNULL(tblUn.SumofNetUnAmount,0) + ISNULL(tblUnD.SumofNetUnAmount,0) AS SumofNetUnAmount,
//ISNULL(tblUn.UnTpVat,0) + ISNULL(tblUnD.UnTpVat,0) AS UnTpVat,
//
//
//C.ShortName,
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
//FROM dbo.tblCompanyUnit C with(NoLock) 
//
//LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=C.ComUnitId  LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblD ON tblD.ComUnitId=C.ComUnitId     LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=C.ComUnitId  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId = C.ComUnitId   LEFT JOIN   (  SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceun,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY  ComUnitId  )tblUn ON tblUn.ComUnitId = C.ComUnitId LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceun, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetUnAmount , SUM(D.TotalPriceVatAmount)UnTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IS null AND InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ComUnitId )tblUnD ON tblUnD.ComUnitId = C.ComUnitId ORDER BY C.ShortName";


//            return GetReportTable(query, fromdate, todate);

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

            //            return GetReportTable(query, fromdate, todate, branch: Branch);
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
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Dzsm", Branch));
            return aCommonInternalDal.GetDataTableAction("sp_GET_DZSMwiseReport", aSqlParameterList, "SSIDB");

//            string query = @"select ISNULL(tblA.RegionCode,tblC.RegionCode)RegionCode ,ISNULL(tblA.AreaCode,C.AreaCode)AreaCode  ,ISNULL(tblA.AreaName,C.AreaName)AreaName,
//ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
//
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
//ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
//,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
//
//ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
//ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,
//((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales,
//
//ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
//ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
//((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2
//
//
//FROM dbo.tblArea C with(NoLock) 
//LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
// INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
//WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblc ON tblc.AreaCode = C.AreaCode LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc ON tblcc.AreaCode = C.AreaCode      LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode  LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode     LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON tblCampPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode  LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode  where  tblAA.RegionCode= @Branch or tblcc.RegionCode= @Branch or tblA.RegionCode= @Branch    and (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0      order by AreaCode ";


 
//            return GetReportTable(query, fromdate, todate);

        }



        public DataTable DZSMwiseLoadSummaryparm(string fromdate, string todate, string parm)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@parm", parm));
            //    return aCommonInternalDal.GetDataTableAction("sp_GET_DZSMwiseReportParam_ByTest", aSqlParameterList, "SSIDB");
            //sp_Pro_DZSMwiseReportParam


            return aCommonInternalDal.GetDataTableAction("sp_GET_DZSMwiseReportParam_ByProcess", aSqlParameterList, "SSIDB");


            //            string query = @"select ISNULL(tblA.RegionCode,tblC.RegionCode)RegionCode ,ISNULL(tblA.AreaCode,C.AreaCode)AreaCode  ,ISNULL(tblA.AreaName,C.AreaName)AreaName,
            //ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
            //
            //ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
            //ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
            //ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
            //,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
            //,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
            //,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
            //
            //ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
            //ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,
            //((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales,
            //
            //ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
            //ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
            //((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2
            //
            //
            //FROM dbo.tblArea C with(NoLock) 
            //LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
            //AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
            // INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
            //WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblc ON tblc.AreaCode = C.AreaCode LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc ON tblcc.AreaCode = C.AreaCode      LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode  LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode     LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON tblCampPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode  LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode  where  tblAA.RegionCode= @Branch or tblcc.RegionCode= @Branch or tblA.RegionCode= @Branch    and (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0      order by AreaCode ";



            //            return GetReportTable(query, fromdate, todate);

        }

        public DataTable DZSMwiseLoadSummaryparm_vvvv(string fromdate, string todate, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
            aSqlParameterList.Add(new SqlParameter("@AreaSelect", AreaSelect));
            aSqlParameterList.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
            //    return aCommonInternalDal.GetDataTableAction("sp_GET_DZSMwiseReportParam_ByTest", aSqlParameterList, "SSIDB");
            //sp_Pro_DZSMwiseReportParam

            DataTable dt = new DataTable();

            if(TeritorySelect =="" && AreaSelect == "")
            {

               dt=  aCommonInternalDal.GetDataTableUsingReader("sp_GET_DZSMwiseReportParam_ByProcess_vv", aSqlParameterList, "SSIDB");
            }

            else if (TeritorySelect == "" && AreaSelect != "")
            {

                dt = aCommonInternalDal.GetDataTableUsingReader("sp_GET_DZSMwiseReportParam_ByProcess_Area", aSqlParameterList, "SSIDB");
            }

            else if (TeritorySelect != "" && AreaSelect != "")
            {

                dt = aCommonInternalDal.GetDataTableUsingReader("sp_GET_DZSMwiseReportParam_ByProcess_Terri", aSqlParameterList, "SSIDB");
            }
            return dt;

        }
        public DataTable DZSMwiseLoadSummaryparm_new(string fromdate, string todate, string parm)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@parm", parm));
            return aCommonInternalDal.GetDataTableAction("sp_GET_DZSMwiseReportParam_new_Day", aSqlParameterList, "SSIDB");

            //            string query = @"select ISNULL(tblA.RegionCode,tblC.RegionCode)RegionCode ,ISNULL(tblA.AreaCode,C.AreaCode)AreaCode  ,ISNULL(tblA.AreaName,C.AreaName)AreaName,
            //ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
            //
            //ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
            //ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
            //ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
            //,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
            //,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
            //,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
            //
            //ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
            //ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,
            //((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales,
            //
            //ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
            //ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
            //((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2
            //
            //
            //FROM dbo.tblArea C with(NoLock) 
            //LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
            //AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
            // INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
            //WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblc ON tblc.AreaCode = C.AreaCode LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc ON tblcc.AreaCode = C.AreaCode      LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode  LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode     LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON tblCampPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode  LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode  where  tblAA.RegionCode= @Branch or tblcc.RegionCode= @Branch or tblA.RegionCode= @Branch    and (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0      order by AreaCode ";



            //            return GetReportTable(query, fromdate, todate);

        }
        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
           // aSqlParameterList.Add(new SqlParameter("@Dzsm", Branch));
            return aCommonInternalDal.GetDataTableAction("sp_GET_DZSMwiseNAtionalReport", aSqlParameterList, "SSIDB");

            
            
            
            
            // string query = @"Select ISNULL(tblA.RegionCode,tblC.RegionCode)RegionCode ,ISNULL(tblA.AreaCode,C.AreaCode)AreaCode  ,ISNULL(tblA.AreaName,C.AreaName)AreaName,
//ISNULL(tblCov.CustomerCoverPer,0)+ISNULL(tblCov2.CustomerCoverPer,0) AS CustomerCoverPer,
//
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount,
//ISNULL(tblD.NumberofReturnInvoice,0) + ISNULL(tblDD.NumberofReturnInvoice,0) AS NumberofReturnInvoice,ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat 
//,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
//ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed,
//ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp,
//
//((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))- ((ISNULL(tblFixed.SumofNetSalesAmount,0)+ISNULL(tblSubFixed.SumofNetSalesAmount,0))+(ISNULL(tblcamp2.SumofNetSalesAmount,0)+ISNULL(tblCamp.SumofNetSalesAmount,0) )) )FinalSales
//
//,ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountFixed2,
//ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) AS SumofNetSalesAmountCamp2,
//((ISNULL(tblA.SumofNetProformaAmount,0)+ISNULL(tblAA.SumofNetProformaAmount,0))- ((ISNULL(tblFixedPro.SumofNetSalesAmount,0)+ISNULL(tblSubFixedPro.SumofNetSalesAmount,0))+(ISNULL(tblcamp2Pro.SumofNetSalesAmount,0)+ISNULL(tblCampPro.SumofNetSalesAmount,0) )) )FinalSales2
//
//
//
//FROM dbo.tblArea C with(NoLock) 
//LEFT JOIN (SELECT A.AreaName,I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
//AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
// INNER JOIN dbo.tblArea A WITH (NOLOCK) ON I.AreaCode = A.AreaCode
//WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,I.AreaCode,I.RegionCode)tblA ON tblA.AreaCode=C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblc ON tblc.AreaCode = C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixedPro ON tblFixedPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1   AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixedPro ON tblSubFixedPro.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCampPro ON tblCampPro.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.NetAmount - D.TotalPriceVatAmount) SumofNetSalesAmount , SUM(D.TotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign')  AND TpGrandTotal>0 AND InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2Pro ON tblcamp2Pro.AreaCode = C.AreaCode   LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcc ON tblcc.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblD ON tblD.AreaCode = C.AreaCode    LEFT JOIN (SELECT I.RegionCode,I.AreaCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY I.RegionCode,I.AreaCode)tblAA ON tblAA.AreaCode=C.AreaCode LEFT JOIN (SELECT I.RegionCode,I.AreaCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY I.RegionCode,I.AreaCode)tblDD ON tblDD.AreaCode = C.AreaCode   LEFT JOIN (SELECT ((CustomerMasterId  ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1,((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode       FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblInvoice WHERE DeliveryInvoiceStatus<>'Reject' and  UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode    ) tblCov  ON tblCov.AreaCode = C.AreaCode LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblFixed ON tblFixed.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE FixedCustomer=1 AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblSubFixed ON tblSubFixed.AreaCode = C.AreaCode    LEFT JOIN (SELECT tblInvoice.RegionCode,tblInvoice.AreaCode,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,  SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  tblInvoice.RegionCode,tblInvoice.AreaCode)tblCamp ON tblCamp.AreaCode = C.AreaCode  LEFT JOIN  (SELECT A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  INNER JOIN dbo.tblArea A WITH (NOLOCK) ON tblSubInvoiceMaster.AreaCode = A.AreaCode WHERE (D.Campaign='Bonus Campaign' OR D.Campaign='Sales Campaign') AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY A.AreaName,tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.AreaCode)tblcamp2 ON tblcamp2.AreaCode = C.AreaCode  LEFT JOIN (SELECT ((CustomerMasterId ) ) CustomerCoverPer ,T2.RegionCode,T2.AreaCode from (SELECT COUNT(CustomerMasterId) CustomerMasterId1,RegionCode,AreaCode  FROM dbo.tblCustMaster GROUP BY RegionCode,AreaCode) AS T1, ((SELECT COUNT(CustomerMasterId)CustomerMasterId,RegionCode,AreaCode      FROM dbo.tblCustMaster WHERE  CustomerMasterId  IN  (SELECT CustomerMasterId FROM dbo.tblSubInvoiceMaster WHERE DeliveryInvoiceStatus<>'Reject' and UpdateDate BETWEEN @FromDate and @ToDate) GROUP BY RegionCode,AreaCode) ) AS T2 WHERE T1.AreaCode=T2.AreaCode) tblCov2  ON tblCov2.AreaCode = C.AreaCode WHERE (ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) ) > 0 order by AreaCode ";




//            return GetReportTable(query, fromdate, todate);

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
(ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0))- ((ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0))+((ISNULL(tblBonus.NumberofInvoiceSold,0)+ISNULL(tblSubBonus.NumberofInvoiceSold,0)))) AS NumberofInvoiceSold,
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
,(ISNULL(tblBonus.NumberofInvoiceSold,0)+ISNULL(tblSubBonus.NumberofInvoiceSold,0)) AS bouns
FROM dbo.tblProduct C with(NoLock) 

LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE RegionCode=@Zone and D.OrderDetailsId=0   AND  InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.Quantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE RegionCode=@Zone and D.OrderDetailsId=0   AND  InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE RegionCode=@Zone and ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE RegionCode=@Zone and  I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where RegionCode=@Zone and  ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE RegionCode=@Zone and  I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE RegionCode=@Zone and  I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate)  GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE RegionCode=@Zone and  I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE RegionCode=@Zone and  D.OrderDetailsId<>0 and InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE RegionCode=@Zone and   InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where RegionCode=@Zone and  ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where RegionCode=@Zone and ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE RegionCode=@Zone and  PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ProductCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE RegionCode=@Zone and  PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


//            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,
//
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
//ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
//ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
//(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,
//
//tblC.ProductCode,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,
//--ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
//--,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//--,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
//ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 
//
//
//,tblD.ProductCode,
//ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
//ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
//((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,
//
//tblC.ProductCode,
//
//--ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmount
//--,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVat 
//--,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSales,
//
//
//
//
//
//(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
//,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
//,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
//((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales
//
//,ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
//,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
//,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection
//,tblBonus.NumberofInvoiceSold AS bouns
//
//
//FROM dbo.tblProduct C with(NoLock) 
//
//LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId=0  AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode  LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone)  GROUP BY ID.ProductCode,RegionCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone  GROUP BY ID.ProductCode,RegionCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE OrderDetailsId<>0 and DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone GROUP BY  ProductCode,RegionCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone  GROUP BY  ProductCode,RegionCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone   GROUP BY  ProductCode,RegionCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone  GROUP BY  ProductCode,RegionCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


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

(ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0))- ((ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0))+((ISNULL(tblBonus.NumberofInvoiceSold,0)+ISNULL(tblSubBonus.NumberofInvoiceSold,0)))) AS NumberofInvoiceSold,
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
,(ISNULL(tblBonus.NumberofInvoiceSold,0)+ISNULL(tblSubBonus.NumberofInvoiceSold,0)) AS bouns
FROM dbo.tblProduct C with(NoLock) 

LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE ComUnitId=@Branch and RegionCode=@Zone and D.OrderDetailsId=0  AND   InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblSubBonus ON tblSubBonus.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE ComUnitId=@Branch and RegionCode=@Zone and D.OrderDetailsId=0  AND   InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ComUnitId=@Branch and RegionCode=@Zone and ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDDaos ON tblDDaos.ProductCode = C.ProductCode   LEFT JOIN (SELECT ID.ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE ComUnitId=@Branch and RegionCode=@Zone and  I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAOS ON tblAOS.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ComUnitId=@Branch and RegionCode=@Zone and  ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ProductCode)tblDaos ON tblDaos.ProductCode=C.ProductCode LEFT JOIN (SELECT ProductCode,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ComUnitId=@Branch and  RegionCode=@Zone and  I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ProductCode)tblAAos ON tblAAos.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE RegionCode=@Zone and  I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate)  GROUP BY ID.ProductCode)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE RegionCode=@Zone and  I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY ID.ProductCode)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE ComUnitId=@Branch and RegionCode=@Zone and  InvoiceDate BETWEEN @FromDate and @ToDate GROUP BY  ProductCode)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Branch and RegionCode=@Zone and  InvoiceDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ComUnitId=@Branch and RegionCode=@Zone and  ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ComUnitId=@Branch and RegionCode=@Zone and ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  BETWEEN @FromDate and @ToDate AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE ComUnitId=@Branch and RegionCode=@Zone and  PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate   GROUP BY  ProductCode)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE ComUnitId=@Branch and RegionCode=@Zone and  PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate  GROUP BY  ProductCode)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";

//            string query = @"SELECT (C.ProductCode) AS ProductCode, C.ProductName AS ProductName,
//
//ISNULL(tblA.NumberofProformaInvoice,0) + ISNULL(tblAA.NumberofProformaInvoice,0) AS NumberofProformaInvoice,
//ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0) AS SumofNetProformaAmount,
//ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) AS ProTpVat ,
//(ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0) + ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0))GrossProforma,
//
//tblC.ProductCode,
//ISNULL(tblC.NumberofInvoiceSold,0) + ISNULL(tblCC.NumberofInvoiceSold,0) AS NumberofInvoiceSold,
//--ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0) AS SumofNetSalesAmount
//--,ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0) AS DelTpVat 
//--,((ISNULL(tblc.DelTpVat,0) + ISNULL(tblcc.DelTpVat,0)) + (ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))) AS GrossSales,
//ISNULL(tblc.DiscountAmount,0) + ISNULL(tblcc.DiscountAmount,0) AS TotalDiscountAmount 
//
//
//,tblD.ProductCode,
//ISNULL(tblD.DelQty,0) + ISNULL(tblDD.DelQty,0) AS RetQty,
//ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0) AS SumofNetReturnAmount 
//,ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0) AS DelReTpVat ,
//((ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)) + (ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))) GrossRetuen,
//
//tblC.ProductCode,
//
//--ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmount
//--,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVat 
//--,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSales,
//
//
//
//
//
//(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0)) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0)) AS SumofNetSalesAmount
//,((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS DelTpVat
//,(ISNULL(tblAos.SumofNetProformaAmount,0) + ISNULL(tblAAos.SumofNetProformaAmount,0) ) - (ISNULL(tblDaos.SumofNetReturnAmount,0) + ISNULL(tblDDaos.SumofNetReturnAmount,0) ) +
//((ISNULL(tblAos.ProTpVat,0) + ISNULL(tblAAos.ProTpVat,0))-(ISNULL(tblDaos.TotalPriceVatAmount,0) + ISNULL(tblDDaos.TotalPriceVatAmount,0))) AS GrossSales
//
//,ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0) AS SumofNetSalesAmountCollection
//,ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0) AS DelTpVatCollection 
//,((ISNULL(tblCollection.DelTpVat,0) + ISNULL(tblCollectionSub.DelTpVat,0)) + (ISNULL(tblCollection.SumofNetSalesAmount,0)+ISNULL(tblCollectionSub.SumofNetSalesAmount,0))) AS GrossSalesCollection
//,tblBonus.NumberofInvoiceSold AS bouns
//FROM dbo.tblProduct C with(NoLock) 
//
//LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE D.OrderDetailsId=0  AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch GROUP BY  ProductCode)tblBonus ON tblBonus.ProductCode = C.ProductCode   LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId WHERE I.TpGrandTotal>0 AND (I.InvoiceDate BETWEEN @FromDate and @ToDate AND I.RegionCode=@Zone AND I.ComUnitId=@Branch)  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblA ON tblA.ProductCode=C.ProductCode LEFT JOIN (SELECT ID.ProductCode,sum(ID.Quantity) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount) AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId   WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblAA ON tblAA.ProductCode=C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId WHERE OrderDetailsId<>0 and DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  GROUP BY  ProductCode,RegionCode,ComUnitId)tblc ON tblc.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId   WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch   GROUP BY  ProductCode,RegionCode,ComUnitId)tblcc ON tblcc.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblD ON tblD.ProductCode = C.ProductCode  LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty, ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount, COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch AND I.TpGrandTotal>0  GROUP BY ID.ProductCode,RegionCode,ComUnitId)tblDD ON tblDD.ProductCode = C.ProductCode LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold,SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount ,SUM(D.DeliveryTotalPriceVatAmount)DelTpVat, sum(D.DiscountAmount)DiscountAmount FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch   GROUP BY  ProductCode,RegionCode,ComUnitId)tblCollection ON tblCollection.ProductCode = C.ProductCode  LEFT JOIN   (SELECT ProductCode,sum(D.DeliveryQuantity)NumberofInvoiceSold, SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) SumofNetSalesAmount , SUM(D.DeliveryTotalPriceVatAmount)DelTpVat,SUM(D.DiscountAmount)DiscountAmount  FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId WHERE PaymentAmount IS NOT NULL AND DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND UpdateDate BETWEEN @FromDate and @ToDate AND RegionCode=@Zone AND ComUnitId=@Branch  GROUP BY  ProductCode,RegionCode,ComUnitId)tblCollectionSub ON tblCollectionSub.ProductCode = C.ProductCode  ";


            return GetReportTable(query, fromdate, todate, zone: zone, branch: Branch);

        }


        public DataTable LoadSummaryzoneBranchTerritorywiseBLL(DateTime fromdate, DateTime todate, string Branch)
        {

            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            aSqlParameterList.Add(new SqlParameter("@Branch", Branch));
            return aCommonInternalDal.GetDataTableAction("sp_ProductWiseBranchwiseBusinessSummaryMISReport", aSqlParameterList, "SSIDB");

        }

        public DataTable FinalSales(DateTime fromdate, DateTime todate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_GetFinalSales", aSqlParameterList, "SSIDB");

            //return GetReportTable(query, fromdate, todate);

        }
        public DataTable FinalSales2(DateTime fromdate, DateTime todate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
            aSqlParameterList.Add(new SqlParameter("@todate", todate));
            return aCommonInternalDal.GetDataTableAction("sp_NumberofInvoiceandCust", aSqlParameterList, "SSIDB");

            //return GetReportTable(query, fromdate, todate);

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






