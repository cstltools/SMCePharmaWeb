CREATE PROCEDURE [dbo].[sp_SAP_STOList_prm]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
-- Payment

Select StockInTransfarId as OutboundDeliveryID,convert(varchar, ReceiveDate, 104) OBDDate,convert(varchar, ReceiveDate, 108) OBDTime
,R.ReqNo as PO_NUMBER,StockInTransfarId as ItemLineNo,P.SAP_Code as ItemCode,BatchNo as Batch,convert(varchar, ExpDate, 104)ExpDate,'PAC' as Unit,Quantity as Quantity
,'1004' as IssuingOffice , 1003 as ReceivingPlant, '10' PO_ITEM,'FG01' as StorageLoc
  --z as MemoNo,replace(convert(varchar,  I.UpdateDate,101),'/','')  as DocDate,replace(convert(varchar,  I.UpdateDate,101),'/','')   as PostingDate,
  --OrderCode as DocHeaderText ,'2332010' as BankAccount,tblAMt.Amt as Amount, replace(convert(varchar,  I.UpdateDate,101),'/','')  as  Valuedate     ,         'PC1001' as ProfitCenter , OrderCode
  -- as lineItemText, M.SAP_MIOCode as CustomerAccount

from tblStockInTransfar T
inner join tblRequisition R on R.ReqId= T.ReqId
inner join tblProduct P on T.ProductCode=P.ProductCode

where  IsTransfared='OK'  and convert(varchar, ReceiveDate, 104)  between @FrmDate and @ToDate
--inner join tblOrderDetail OD on O.OrderId=OD.OrderId
--left join tblMIOInfo M on M.MIOId=O.MIOId
--left join tblInvoice I on I.OrderId=O.OrderId 
--inner join (select I.InvoiceId,sum(DeliveryNetAmount)Amt from tblInvoice I
--            inner join tblInvoiceDetail D on D.InvoiceId=I.InvoiceId group by  I.InvoiceId)tblAMt on tblAMt.InvoiceId=I.InvoiceId
--left join tblInvoiceDetail D on OD.OrderDetailId=D.OrderDetailsId 

--SAP_MIOCode is not null and ( I.UpdateDate between convert(varchar, @FrmDate, 104)  and convert(varchar, @ToDate, 104) ) and  (DelivaryInvoiceNo is not null) 

--order by O.OrderCode desc


 
END


--  select * from tblStockInTransfar
 

