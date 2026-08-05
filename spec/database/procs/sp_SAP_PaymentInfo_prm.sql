CREATE PROCEDURE [dbo].[sp_SAP_PaymentInfo_prm]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
-- Payment

Select 
  OrderCode as MemoNo,replace(convert(varchar,  I.UpdateDate,101),'/','')  as DocDate,replace(convert(varchar,  I.UpdateDate,101),'/','')   as PostingDate,
  OrderCode as DocHeaderText ,'2332010' as BankAccount,tblAMt.Amt as Amount, replace(convert(varchar,  I.UpdateDate,101),'/','')  as  Valuedate     ,         'PC1001' as ProfitCenter , OrderCode
   as lineItemText, M.SAP_MIOCode as CustomerAccount

from tblOrder O
--inner join tblOrderDetail OD on O.OrderId=OD.OrderId
--left join tblProduct P on OD.ProductCode=P.ProductCode
left join tblMIOInfo M on M.MIOId=O.MIOId
left join tblInvoice I on I.OrderId=O.OrderId 
inner join (select I.InvoiceId,sum(DeliveryNetAmount)Amt from tblInvoice I
            inner join tblInvoiceDetail D on D.InvoiceId=I.InvoiceId group by  I.InvoiceId)tblAMt on tblAMt.InvoiceId=I.InvoiceId
--left join tblInvoiceDetail D on OD.OrderDetailId=D.OrderDetailsId 
where  SAP_MIOCode is not null and ( I.UpdateDate between convert(varchar, @FrmDate, 104)  and convert(varchar, @ToDate, 104) ) and  (DelivaryInvoiceNo is not null) 

order by O.OrderCode desc

--union all

---- Return
--select 	InvoiceNo,I.InvoiceId as Line,D.ProductCode,MIOName as CustomerCode,'Pharma' as CustomerPONo,'Pharma-1002'SalesOrg,'Direct - 01' as DistChnl,
--'Pharma - 01' as Division,tblOrder.ComUnitCode as Plant,'StorageLoc' as StorageLoc,'Region' as Region,'Territory' as Territory,Quantity as Quantity,'PAC'as UoM,D.TotalPrice as UnitPrice,
--OrderDate as CustomerRefDt, InvoiceDate as SalesDocDate,'001' PaymentTerms,'SAP' Inco1, 'SAP' Inco2, 'SAP' OrderReason,UpdateDatetime as DeliveryDate
--,D.DiscountAmount as DiscountAmount, CustomerCode as Outlet,
--'PHAR' OutletType, case when ISGiftProduct=1 then  'BFOC' Else ' ' end	FOCFlag, 'ZRET'	OrderType,' '	OldReferenceNo,	' ' OldLineNo

--from tblInvoice I
--inner join tblInvoiceDetail D on I.InvoiceId=D.InvoiceId 

--left join tblOrder on tblOrder.OrderId=I.OrderId


--where D.DeliveryStatus in ('Reject','Partial') and InvoiceDate between @FrmDate and @ToDate
 
END
 

