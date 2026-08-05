CREATE PROCEDURE [dbo].[sp_BeforesndSalesReturnList]
	-- Add the parameters for the stored procedure here
	@param nvarchar(max)
AS
BEGIN
   
    DECLARE @Q NVARCHAR(MAX)=' SELECT  isnull(IsAdjustInvoice,0) IsAdjustInvoice,  tblD.ManufacId TpGrandTotal, case when   (CONVERT(date,tblInvoice.InvoiceDate))>=   (CONVERT(date,''30-June-2022'')) then ''True'' else ''False'' end chkStatus ,tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder With (nolock)
            
            inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            --  inner JOIN dbo. tblCustMaster  V   With (nolock)  ON dbo.tblOrder.CustomerMasterId = V.CustomerMasterId
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                       inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId  
					     INNER JOIN (SELECT DISTINCT D.InvoiceId, case when IV.PaymentInvoiceStatus=''Partial'' then sum(D.PaymentNetAmount) else  sum(NetAmount) end ManufacId FROM tblInvoiceDetail D  with (nolock)
                     inner JOIN dbo.tblInvoice  IV With (nolock) ON D.InvoiceId=IV.InvoiceId 
                    group by  D.InvoiceId,IV.PaymentInvoiceStatus   ) as tblD ON tblInvoice.InvoiceId = tblD.InvoiceId   
            WHERE  TpGrandTotal>0 ' + @param  

	EXEC sp_executesql @Q

END
         