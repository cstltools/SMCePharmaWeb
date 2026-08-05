-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MonthlyInventoryReport] 

	@fromDate datetime,
	@toDate DATETIME,
	@CiD nvarchar(max) ,
	@ProTypId nvarchar(max) 


AS
BEGIN



SELECT  isnull(BookforDeliveryQty,0)  BookforDeliveryQty,
-- 0 TotalIssued, ISNULL(InvActualQty,0) InvoiceQty,  ISNULL(DelActualQty,0) SalesQty, 
 ISNULL(tblreturn.ReturnQty,0)+ isnull(tbl2ndrtn.Quantity,0) ReturnQty, 

isnull((select  ComUnitName from tblCompanyUnit where ComUnitId =@CiD),'')ComUnitName,CONVERT(varchar,@fromDate,6)  as fromDate,CONVERT(varchar,@toDate,6)  as toDate, P.ProductCode as ProductCode,P.ProductName as ProductName ,P.PackSize as BaseUnit,  (( ISNULL(vTblOB.Quantity,0)  )  + ISNULL(vTblOBfreez.Quantity,0)) OpeningStock ,
ISNULL(vTblStoReceive.TotalStockReceiveQty,0) AS ReceiveFromCentralWarehouse   ,ISNULL(vTblChallanReceive.TotalStockReceiveQty,0) AS ReceiveFromAreaOfficeInterTransfer    ,
ISNULL(vTblStockReceive.TotalStockReceiveQty,0)+ ( ISNULL(vTblOB.Quantity,0)  )+(ISNULL( vTblSubdeportReturn.qty2,0))+ ISNULL(vTblOBfreez.Quantity,0) AS TotalReceived   ,
(ISNULL(vTblsales.Sales,0)-(ISNULL(tblD.DelQty,0)+(ISNULL(tblDRT.DelQty,0) )+(ISNULL(tblDRTsub.DelQty,0))))   AS IssuedToSales   
, (((ISNULL(vTblProductBonus.Sales,0)- ISNULL(tblreturnBonus.DelQty,0))  ))- ISNULL(tblreturnBonusold.DelQty,0) IssuedToProductBonus ,
ISNULL(vTblChallan.Challan,0) AS IssuedToAreaOfficeInterTransfer    ,0 AS IssuedToDamageAndOthers,    ISNULL(vTblFreez2.Freeze,0) AS Blocked, 
   --ISNULL(vTblFreez.Freeze,0)
((((((ISNULL(vTblOB.Quantity,0)  + ISNULL(vTblOBfreez.Quantity,0)+ ISNULL(vTblStoReceive.TotalStockReceiveQty,0)+ISNULL(vTblChallanReceive.TotalStockReceiveQty,0)))
-(ISNULL(vTblsales.Sales,0)-(ISNULL(tblD.DelQty,0)+(ISNULL(tblDRT.DelQty,0) )+(ISNULL(tblDRTsub.DelQty,0))))
-(ISNULL(vTblProductBonus.Sales,0)-(ISNULL(tblreturnBonus.DelQty,0)+ ISNULL(tblreturnBonusold.DelQty,0)))
-(ISNULL(vTblDirectStockOut.StockOutQty,0))
-(ISNULL(vTblChallan.Challan,0))
-(ISNULL( vTblChallantoWH.qty,0))
)+ ISNULL(tblreturn.ReturnQty,0))))+ isnull(tbl2ndrtn.Quantity,0)
--ISNULL(vTblFreez.Freeze,0)

as ClosingStock,


 ISNULL( vTblChallantoWH.qty,0) WHReturn  ,ISNULL( vTblSubdeportTransfer.qty1,0) SubdepoTransfer,ISNULL( vTblSubdeportReturn.qty2,0) Subdeporeturn ,


  ISNULL(vTblDirectStockOut.StockOutQty,0)StockOutQty

-- SELECT * FROM dbo.tblCompanyUnit
  
FROM dbo.tblProduct P  with(nolock)   
  
LEFT JOIN (SELECT ProductCode,SUM(StockQty)Quantity FROM dbo.tblDCStore_OpeningBalance  with(nolock) WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND 
DCOpeningBalanceDate=@fromDate                              GROUP BY ProductCode) vTblOB ON vTblOB.ProductCode = P.ProductCode     

LEFT JOIN (SELECT ProductCode,SUM(StockQty)Quantity FROM dbo.tblDCStoreFreeze  with(nolock) WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND 
Opening=@fromDate                              GROUP BY ProductCode) vTblOBfreez ON vTblOBfreez.ProductCode = P.ProductCode   


LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
 ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId)AND ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDRTsub ON tblDRTsub.ProductCode = p.ProductCode 

LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty      FROM dbo.tblDCStore  with(nolock) WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId)  and SChalanDetailsId is null   AND ChalanDetailsId IS  NULL AND StockRcvDate 
BETWEEN @fromDate and @toDate      GROUP BY ProductCode) vTblStoReceive ON vTblStoReceive.ProductCode = P.ProductCode   

LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty FROM dbo.tblDCStore  with(nolock)     WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ChalanDetailsId IS NOT NULL AND StockRcvDate 
BETWEEN @fromDate and @toDate     GROUP BY ProductCode) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode     


LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)TotalStockReceiveQty FROM dbo.tblDCStore  with(nolock) WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND StockRcvDate 
BETWEEN @fromDate and @toDate GROUP BY ProductCode) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode     


LEFT JOIN (SELECT ProductCode,SUM(tblInvoiceDetail.Quantity)Sales 
FROM dbo.tblInvoiceDetail  with(nolock) INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
WHERE   ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ISGiftProduct=0 AND InvoiceDate between @fromDate and @toDate GROUP BY ProductCode) vTblsales ON vTblsales.ProductCode = P.ProductCode  
 --OrderDetailsId<>0   
 
LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
 ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblD ON tblD.ProductCode = p.ProductCode 


left join (  select ProductCode, sum(quantity) BookforDeliveryQty from tblinvoice 
inner join tblInvoiceDetail on tblinvoice .invoiceid=tblInvoiceDetail .invoiceid
where   DelivaryInvoiceNo is null and updatedate is null  and invoicedate between @fromDate and @toDate  group by ProductCode )tblBookforDeliveryQty ON tblBookforDeliveryQty.ProductCode = p.ProductCode 


LEFT JOIN (SELECT ProductCode,SUM(TotalQuantity)Sales FROM dbo.tblInvoiceDetail  with(nolock) INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId 
WHERE   ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ISGiftProduct=1 and InvoiceDate between @fromDate and @toDate GROUP BY ProductCode)
vTblProductBonus ON vTblProductBonus.ProductCode = P.ProductCode  


LEFT JOIN (SELECT (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
 ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ISGiftProduct=1 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblreturnBonus ON tblreturnBonus.ProductCode = p.ProductCode 



	LEFT JOIN (SELECT (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
 ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ISGiftProduct=1 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblreturnBonusold ON tblreturnBonusold.ProductCode = p.ProductCode 	 
   
LEFT JOIN (SELECT ProductCode,SUM(Quantity)Challan FROM dbo.tblChalanDetail  with(nolock) INNER JOIN dbo.tblChalanInfo ON tblChalanDetail.ChalanId=tblChalanInfo.ChalanId   
WHERE  FromComUnitId =COALESCE( NULLIF(@CiD , 0) ,FromComUnitId) AND  ChalanDate between @fromDate and @toDate GROUP BY ProductCode) vTblChallan ON vTblChallan.ProductCode = P.ProductCode    

--IsDeliver='True' and
LEFT JOIN (SELECT ProductCode,(SUM(StockQty)+SUM(DamageQty))Freeze FROM dbo.tblDCStoreFreeze  with(nolock)    WHERE ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId)  and StockRcvDate 
BETWEEN @fromDate and @toDate GROUP BY ProductCode) vTblFreez ON vTblFreez.ProductCode = P.ProductCode   


LEFT JOIN (SELECT ProductCode,(SUM(StockQty)+SUM(DamageQty))Freeze FROM dbo.tblDCStoreFreeze  with(nolock)    WHERE ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) and  [StockCondition]='Blocked' and ReceiveDate 
BETWEEN @fromDate and @toDate GROUP BY ProductCode) vTblFreez2 ON vTblFreez2.ProductCode = P.ProductCode   


LEFT JOIN (SELECT sum(StockQty)Closingstock,ProductCode FROM dbo.tblDCStore  with(nolock)    WHERE ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) group by ProductCode) currentStock ON currentStock.ProductCode = P.ProductCode 



--WH Return
LEFT JOIN (SELECT ProductCode,SUM(Quantity)qty FROM dbo.tblDepotToWHChalanInfo  with(nolock)
            INNER JOIN dbo.tblDepotToWHChalanDetail  ON tblDepotToWHChalanInfo.SChalanId=tblDepotToWHChalanDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblDepotToWHChalanInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode   
            WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND  ChalanDate between @fromDate and @toDate GROUP BY ProductCode) vTblChallantoWH ON vTblChallantoWH.ProductCode = P.ProductCode
--IsSoundProduct=1 and  
--Subdeport transfer
LEFT JOIN (SELECT ProductCode,SUM(Quantity)qty1 FROM dbo.tblSubDepotChalanInfo  with(nolock)
            INNER JOIN dbo.tblSubDepotChalanDetail  ON tblSubDepotChalanInfo.SChalanId=tblSubDepotChalanDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode      
            WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND  ChalanDate between @fromDate and @toDate GROUP BY ProductCode) vTblSubdeportTransfer ON vTblSubdeportTransfer.ProductCode = P.ProductCode  
--IsDeliver='True' AND

--Subdeport Return
LEFT JOIN (	SELECT ProductCode,SUM(Quantity)qty2 FROM dbo.tblSubDepotChalanReturnInfo  with(nolock)
            INNER JOIN dbo.tblSubDepotChalanRetuenDetail  ON tblSubDepotChalanReturnInfo.SChalanId=tblSubDepotChalanRetuenDetail.SChalanId   
			INNER JOIN dbo.tblCompanyUnit  ON tblSubDepotChalanReturnInfo.FromComUnitCode=tblCompanyUnit.ComUnitCode     
            WHERE IsDeliver='True' AND ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND  ChalanDate between @fromDate and @toDate GROUP BY ProductCode) vTblSubdeportReturn ON vTblSubdeportReturn.ProductCode = P.ProductCode  

--Direct Stock Out or Adjustment Voucher

LEFT JOIN (SELECT ProductCode,SUM(StackOutQty)StockOutQty FROM dbo.tblDeStockOutMaster  with(nolock)
            INNER JOIN dbo.tblDeStockOutDetails  ON tblDeStockOutMaster.DcStockOutMasterId=tblDeStockOutDetails.DcStockOutMasterId   
			INNER JOIN dbo.tblCompanyUnit  ON tblDeStockOutMaster.ComUnitId=tblCompanyUnit.ComUnitId      
            WHERE  tblDeStockOutMaster.ComUnitId =COALESCE( NULLIF(@CiD , 0) ,tblDeStockOutMaster.ComUnitId) AND  ApprovedDate between @fromDate and @toDate GROUP BY ProductCode) vTblDirectStockOut ON vTblDirectStockOut.ProductCode = P.ProductCode  


LEFT JOIN (SELECT ProductCode,SUM(StockQty)StockQty FROM dbo.tblDCStoreFreeze  with(nolock)
            WHERE   StockRcvDate between @fromDate and @toDate GROUP BY ProductCode) tblfreez ON tblfreez.ProductCode = P.ProductCode  


LEFT JOIN (SELECT (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))DelQty,ID.ProductCode, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - 
ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo) NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) AS
TotalPriceVatAmount FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK) INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE
ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId) AND ISGiftProduct=0 and
ID.DeliveryStatus IN ('Reject','Partial') 
AND I.UpdateDate BETWEEN @fromDate and @toDate
AND I.TpGrandTotal>0  GROUP BY ID.ProductCode)tblDRT ON tblDRT.ProductCode = p.ProductCode 

