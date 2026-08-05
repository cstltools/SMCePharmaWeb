-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_Auto_AutoStockUpdate] 
--exec sp_Auto_AutoStockUpdate

AS
BEGIN
DECLARE @comunit INT = 1

WHILE @comunit <= 13
BEGIN
DECLARE @DCStoreId NVARCHAR(500)
DECLARE @ComUnitId NVARCHAR(500)
DECLARE @Av NVARCHAR(500)

DECLARE @Error NVARCHAR(500)
DECLARE @pcode NVARCHAR(500)

DECLARE @diff NVARCHAR(500)
--DECLARE @comunit NVARCHAR(500)=6


--Declare 1 int =1

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------


SELECT  P.ProductCode as ProductCode,
((((ISNULL(vTblOB.Quantity,0) + ISNULL(vTblStoReceive.TotalStockReceiveQty,0)+ISNULL(vTblChallanReceive.TotalStockReceiveQty,0)))
-(ISNULL(vTblsales.Sales,0)-(ISNULL(tblD.DelQty,0)+(ISNULL(tblDRT.DelQty,0) )+(ISNULL(tblDRTsub.DelQty,0))))
-(ISNULL(vTblProductBonus.Sales,0)-(ISNULL(tblreturnBonus.DelQty,0)+ ISNULL(tblreturnBonusold.DelQty,0)))
-(ISNULL(vTblDirectStockOut.StockOutQty,0))
-(ISNULL(vTblChallan.Challan,0))
-(ISNULL( vTblChallantoWH.qty,0)))+ ISNULL(tblreturn.ReturnQty,0)
) - (tblcurrentstock.CStockQty)

as diff

-- ,ISNULL(vTblDirectStockOut.StockOutQty,0)StockOutQty,tblcurrentstock.CStockQty
---- ,


--(select ComUnitName from tblCompanyUnit where ComUnitId=1)ComUnitName,CONVERT(varchar,'1-July-2023',6)  as fromDate,CONVERT(varchar,CONVERT(date, GETDATE()),6)  as toDate,P.ProductName as ProductName ,P.PackSize as BaseUnit,  ( ISNULL(vTblOB.Quantity,0)  ) OpeningStock   ,
--ISNULL(vTblStoReceive.TotalStockReceiveQty,0) AS ReceiveFromCentralWarehouse   ,ISNULL(vTblChallanReceive.TotalStockReceiveQty,0) AS ReceiveFromAreaOfficeInterTransfer    ,
--ISNULL(vTblStockReceive.TotalStockReceiveQty,0)+ ( ISNULL(vTblOB.Quantity,0)  )+(ISNULL( vTblSubdeportReturn.qty2,0)) AS TotalReceived   ,
--(ISNULL(vTblsales.Sales,0)-(ISNULL(tblD.DelQty,0)+(ISNULL(tblDRT.DelQty,0) )+(ISNULL(tblDRTsub.DelQty,0))))  AS IssuedToSales   
--, (((ISNULL(vTblProductBonus.Sales,0)- ISNULL(tblreturnBonus.DelQty,0))  ))- ISNULL(tblreturnBonusold.DelQty,0) IssuedToProductBonus ,
--ISNULL(vTblChallan.Challan,0) AS IssuedToAreaOfficeInterTransfer    ,ISNULL(vTblFreez.Freeze,0) AS IssuedToDamageAndOthers,    ISNULL(vTblFreez2.Freeze,0) AS Blocked, 
   


 --ISNULL( vTblChallantoWH.qty,0) WHReturn  ,ISNULL( vTblSubdeportTransfer.qty1,0) SubdepoTransfer,ISNULL( vTblSubdeportReturn.qty2,0) Subdeporeturn ,


 -- ISNULL(vTblDirectStockOut.StockOutQty,0)StockOutQty


  
FROM dbo.tblProduct P  with(nolock)   
  
LEFT JOIN (SELECT ProductCode,SUM(StockQty)Quantity FROM dbo.tblDCStore_OpeningBalance  with(nolock) WHERE ComUnitId=@comunit AND 
DCOpeningBalanceDate='1-July-2023'                              GROUP BY ProductCode) vTblOB ON vTblOB.ProductCode = P.ProductCode      




LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty      FROM dbo.tblDCStore  with(nolock) WHERE ComUnitId=@comunit and SChalanDetailsId is null   AND ChalanDetailsId IS  NULL AND StockRcvDate 
BETWEEN '1-July-2023' and CONVERT(date, GETDATE())      GROUP BY ProductCode) vTblStoReceive ON vTblStoReceive.ProductCode = P.ProductCode   

LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty FROM dbo.tblDCStore  with(nolock)     WHERE ComUnitId = @comunit AND ChalanDetailsId IS NOT NULL AND StockRcvDate 
BETWEEN '1-July-2023' and CONVERT(date, GETDATE())     GROUP BY ProductCode) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode     


LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty FROM dbo.tblDCStore  with(nolock) WHERE ComUnitId=@comunit AND StockRcvDate 
BETWEEN '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode     


LEFT JOIN (SELECT ProductCode,SUM(tblInvoiceDetail.Quantity)Sales 
FROM dbo.tblInvoiceDetail  with(nolock) INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
WHERE  ComUnitId = @comunit AND ISGiftProduct=0 AND InvoiceDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblsales ON vTblsales.ProductCode = P.ProductCode  
 --OrderDetailsId<>0   
 
LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ComUnitId=@comunit AND ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE())
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = p.ProductCode 


LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)Sales FROM dbo.tblInvoiceDetail  with(nolock) INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId 
WHERE  ComUnitId = @comunit AND ISGiftProduct=1 and InvoiceDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode)
vTblProductBonus ON vTblProductBonus.ProductCode = P.ProductCode  


LEFT JOIN (SELECT (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ComUnitId=@comunit AND ISGiftProduct=1 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE())
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblreturnBonus ON tblreturnBonus.ProductCode = p.ProductCode 



	LEFT JOIN (SELECT (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ComUnitId=@comunit AND ISGiftProduct=1 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE())
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblreturnBonusold ON tblreturnBonusold.ProductCode = p.ProductCode 	 
   
LEFT JOIN (SELECT ProductCode,SUM(Quantity)Challan FROM dbo.tblChalanDetail  with(nolock) INNER JOIN dbo.tblChalanInfo ON tblChalanDetail.ChalanId=tblChalanInfo.ChalanId   
WHERE  FromComUnitId = @comunit AND  ChalanDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblChallan ON vTblChallan.ProductCode = P.ProductCode    

--IsDeliver='True' and
LEFT JOIN (SELECT ProductCode,(SUM(StockQty)+SUM(DamageQty))Freeze FROM dbo.tblDCStoreFreeze  with(nolock)    WHERE ComUnitId=@comunit and  [StockCondition]='Restricted' and ReceiveDate 
BETWEEN '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblFreez ON vTblFreez.ProductCode = P.ProductCode   


LEFT JOIN (SELECT ProductCode,(SUM(StockQty)+SUM(DamageQty))Freeze FROM dbo.tblDCStoreFreeze  with(nolock)    WHERE ComUnitId=@comunit and  [StockCondition]='Blocked' and ReceiveDate 
BETWEEN '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblFreez2 ON vTblFreez2.ProductCode = P.ProductCode   


LEFT JOIN (SELECT sum(StockQty)Closingstock,ProductCode FROM dbo.tblDCStore  with(nolock)    WHERE ComUnitId=@comunit group by ProductCode) currentStock ON currentStock.ProductCode = P.ProductCode 



--WH Return
LEFT JOIN (SELECT ProductCode,SUM(Quantity)qty FROM dbo.tblDepotToWHChalanInfo  with(nolock)
            INNER JOIN dbo.tblDepotToWHChalanDetail  ON tblDepotToWHChalanInfo.SChalanId=tblDepotToWHChalanDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblDepotToWHChalanInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode   
            WHERE  ComUnitId = @comunit AND  ChalanDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblChallantoWH ON vTblChallantoWH.ProductCode = P.ProductCode
--IsSoundProduct=1 and  
--Subdeport transfer
LEFT JOIN (SELECT ProductCode,SUM(Quantity)qty1 FROM dbo.tblSubDepotChalanInfo  with(nolock)
            INNER JOIN dbo.tblSubDepotChalanDetail  ON tblSubDepotChalanInfo.SChalanId=tblSubDepotChalanDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode      
            WHERE  ComUnitId = @comunit AND  ChalanDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblSubdeportTransfer ON vTblSubdeportTransfer.ProductCode = P.ProductCode  
--IsDeliver='True' AND

--Subdeport Return
LEFT JOIN (	SELECT ProductCode,SUM(Quantity)qty2 FROM dbo.tblSubDepotChalanReturnInfo  with(nolock)
            INNER JOIN dbo.tblSubDepotChalanRetuenDetail  ON tblSubDepotChalanReturnInfo.SChalanId=tblSubDepotChalanRetuenDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanReturnInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode     
            WHERE IsDeliver='True' AND ComUnitId = @comunit AND  ChalanDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblSubdeportReturn ON vTblSubdeportReturn.ProductCode = P.ProductCode  

--Direct Stock Out or Adjustment Voucher

LEFT JOIN (SELECT ProductCode,SUM(StackOutQty)StockOutQty FROM dbo.tblDeStockOutMaster  with(nolock)
            INNER JOIN dbo.tblDeStockOutDetails  ON tblDeStockOutMaster.DcStockOutMasterId=tblDeStockOutDetails.DcStockOutMasterId   
			INNER JOIN dbo.tblCompanyUnit  ON tblDeStockOutMaster.ComUnitId=tblCompanyUnit.ComUnitId      
            WHERE  tblDeStockOutMaster.ComUnitId = @comunit AND  ApprovedDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblDirectStockOut ON vTblDirectStockOut.ProductCode = P.ProductCode  


--LEFT JOIN (SELECT ProductCode,SUM(Quantity)StockOutQtySub FROM dbo.tblSubDepotChalanInfo  with(nolock)
--            INNER JOIN dbo.tblSubDepotChalanDetail  ON tblSubDepotChalanInfo.SChalanId=tblSubDepotChalanDetail.SChalanId   
--			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode      
--            WHERE  ComUnitId = 6 AND  ChalanDate between '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode) vTblDirectStockOutSub ON vTblSubdeportTransfer.ProductCode = P.ProductCode  

LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ComUnitId=@comunit AND ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE())
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDRT ON tblDRT.ProductCode = p.ProductCode 

LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ComUnitId=@comunit AND ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE())
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDRTsub ON tblDRTsub.ProductCode = p.ProductCode 



LEFT JOIN (SELECT ProductCode,SUM(StockQty)CStockQty FROM dbo.tblDCStore  with(nolock)
			INNER JOIN dbo.tblCompanyUnit  ON tblDCStore.ComUnitId=tblCompanyUnit.ComUnitId      
            WHERE  tblDCStore.ComUnitId = @comunit GROUP BY ProductCode) tblcurrentstock ON tblcurrentstock.ProductCode = P.ProductCode  
			LEFT JOIN (SELECT ProductCode,SUM(tblInvoiceDetail.Quantity)InvActualQty 
FROM dbo.tblInvoiceDetail  with(nolock) 
INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
WHERE   ISGiftProduct=0 AND InvoiceDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode)  TblInvActual ON TblInvActual.ProductCode = P.ProductCode  


LEFT JOIN (SELECT ProductCode,SUM(tblInvoiceDetail.DeliveryQuantity)-SUM(tblInvoiceDetail.PaymentQuantity) ReturnQty 
FROM dbo.tblInvoiceDetail  with(nolock) 
INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
WHERE PaymentInvoiceNo is not null and  DeliveryQuantity<>PaymentQuantity  and ComUnitId = @comunit  AND tblInvoice.PaymentDate BETWEEN '1-July-2023' and CONVERT(date, GETDATE()) GROUP BY ProductCode)  
tblreturn ON tblreturn.ProductCode = P.ProductCode 

where 
(((ISNULL(vTblOB.Quantity,0) + ISNULL(vTblStoReceive.TotalStockReceiveQty,0)+ISNULL(vTblChallanReceive.TotalStockReceiveQty,0)))
-(ISNULL(vTblsales.Sales,0)-(ISNULL(tblD.DelQty,0)+(ISNULL(tblDRT.DelQty,0) )+(ISNULL(tblDRTsub.DelQty,0))))
-(ISNULL(vTblProductBonus.Sales,0)-(ISNULL(tblreturnBonus.DelQty,0)+ ISNULL(tblreturnBonusold.DelQty,0)))
-(ISNULL(vTblDirectStockOut.StockOutQty,0))
-(ISNULL(vTblChallan.Challan,0))
-(ISNULL( vTblChallantoWH.qty,0)))+ ISNULL(tblreturn.ReturnQty,0)

<>ISNULL(tblcurrentstock.CStockQty,0)
 --and p.ProductCode='AID02'

order by ProductName




----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@pcode,@diff
WHILE @@FETCH_STATUS = 0
BEGIN

--StockQty+=@diff   StockQty=0  StockQty>=@diff
update m SET  StockQty+=@diff  from (select top (1) * from tblDCStore where ProductCode=@pcode and ComUnitId=@comunit
and StockQty>0
order by BatchNo,ExpDate,DCStoreId asc)m
where m.StockQty>0

--select top 1 * from tblDCStore where ProductCode='AID02' and ComUnitId=1  and StockQty>0 order by BatchNo,ExpDate,DCStoreId asc

--select SUBSTRING(@diff, 2, 13)

FETCH NEXT FROM @MyCursor
INTO 
@pcode,@diff

END
CLOSE @MyCursor
DEALLOCATE @MyCursor

SET @comunit = @comunit + 1
END

--select * from tblCompanyUnit










	
END






