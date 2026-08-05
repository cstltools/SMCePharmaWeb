
CREATE PROCEDURE [dbo].[sp_LoadingSummary_da]
	-- Add the parameters for the stored procedure here
	@param nvarchar(max)
AS
BEGIN
   --Partial Off
    DECLARE @Q NVARCHAR(MAX)='select  salLog.SalesConfirmationAppLogId,  case when  tblInvoice.DA_SalesConfirmStatus=''Pending'' then ''Full Confirm'' else  tblInvoice.DA_SalesConfirmStatus end DA_SalesConfirmStatus,  format(tblInvoice.DA_SalesConfirmDate,''dd-MMM-yyyy hh:mm tt'')  DA_SalesConfirmDate, tblInvoice.DA_SalesConfirmBy ,tblOrder.ComUnitId,tblOrder.ManufacId,tblOrder.OrderId,tblInvoice.InvoiceId,tblOrder.MarketId,tblOrder.CustomerMasterId, tblInvoice.InvoiceNo,tblInvoice.InvoiceId, tblInvoice.InvoiceDate, tblOrder.CustomerCode, tblOrder.CustomerName, tblOrder.OrderSenderName,
    CASE 
        WHEN MONTH(InvoiceDate) = MONTH(GETDATE()) AND YEAR(InvoiceDate) = YEAR(GETDATE()) THEN ''Partial Show''
        ELSE ''Partial Offs''
    END AS   IsPartialCheck, isnull(IsAdjustInvoice,0) IsAdjustInvoice,  tblOrder.OrderSenderCode+'' : ''+tblOrder.OrderSenderName OrderSenderName,  tblD.ManufacId TpGrandTotal, case when   (CONVERT(date,tblInvoice.InvoiceDate))>=   (CONVERT(date,''30-June-2022'')) then ''True'' else ''False'' end chkStatus ,tblInvoice.CustomerMasterId,tblOrder.MarketId, tblOrder.MarketName_Ord MarketName, TpGrandTotal  FROM dbo.tblOrder With (nolock)
             inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
             left JOIN dbo.tblSalesConfirmation_appLog salLog  With (nolock) ON salLog.InvoiceId=dbo.tblInvoice.InvoiceId  and isnull(salLog.DICApprovalStatus,'''')=''Pending''
              inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                     --  inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId  
					     INNER JOIN (SELECT DISTINCT D.InvoiceId, sum(NetAmount)ManufacId FROM tblInvoiceDetail D  with (nolock)
                    
                    group by  D.InvoiceId   ) as tblD ON tblInvoice.InvoiceId = tblD.InvoiceId   
            WHERE  TpGrandTotal>0 and salLog.SalesConfirmationAppLogId  is not null  ' + @param  

	EXEC sp_executesql @Q

END
              