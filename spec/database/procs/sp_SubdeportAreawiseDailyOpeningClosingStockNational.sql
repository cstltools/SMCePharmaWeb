-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_SubdeportAreawiseDailyOpeningClosingStockNational] 

	@fromDate datetime,
	@toDate DATETIME

AS

    
	BEGIN

	
SELECT P.ProductCode as ProductCode,P.ProductName as ProductName ,P.PackSize as BaseUnit  ,

( ISNULL(vTblOB.Quantity,0)  ) OpeningStock  , 
--ISNULL(vTblStockReceive.TotalStockReceiveQty,0) AS ReceiveFromAreaOfficeInterTransfer    ,
( ISNULL(vTblOB.Quantity,0)  )+(ISNULL( vTblStockReceive.TotalStockReceiveQty,0)) AS TotalReceived   ,
(  ( ISNULL(vTblsalesSubdeport.Sales,0))      - ( ( ISNULL(tblDSubDeport.DelQty,0))       ) )  AS IssuedToSales   
,( (ISNULL(vTblProductBonusSubdeport.Sales,0)- ISNULL(tblreturnBonusSubdeport.DelQty,0))  )AS IssuedToProductBonus   
,ISNULL(vTblFreez.Freeze,0) AS IssuedToDamageAndOthers,    ISNULL(vTblFreez2.Freeze,0) AS Blocked, 
   


ISNULL( vTblStockReceive.TotalStockReceiveQty,0) Subdeporeturn ,
ISNULL( vTblSubdeportReturn.qty2,0) SubdepoTransfer,



(((ISNULL(vTblOB.Quantity,0) + (ISNULL( vTblStockReceive.TotalStockReceiveQty,0)) ))
-((((  ( ISNULL(vTblsalesSubdeport.Sales,0))      - ( ( ISNULL(tblDSubDeport.DelQty,0))       ) ) ))+(ISNULL(vTblFreez.Freeze,0))+
(ISNULL(vTblFreez2.Freeze,0))+( (ISNULL(vTblProductBonusSubdeport.Sales,0)- ISNULL(tblreturnBonusSubdeport.DelQty,0))  )))-ISNULL( vTblSubdeportReturn.qty2,0)
as ClosingStock



-- Opening Balance
  
FROM dbo.tblProduct P  with(nolock)     
LEFT JOIN (SELECT ProductCode,SUM(StockQty)Quantity FROM dbo.tblSubDCStore_OpeningBalance  with(nolock) WHERE
DCOpeningBalanceDate=@fromDate    GROUP BY ProductCode) vTblOB ON vTblOB.ProductCode = P.ProductCode      


--Receive

--LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty      FROM dbo.tblDCStore  with(nolock) WHERE SChalanDetailsId is null   AND ChalanDetailsId IS  NULL AND StockRcvDate 
--BETWEEN @fromDate and @toDate      GROUP BY ProductCode) vTblStoReceive ON vTblStoReceive.ProductCode = P.ProductCode   

LEFT JOIN (SELECT ProductCode,SUM(Quantity)TotalStockReceiveQty FROM dbo.tblSubDepotChalanInfo  with(nolock)    
INNER JOIN dbo.tblSubDepotChalanDetail ON tblSubDepotChalanDetail.SChalanId = tblSubDepotChalanInfo.SChalanId
 WHERE  ChalanDate 
BETWEEN @fromDate and @toDate  GROUP BY ProductCode) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode     


--select * from tblSubDepotChalanInfo

LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty FROM dbo.tblSubDepotStore  with(nolock) WHERE StockRcvDate 
BETWEEN @fromDate and @toDate GROUP BY ProductCode) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode     


--Sales


LEFT JOIN (SELECT ProductCode,SUM(tblSubInvoiceDetail.Quantity)Sales 
FROM dbo.tblSubInvoiceDetail  with(nolock) INNER JOIN dbo.tblSubInvoiceMaster ON tblSubInvoiceDetail.InvoiceId=tblSubInvoiceMaster.InvoiceId  
WHERE  ISGiftProduct=0 AND InvoiceDate between @fromDate and @toDate GROUP BY ProductCode) vTblsalesSubdeport ON vTblsalesSubdeport.ProductCode = P.ProductCode  
 
 


LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount 
FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDSubDeport ON tblDSubDeport.ProductCode = p.ProductCode 

		  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----Subdeport bonus


LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)Sales FROM dbo.tblSubInvoiceDetail  with(nolock) INNER JOIN dbo.tblSubInvoiceMaster ON tblSubInvoiceDetail.InvoiceId=tblSubInvoiceMaster.InvoiceId 
WHERE   ISGiftProduct=1 and InvoiceDate between @fromDate and @toDate GROUP BY ProductCode)
vTblProductBonusSubdeport ON vTblProductBonusSubdeport.ProductCode = P.ProductCode  


LEFT JOIN (SELECT (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
 ISGiftProduct=1 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
 GROUP BY ID.ProductCode)tblreturnBonusSubdeport ON tblreturnBonusSubdeport.ProductCode = p.ProductCode 

-----end


---Freez
LEFT JOIN (SELECT ProductCode,(SUM(StockQty)+SUM(DamageQty))Freeze FROM dbo.tblSubDepotStoreFreeze  with(nolock)    WHERE   [StockCondition]='Restricted' and ReceiveDate 
BETWEEN @fromDate and @toDate GROUP BY ProductCode) vTblFreez ON vTblFreez.ProductCode = P.ProductCode   


LEFT JOIN (SELECT ProductCode,(SUM(StockQty)+SUM(DamageQty))Freeze FROM dbo.tblSubDepotStoreFreeze  with(nolock)    WHERE   [StockCondition]='Blocked' and ReceiveDate 
BETWEEN @fromDate and @toDate GROUP BY ProductCode) vTblFreez2 ON vTblFreez2.ProductCode = P.ProductCode   
---Freez end





-- Return to Kustia
LEFT JOIN (	SELECT ProductCode,SUM(Quantity)qty2 FROM dbo.tblSubDepotChalanReturnInfo  with(nolock)
            INNER JOIN dbo.tblSubDepotChalanRetuenDetail  ON tblSubDepotChalanReturnInfo.SChalanId=tblSubDepotChalanRetuenDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanReturnInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode     
            WHERE  ChalanDate between @fromDate and @toDate GROUP BY ProductCode) vTblSubdeportReturn ON vTblSubdeportReturn.ProductCode = P.ProductCode  





			

---- Return to Kustia
--LEFT JOIN (	SELECT ProductCode,SUM(Quantity)qty2 FROM dbo.tblSubDepotChalanReturnInfo  with(nolock)
--            INNER JOIN dbo.tblSubDepotChalanRetuenDetail  ON tblSubDepotChalanReturnInfo.SChalanId=tblSubDepotChalanRetuenDetail.SChalanId   
--			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanReturnInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode     
--            WHERE IsDeliver='True'  AND  ChalanDate between @fromDate and @toDate GROUP BY ProductCode) vTblSubdeportReturn ON vTblSubdeportReturn.ProductCode = P.ProductCode  


	
	
	END