LEFT JOIN (select  
P.ProductCode,
sum((isnull(tblInvoiceDetailReturn.PreviousQuantity ,0)))  
- sum((isnull(tblInvoiceDetailReturn.sndReturnQuantity ,0)))   as Quantity


from tblInvoice  iv with(nolock)
inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
left join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
left join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
left join tblEmpGeneralInfo on tblEmpGeneralInfo.EmpMasterCode=o.OrderSenderCode
left join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
left join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode
left join tblArea on o.AreaId=tblArea.AreaId
left join tblRegion on o.RegionId =tblRegion.RegionId
left join tblDCStore on tblDCStore.DCStoreId =ivD.DCStoreId
inner join tblInvoiceDetailReturn on tblInvoiceDetailReturn.InvoiceDetailId=ivD.InvoiceDetailId

where  

tblInvoiceDetailReturn.PreviousQuantity<>tblInvoiceDetailReturn.sndReturnQuantity
and iv.SndReturnPaymentDate between  @fromDate and @toDate
and iv.ComUnitId =COALESCE( NULLIF(@CiD , 0) ,iv.ComUnitId)

group by P.ProductCode)
tbl2ndrtn ON tbl2ndrtn.ProductCode = P.ProductCode  

-----------
---new colums stock
LEFT JOIN (SELECT ProductCode,SUM(tblInvoiceDetail.Quantity)InvActualQty 
FROM dbo.tblInvoiceDetail  with(nolock) 
INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
WHERE  ComUnitId =COALESCE( NULLIF(@CiD , 0) ,ComUnitId)  AND ISGiftProduct=0 AND InvoiceDate between @fromDate and @toDate GROUP BY ProductCode)  TblInvActual ON TblInvActual.ProductCode = P.ProductCode  


LEFT JOIN (SELECT ProductCode,SUM(tblInvoiceDetail.DeliveryQuantity)-SUM(tblInvoiceDetail.PaymentQuantity) ReturnQty 
FROM dbo.tblInvoiceDetail  with(nolock) 
INNER JOIN dbo.tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId  
WHERE PaymentInvoiceNo is not null and  DeliveryQuantity<>PaymentQuantity  and ComUnitId  =COALESCE( NULLIF(@CiD , 0) ,ComUnitId)   AND tblInvoice.PaymentDate between @fromDate and @toDate GROUP BY ProductCode)  
tblreturn ON tblreturn.ProductCode = P.ProductCode 

where   
 (p.ProductGroupId= COALESCE( NULLIF(@ProTypId , 0) ,p.ProductGroupId))  

--where  P.GroupId=1
order by ProductName

	
END
