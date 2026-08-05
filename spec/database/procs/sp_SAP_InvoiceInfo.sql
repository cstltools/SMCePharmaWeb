CREATE PROCEDURE [dbo].[sp_SAP_InvoiceInfo]
   
AS
BEGIN
 
  select top 10	InvoiceNo,I.InvoiceId as Line,D.ProductCode,'M100' as CustomerCode,'Pharma' as CustomerPONo,'Pharma-1002'SalesOrg,'Direct - 01' as DistChnl,
'Pharma - 01' as Division,'SMC' as Plant,'StorageLoc' as StorageLoc,'Region' as Region,'Territory' as Territory,Quantity as Quantity,'PAC'as UoM,TpTotal as UnitPrice,
format(UpdateDatetime, 'dd.MM.yyyy') as CustomerRefDt, UpdateDatetime as SalesDocDate,'SAP' PaymentTerms,'SAP' Inco1, 'SAP' Inco2, 'OR' OrderReason,UpdateDatetime as DeliveryDate
,DiscountAmount as DiscountAmount, 'Outlet' Outlet,
'General' OutletType,' '	FOCFlag,'OT'	OrderType,' '	OldReferenceNo,	' ' OldLineNo

from tblInvoice I
inner join tblInvoiceDetail D on I.InvoiceId=D.InvoiceId
 
END
 