-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerLedger] 
@Cust nvarchar(max),
	@fromdate datetime = NULL,  -- Default to NULL if not provided
@todate datetime = NULL 
AS
BEGIN

	SELECT 
           M.CustomerCode,M.CustomerName,I.OrderNo, tblCustomerType.CustomerType as OrderDate,I.InvoiceNo,I.InvoiceDate,O.ComUnitCode,O.ComUnitName,tblMarket.MarketCode,tblMarket.MarketName,
		   I.TpGrandTotal,D.DeliveryTpGrandTotal,I.DelivaryInvoiceNo,I.UpdateDate,I.PaymentAmount,I.PaymentStatus,O.CampaignName as DistrictCode
            FROM dbo.tblInvoice I
			
			left JOIN (Select sum(DeliveryNetAmount)DeliveryTpGrandTotal,InvoiceId from dbo.tblInvoiceDetail 
			                  where (DeliveryStatus in ('Full','Partial')) group by InvoiceId) D ON I.InvoiceId = D.InvoiceId

            INNER JOIN dbo.tblCustMaster M ON I.CustomerMasterId = M.CustomerMasterId
            INNER JOIN tblOrder O ON O.OrderId = I.OrderId
			INNER JOIN dbo.tblMarket ON O.MarketId=dbo.tblMarket.MarketId
			inner join tblCustomerType on tblCustomerType.CustomerTypeId=O.CustTypeId
             WHERE M.CustomerCode= @Cust      AND (
        (@fromdate IS NULL AND @todate IS NULL) OR 
        (I.InvoiceDate BETWEEN @fromdate AND @todate)
    )

    --order by InvoiceDate asc

	union all



	
	SELECT 
           M.CustomerCode,M.CustomerName,I.OrderNo,I.CustomerType as OrderDate,I.InvoiceNo,I.InvoiceDate,M.ComUnitCode,M.ComUnitName,M.MarketCode,M.MarketName,
		   I.TpGrandTotal,D.DeliveryTpGrandTotal,I.DelivaryInvoiceNo,I.UpdateDate,I.PaymentAmount,I.PaymentStatus,O.CampaignName as DistrictCode
            FROM SalesDisDB_SMC..tblInvoice I
			--INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
			INNER JOIN (Select sum(DeliveryNetAmount)DeliveryTpGrandTotal,InvoiceId from SalesDisDB_SMC..tblInvoiceDetail 
			                  where (DeliveryStatus in ('Full','Partial')) group by InvoiceId) D ON I.InvoiceId = D.InvoiceId

            INNER JOIN SalesDisDB_SMC..View_CustomerMaster M ON I.CustomerMasterId = M.CustomerMasterId
            INNER JOIN SalesDisDB_SMC..tblOrder O ON O.OrderId = I.OrderId
             WHERE M.CustomerCode= SUBSTRING(@Cust, 2, 100)    AND (
        (@fromdate IS NULL AND @todate IS NULL) OR 
        (I.InvoiceDate BETWEEN @fromdate AND @todate)
    )

			-- union all

			-- SELECT 
   --         M.CustomerCode,M.CustomerName,I.OrderNo,I.CustomerType as OrderDate,I.InvoiceNo,I.InvoiceDate,M.ComUnitCode,M.ComUnitName,M.MarketCode,M.MarketName,
			--I.TpGrandTotal,D.DeliveryTpGrandTotal,I.DelivaryInvoiceNo,I.UpdateDate,I.PaymentAmount,I.PaymentStatus,O.CampaignName as DistrictCode
   --         FROM SalesDisDB_SMC..tblSubInvoiceMaster I

			--INNER JOIN (Select sum(DeliveryNetAmount)DeliveryTpGrandTotal,InvoiceId from dbo.tblSubInvoiceDetail 
			--                  where (DeliveryStatus in ('Full','Partial')) group by InvoiceId) D ON I.InvoiceId = D.InvoiceId



			----INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
   --         INNER JOIN dbo.View_CustomerMaster M ON I.CustomerMasterId = M.CustomerMasterId
   --         INNER JOIN tblOrder O ON O.OrderId = I.OrderId
   --          WHERE M.CustomerCode= @Cust  and I.InvoiceDate between @fromdate and @todate order by InvoiceDate asc
	
END
