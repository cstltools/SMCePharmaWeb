CREATE PROCEDURE [dbo].[sp_SAP_InvoiceInfo_prm]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

 

select distinct InvoiceId, CustomerCode, O.InvoiceNo as InvoiceNo,O.OrderNo OrderNo,  SalesOrg,  CustomerPONo,   DistChnl,   Division, Territory, format(convert(date, CustomerRefDt ),'dd.MM.yyyy' )  CustomerRefDt, FORMAT(SalesDocDate,'dd.MM.yyyy') SalesDocDate,  DeliveryDate,  PaymentTerms,   OrderType

from SAP_tblSales_Order O  with (nolock)
  
 --where  ( convert(Date, O.SalesDocDate ) between convert(Date, '02.01.2023' )  and convert(Date, '02.01.2023' )  ) 
where  ( convert(Date, O.CustomerRefDt ) between convert(Date, @FrmDate )  and convert(Date, @ToDate )  ) 
 

 
 
--select  I.InvoiceNo as InvoiceNo,O.OrderCode OrderNo, I.InvoiceId, 'EE00030009' CustomerCode, '1001' SalesOrg, ' ' CustomerPONo, '01' DistChnl, '01' Division,'001' Territory,format( O.SubmissionDate,'dd.MM.yyyy') CustomerRefDt,format( I.InvoiceDate,'dd.MM.yyyy') SalesDocDate, format( I.UpdateDate,'dd.MM.yyyy') DeliveryDate,  '001' PaymentTerms,  'ZORS' OrderType

--from tblOrder O  with (nolock)
 
--left join tblInvoice I  with (nolock) on I.OrderId=O.OrderId 

--inner join ( select OD.InvoiceId from tblInvoiceDetail OD  with (nolock)  ) tbldt on I.InvoiceId=tbldt.InvoiceId 
 
--where  ( convert(Date, O.SubmissionDate ) between convert(Date, @FrmDate )  and convert(Date, @FrmDate )  ) 
--and DelivaryInvoiceNo is null
 

--order by O.OrderCode desc
 
 
END
 

