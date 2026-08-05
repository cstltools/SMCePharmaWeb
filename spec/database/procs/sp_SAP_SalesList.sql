create PROCEDURE [dbo].[sp_SAP_SalesList]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
  

  select top 10  '' CustomerCode,	'' Territory,FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	SalesDocDate, 'ZSPH'	OrderType,'2030'	Plant,	ProductCode,  CAST(ivD.Quantity as decimal(18,1))	Quantity ,'PAK'	UoM	,CAST(ivD.UnitPrice as decimal(18,2)) UnitPrice,CAST(ivD.UnitVatAmount as decimal(18,0))  	VAT, CAST(ivD.DiscountAmount as decimal(18,0))	DiscountAmount,''	FOCFlag
 from tblInvoice  iv
 inner join tblInvoiceDetail ivD on iv.InvoiceId=ivD.InvoiceId



END
 

