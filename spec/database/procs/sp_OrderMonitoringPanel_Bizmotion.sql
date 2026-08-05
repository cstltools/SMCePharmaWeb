-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_OrderMonitoringPanel_Bizmotion] 

@fromdate datetime,
@todate datetime
AS
BEGIN


SELECT 
isnull(Orders.OrderCount,0) as Ordertotal,
C.ShortName as SalesCentre,C.ShortName  as SalesCentreName, isnull(Orders.TP,0) as VALUE , isnull(Proforma.InvCount ,0)as TotalInvoice, isnull(Proforma.TP,0) as InvoiceValue, isnull(pending.OrderCount,0)    as PendinOrder, isnull(pending.TP,0) as  PendinOrderValue,  isnull(DelOrder.OrderCount,0) as  deleteorder,  isnull(DelOrder.TP,0) as  deletevalue

,CONVERT(decimal(18,2),ISNULL(tblReject.NetRejectionAmount,0)) as  Rejectvalue

from tblCompanyUnit c

			
left join	(SELECT DISTINCT count(distinct tblOrderDetail.OrderId)OrderCount ,ComUnitId,sum(tblOrderDetail.TotalTradePrice)TP FROM  tblOrder 
inner join tblOrderDetail on tblOrder.OrderId=tblOrderDetail.OrderId
where ActionStatus=2 and SubmissionDate
between @fromdate and @todate group by ComUnitId)   Orders on Orders.ComUnitId=C.ComUnitId




left join	(SELECT DISTINCT count(distinct tblInvoiceDetail.InvoiceId)InvCount ,ComUnitId,sum(tblInvoiceDetail.TotalPrice)TP FROM  tblInvoice 
inner join tblInvoiceDetail on tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId
where InvoiceDate
between @fromdate and @todate group by ComUnitId)   Proforma on Proforma.ComUnitId=C.ComUnitId




left join	(SELECT DISTINCT count(distinct tblOrderDetail.OrderId)OrderCount ,ComUnitId,sum(tblOrderDetail.TotalTradePrice)TP FROM  tblOrder 
inner join tblOrderDetail on tblOrder.OrderId=tblOrderDetail.OrderId
where ActionStatus=2 and IsInvoice=0  and SubmissionDate
between @fromdate and @todate group by ComUnitId)   pending on pending.ComUnitId=C.ComUnitId





left join	(SELECT DISTINCT count(distinct tblOrderDetailDel.OrderId)OrderCount ,ComUnitId,sum(tblOrderDetailDel.TotalTradePrice)TP FROM  tblOrderDel 
inner join tblOrderDetailDel on tblOrderDel.OrderId=tblOrderDetailDel.OrderId
where ActionStatus=2 and IsInvoice=0  and SubmissionDate
between @fromdate and @todate group by ComUnitId)   DelOrder on DelOrder.ComUnitId=C.ComUnitId


left join (SELECT O.ComUnitId, sum(D.TotalTradePrice) AS NetRejectionAmount  
                        FROM dbo.tblOrder O
                        INNER JOIN dbo.tblOrderDetail D ON O.OrderId = D.OrderId
					  left JOIN dbo.tblInvoice I ON O.OrderCode = I.OrderNo
                        WHERE Status='Undelivered' AND I.InvoiceNo IS NOT NULL and CONVERT(date,I.InvoiceDate)
between @fromdate and @todate group by O.ComUnitId)tblReject     on tblReject.ComUnitId=C.ComUnitId

		

order by C.ShortName asc
			
	
END


