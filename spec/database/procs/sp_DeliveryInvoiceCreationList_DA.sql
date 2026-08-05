
CREATE   PROCEDURE [dbo].[sp_DeliveryInvoiceCreationList_DA]
	-- Add the parameters for the stored procedure here
	@param nvarchar(max)
AS
BEGIN

UPDATE tblSalesReturn_appLogDetail
SET ReasonCode = 3,
    ReasonLabel = 'Wrong Order'
WHERE (ReasonCode IS NULL 
OR ReasonLabel IS NULL) and ReturnStatus<> 'Full';
   
    DECLARE @Q NVARCHAR(MAX)='SELECT  salLog.SalesReturnAppLogId,  salLog.ReturnType DA_SalesReturnType, isnull(IsAdjustInvoice,0) IsAdjustInvoice,  tblD.ManufacId TpGrandTotal, case when   (CONVERT(date,tblInvoice.InvoiceDate))>=   (CONVERT(date,''30-June-2022'')) then ''True'' else ''False'' end chkStatus ,tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder With (nolock)
            
            inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
              left JOIN dbo.tblSalesReturn_appLog salLog  With (nolock) ON salLog.InvoiceId=dbo.tblInvoice.InvoiceId  and isnull(salLog.DICApprovalStatus,'''')=''Pending''


              inner JOIN dbo. tblCustMaster  V   With (nolock)  ON dbo.tblOrder.CustomerMasterId = V.CustomerMasterId
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                       inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId  
					     INNER JOIN (SELECT DISTINCT D.InvoiceId, case when IV.DeliveryInvoiceStatus=''Partial'' then sum(D.DeliveryNetAmount) else  sum(NetAmount) end ManufacId FROM tblInvoiceDetail D  with (nolock)
                     inner JOIN dbo.tblInvoice  IV With (nolock) ON D.InvoiceId=IV.InvoiceId 
                    group by  D.InvoiceId,IV.DeliveryInvoiceStatus   ) as tblD ON tblInvoice.InvoiceId = tblD.InvoiceId   
            WHERE  TpGrandTotal>0  and tblInvoice.DelivaryInvoiceNo is not null and salLog.SalesReturnAppLogId  is not null   ' + @param  

	EXEC sp_executesql @Q

END
              
