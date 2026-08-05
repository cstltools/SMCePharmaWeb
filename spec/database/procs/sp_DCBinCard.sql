
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,0@CompanyId/@CompanyId5/20@CompanyId6,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DCBinCard] 

	@FromDate DATETIME,
	@ToDate DATETIME,
	@DcId INT,
	@DCName NVARCHAR(MAX),
	@CompanyId INT

	
AS
BEGIN
	
	SELECT P.ProductCode as ProductCode,P.ProductName as ProductName ,@FromDate AS FromDate, 
@ToDate AS ToDate,@DCName AS DC,P.PackSize as BaseUnit,
ISNULL(vTblOB.Quantity,0)OpeningStock   ,ISNULL(vTblStoReceive.TotalStockReceiveQty,0) AS ReceiveFromCentralWarehouse   
,ISNULL(vTblChallanReceive.TotalStockReceiveQty,0)  AS ReceiveFromAreaOfficeInterTransfer    
,ISNULL(vTblStockReceive.TotalStockReceiveQty,0) AS TotalReceived,ISNULL(vTblChallanTransit.Challan,0) AS IntransitWHB2B,
ISNULL(vTblsalesInTransit.Sales,0) AS SalesInTransit  ,ISNULL(vTblsales.Sales,0) AS IssuedToSales, ISNULL(vbBonus.BonusQty,0) AS IssuedToBonus   
,ISNULL(vTblProductBonus.Sales,0) AS IssuedToProductBonus   ,ISNULL(vTblChallan.Challan,0) AS IssuedToAreaOfficeInterTransfer    
,ISNULL(vTblFreez.Freeze,0) AS IssuedToDamageAndOthers,    ISNULL(vTblFreez2.Freeze,0) AS Blocked, 
ISNULL(vTblSample.SampleIssue,0) AS SampleIssue,    
((ISNULL(vTblOB.Quantity,0)+ISNULL(vTblStoReceive.TotalStockReceiveQty,0)+ISNULL(vTblChallanReceive.TotalStockReceiveQty,0)+ 
ISNULL(vTblChallanTransit.Challan,0))-(ISNULL(vTblsales.Sales,0) +ISNULL(vTblProductBonus.Sales,0)+
ISNULL(vTblChallan.Challan,0)+ ISNULL(vTblSample.SampleIssue,0)+ ISNULL(vbBonus.BonusQty,0) + ISNULL(vTblsalesInTransit.Sales,0)))  as ClosingStock , 
(ISNULL(vTblOB.Quantity,0)+ISNULL(vTblStoReceive.TotalStockReceiveQty,0)+ISNULL(vTblChallanReceive.TotalStockReceiveQty,0) +
  ISNULL(vTblChallanTransit.Challan,0)) AS TotalStock,(ISNULL(vTblsales.Sales,0) +ISNULL(vTblProductBonus.Sales,0)+ISNULL(vTblChallan.Challan,0) + 
   ISNULL(vTblSample.SampleIssue,0) + ISNULL(vbBonus.BonusQty,0) + ISNULL(vTblsalesInTransit.Sales,0)) AS TotalIssue, 
    (ISNULL(vTblsales.Value,0) +ISNULL(vTblProductBonus.Value,0)+ISNULL(vTblChallan.Value,0)+ ISNULL(vTblSample.Value,0)+ ISNULL(vbBonus.Value,0) 
	+ ISNULL(vTblsalesInTransit.Value,0)) AS IssuedValue, (ISNULL(vTblOB.Value,0)+ISNULL(vTblStoReceive.Value,0)+ISNULL(vTblChallanReceive.Value,0)+ 
	ISNULL(vTblChallanTransit.Value,0)) AS TotalRcvValue, CASE WHEN (ISNULL(vTblsales.Value,0) +ISNULL(vTblProductBonus.Value,0)+
	ISNULL(vTblChallan.Value,0)+ ISNULL(vTblSample.Value,0)+ ISNULL(vbBonus.Value,0) + ISNULL(vTblsalesInTransit.Value,0)) > 
	(ISNULL(vTblOB.Value,0)+ISNULL(vTblStoReceive.Value,0)+ISNULL(vTblChallanReceive.Value,0)+ ISNULL(vTblChallanTransit.Value,0)) 
	THEN ((ISNULL(vTblsales.Value,0) +ISNULL(vTblProductBonus.Value,0)+ISNULL(vTblChallan.Value,0)+ 
	ISNULL(vTblSample.Value,0)+ ISNULL(vbBonus.Value,0) + ISNULL(vTblsalesInTransit.Value,0))
	-(ISNULL(vTblOB.Value,0)+ISNULL(vTblStoReceive.Value,0)+ISNULL(vTblChallanReceive.Value,0)+ ISNULL(vTblChallanTransit.Value,0)))
	 ELSE ((ISNULL(vTblOB.Value,0)+ISNULL(vTblStoReceive.Value,0)+ISNULL(vTblChallanReceive.Value,0)+ ISNULL(vTblChallanTransit.Value,0)) 
	 - (ISNULL(vTblsales.Value,0) +ISNULL(vTblProductBonus.Value,0)+ISNULL(vTblChallan.Value,0)+ ISNULL(vTblSample.Value,0)+ ISNULL(vbBonus.Value,0)
	  + ISNULL(vTblsalesInTransit.Value,0))) END as ClosingStockValue  
	  FROM dbo.tblProduct P with(nolock)  
	  
	  LEFT JOIN (SELECT tblDCStore_OpeningBalance.ProductCode,SUM(StockQty)Quantity,  
	  SUM(((CTRS.UnitPrice*tblDCStore_OpeningBalance.StockQty) + (CTRS.VATPerUnit*tblDCStore_OpeningBalance.StockQty))) AS Value
	  FROM dbo.tblDCStore_OpeningBalance  with(nolock)  
	  INNER JOIN tblCentralStore AS CTRS ON tblDCStore_OpeningBalance.TempReceiveId = CTRS.ReceiveId  
	  WHERE tblDCStore_OpeningBalance.ComUnitId= @DcId AND DCOpeningBalanceDate=@FromDate 
	  GROUP BY tblDCStore_OpeningBalance.ProductCode) vTblOB ON vTblOB.ProductCode = P.ProductCode  
	   
	   LEFT JOIN (SELECT DCS.ProductCode,SUM(TotalQuantity)TotalStockReceiveQty,  SUM(((CTRS.UnitPrice*DCS.StockQty) 
	   + (CTRS.VATPerUnit*DCS.StockQty))) AS Value FROM dbo.tblDCStore AS DCS with(nolock)  
	   INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId WHERE ComUnitId= @DcId
	   AND ChalanDetailsId IS  NULL AND StockRcvDate between @FromDate and @ToDate 
	   GROUP BY DCS.ProductCode) vTblStoReceive ON vTblStoReceive.ProductCode = P.ProductCode  
	    
	   LEFT JOIN (SELECT DCS.ProductCode,SUM(TotalQuantity)TotalStockReceiveQty,  
	   SUM(((CTRS.UnitPrice*DCS.StockQty) + (CTRS.VATPerUnit*DCS.StockQty))) AS Value FROM dbo.tblDCStore AS DCS with(nolock)  
	   INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId   WHERE DCS.ComUnitId = @DcId 
	   AND ChalanDetailsId IS NOT NULL AND StockRcvDate between @FromDate and @ToDate 
	   GROUP BY DCS.ProductCode) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode 
	    
	   LEFT JOIN (SELECT DCS.ProductCode,SUM(TotalQuantity)TotalStockReceiveQty,  
	   SUM(((CTRS.UnitPrice*TotalQuantity) + (CTRS.VATPerUnit*TotalQuantity) )) AS Value FROM dbo.tblDCStore DCS  with(nolock)   
	   INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId 
	   WHERE ComUnitId= @DcId AND StockRcvDate between @FromDate and @ToDate 
	   GROUP BY DCS.ProductCode)  vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode
	      
	   LEFT JOIN (SELECT tblInvoiceDetail.ProductCode,SUM(DeliveryQuantity)Sales,  
	   SUM(((CTRS.UnitPrice*DeliveryQuantity) + (CTRS.VATPerUnit*DeliveryQuantity) )) AS Value FROM dbo.tblInvoiceDetail  with(nolock)  
	   INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
	   INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblInvoiceDetail.DCStoreId  
	   INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId    
	   WHERE tblInvoice.ComUnitId = @DcId AND DeliveryStatus IN ('Full','Partial') AND  
	   InvoiceDate between @FromDate and @ToDate 
	   GROUP BY tblInvoiceDetail.ProductCode)  vTblsales ON vTblsales.ProductCode = P.ProductCode   
	   
	   LEFT JOIN (SELECT tblInvoiceDetail.ProductCode,SUM(BonusQuantity) BonusQty,  
	   SUM(((CTRS.UnitPrice*BonusQuantity) + (CTRS.VATPerUnit*BonusQuantity) )) AS Value FROM dbo.tblInvoiceDetail  with(nolock)  
	   INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
	   INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblInvoiceDetail.DCStoreId  
	   INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	   WHERE tblInvoice.ComUnitId = @DcId AND DeliveryStatus IN (NULL,'Full','Partial') AND  
	   InvoiceDate between @FromDate and @ToDate 
	   GROUP BY tblInvoiceDetail.ProductCode)  AS vbBonus ON vbBonus.ProductCode = P.ProductCode    
	   
	   LEFT JOIN (SELECT tblInvoiceDetail.ProductCode,SUM(DeliveryQuantity)Sales, SUM(((CTRS.UnitPrice*DeliveryQuantity) + 
	   (CTRS.VATPerUnit*DeliveryQuantity) )) AS Value FROM dbo.tblInvoiceDetail  with(nolock)  
	   INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
	   INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblInvoiceDetail.DCStoreId  
	   INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId  
	    WHERE tblInvoice.ComUnitId = @DcId AND OrderDetailsId=0 and InvoiceDate 
		between @FromDate and @ToDate GROUP BY tblInvoiceDetail.ProductCode) 
		vTblProductBonus ON vTblProductBonus.ProductCode = P.ProductCode    
		
		LEFT JOIN (SELECT tblInvoiceDetail.ProductCode,SUM(tblInvoiceDetail.TotalQuantity)Sales,  
		SUM(((CTRS.UnitPrice*tblInvoiceDetail.TotalQuantity) + (CTRS.VATPerUnit*tblInvoiceDetail.TotalQuantity) )) AS Value FROM dbo.tblInvoiceDetail  with(nolock)  
		INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId    
		INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblInvoiceDetail.DCStoreId  
		INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId  WHERE tblInvoice.ComUnitId = @DcId 
		AND  DeliveryStatus IS NULL and InvoiceDate between @FromDate and @ToDate 
		GROUP BY tblInvoiceDetail.ProductCode)  vTblsalesInTransit ON vTblsalesInTransit.ProductCode = P.ProductCode  

		LEFT JOIN (SELECT tblChalanDetail.ProductCode,SUM(tblChalanDetail.Quantity)Challan,  
		SUM(((CTRS.UnitPrice*tblChalanDetail.Quantity) + (CTRS.VATPerUnit*tblChalanDetail.Quantity) )) AS Value FROM dbo.tblChalanDetail  with(nolock)  
		INNER JOIN dbo.tblChalanInfo ON tblChalanDetail.ChalanId=tblChalanInfo.ChalanId  
		INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblChalanDetail.DCStoreId  
		INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId  WHERE FromComUnitId = @DcId AND  
		tblChalanInfo.ChalanDate between @FromDate and @ToDate AND IsDeliver = 'True'
		 GROUP BY tblChalanDetail.ProductCode) vTblChallan ON vTblChallan.ProductCode = P.ProductCode   

		 LEFT JOIN (SELECT tblChalanDetail.ProductCode,SUM(tblChalanDetail.Quantity)Challan,
		 SUM(((CTRS.UnitPrice*tblChalanDetail.Quantity) + (CTRS.VATPerUnit*tblChalanDetail.Quantity) )) AS Value FROM dbo.tblChalanDetail  with(nolock)  
		 INNER JOIN dbo.tblChalanInfo ON tblChalanDetail.ChalanId=tblChalanInfo.ChalanId  
		 INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblChalanDetail.DCStoreId  
		 INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId   
		 WHERE FromComUnitId = @DcId AND  tblChalanInfo.ChalanDate between @FromDate and @ToDate 
		 AND IsDeliver = 'False' GROUP BY tblChalanDetail.ProductCode) vTblChallanTransit ON vTblChallanTransit.ProductCode = P.ProductCode  
		 
		 LEFT JOIN (SELECT tblDCStoreFreeze.ProductCode,(SUM(tblDCStoreFreeze.StockQty)+SUM(tblDCStoreFreeze.DamageQty))Freeze,  
		 SUM(((CTRS.UnitPrice*tblDCStoreFreeze.StockQty) + (CTRS.VATPerUnit*tblDCStoreFreeze.StockQty) )) 
		 + SUM(((CTRS.UnitPrice*tblDCStoreFreeze.DamageQty) + (CTRS.VATPerUnit*tblDCStoreFreeze.DamageQty) ))  AS Value FROM dbo.tblDCStoreFreeze  with(nolock)   
		 INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblDCStoreFreeze.DCStoreId  
		 INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId     
		 WHERE tblDCStoreFreeze.ComUnitId = @DcId and  tblDCStoreFreeze.[StockCondition]='Restricted' and 
		 tblDCStoreFreeze.StockRcvDate between @FromDate and @ToDate 
		 GROUP BY tblDCStoreFreeze.ProductCode) vTblFreez ON vTblFreez.ProductCode = P.ProductCode
		    
		 LEFT JOIN (SELECT tblDCStoreFreeze.ProductCode,(SUM(tblDCStoreFreeze.StockQty)+SUM(tblDCStoreFreeze.DamageQty))Freeze,  
		 SUM(((CTRS.UnitPrice*tblDCStoreFreeze.StockQty) + (CTRS.VATPerUnit*tblDCStoreFreeze.StockQty) )) 
		 + SUM(((CTRS.UnitPrice*tblDCStoreFreeze.DamageQty) + (CTRS.VATPerUnit*tblDCStoreFreeze.DamageQty) )) AS Value FROM dbo.tblDCStoreFreeze  with(nolock)  
		 INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = tblDCStoreFreeze.DCStoreId  
		 INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId    
		 WHERE tblDCStoreFreeze.ComUnitId = @DcId and  tblDCStoreFreeze.[StockCondition]='Blocked' 
		 and tblDCStoreFreeze.StockRcvDate between @FromDate and @ToDate 
		 GROUP BY tblDCStoreFreeze.ProductCode) vTblFreez2 ON vTblFreez2.ProductCode = P.ProductCode  

		 LEFT JOIN (SELECT SMPD.ProductCode,SUM(SMPD.Quantity) SampleIssue,
		 SUM(((CTRS.UnitPrice*SMPD.Quantity) + (CTRS.VATPerUnit*SMPD.Quantity) )) AS Value FROm tblSampleIssue AS SMPI  
		 LEFT JOIN tblSampleIssueDetail AS SMPD ON SMPI.OrderId = SMPD.OrderId  
		 LEFT JOIN dbo.tblSampleIssueTranscation AS ST ON ST.IssueDetailId = SMPD.OrderDetailId  
		 INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = ST.DCStoreId  
		 INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
		 WHERE ActionStatus IN ('Accepted')  AND ApprovedDate BETWEEN @FromDate and @ToDate 
		 AND SMPI.ComUnitId = @DcId GROUP BY SMPD.ProductCode)  vTblSample ON vTblSample.ProductCode = P.ProductCode  

		 LEFT JOIN (SELECT sum(StockQty)Closingstock,DCS.ProductCode,
		 SUM(((CTRS.UnitPrice*DCS.StockQty) + (CTRS.VATPerUnit*DCS.StockQty) )) AS Value FROM dbo.tblDCStore AS DCS  with(nolock)  
		 INNER JOIN tblStockInTransfar AS TNS ON TNS.StockInTransfarId = DCS.StockInTransfarId  
		 INNER JOIN tblCentralStore AS CTRS ON TNS.ReceiveId = CTRS.ReceiveId   
		 WHERE ComUnitId= @DcId group by DCS.ProductCode) currentStock ON currentStock.ProductCode = P.ProductCode 
		 WHERE P.CompanyId = @CompanyId ORDER BY P.ProductCode

END




