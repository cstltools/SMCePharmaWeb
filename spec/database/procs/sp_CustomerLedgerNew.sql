-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerLedgerNew] 
@Cust nvarchar(max),
	@fromdate datetime = NULL,  -- Default to NULL if not provided
@todate datetime = NULL 
AS
BEGIN

	SELECT tblCustomerType.CustomerType + isnull( case when IsAdjustInvoice=1 then CHAR(13) + CHAR(10) 
             +  ' [Remarks: expiry adjustment amount ('+ CONVERT( nvarchar(max),AdjustAmount)+')]' else   '' end  ,'') as CustomerType, isnull(DeliveryNetAmount,0)  DeliveryNetAmount,   isnull(DeliveryNetTP,0)   DeliveryNetTP, isnull(PaymentTPAmount,0) PaymentTP, isnull(PaymentNetAmount,0)  PaymentNet, isnull(tblInv.InvNetAmount,0) InvNetAmount, isnull(tblInv.InvNetTP,0) InvNetTP,   isnull(sndRTN.sndReturnNetAmount,0) + isnull(RtnNetAmount,0)    RtnNetAmount,   isnull(sndRTN.sndReturnTotalPrice,0) + isnull(RtnNetTP,0)    RtnNetTP,
           M.CustomerCode,M.CustomerName,I.OrderNo, tblCustomerType.CustomerType as OrderDate,I.InvoiceNo,format(I.InvoiceDate,'dd-MMM-yyyy') InvoiceDate,O.ComUnitCode,O.ComUnitName,tblMarket.MarketCode,tblMarket.MarketName,
		   I.TpGrandTotal, I.DelivaryInvoiceNo,I.UpdateDate,I.PaymentAmount,I.PaymentStatus, case when IsAdjustInvoice=1 then 'Expire Adjustment Amount('+ CONVERT( nvarchar(max),AdjustAmount)+')' else   '' end AdjustAmountRemarks, O.CampaignName  + isnull(' [Remarks'+case when IsAdjustInvoice=1 then 'Expire Adjustment Amount('+ CONVERT( nvarchar(max),AdjustAmount)+')' else   '' end +']','') as DistrictCode
            FROM dbo.tblInvoice I with(nolock) 
			
			left JOIN (Select sum(ID.DeliveryNetAmount)DeliveryNetAmount, sum(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount)  DeliveryNetTP, ID.InvoiceId from dbo.tblInvoiceDetail ID
			                  where (DeliveryStatus in ('Full','Partial'))     group by InvoiceId) D ON I.InvoiceId = D.InvoiceId
							  left join (select ID.InvoiceId, sum(ID.NetAmount) InvNetAmount,  sum(ID.TotalPrice-ID.DiscountAmount) InvNetTP from dbo.tblInvoiceDetail ID  with(nolock)   group by   ID.InvoiceId)tblInv on tblInv.InvoiceId=I.InvoiceId



							  	  left join (select custDtl.InvoiceId, sum((isnull(custDtl.TPAmount,0))) PaymentTPAmount ,sum((isnull(custDtl.TPAmount,0))) +
sum((isnull(custDtl.VATAmount,0)))   PaymentNetAmount  from tblCustPayDetail custDtl  with(nolock)   group by   custDtl.InvoiceId)tblPyt on tblPyt.InvoiceId=I.InvoiceId

	  left join (select ID.InvoiceId, (sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0)) + sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)) RtnNetAmount,    sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))- sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))   RtnNetTP from dbo.tblInvoiceDetail ID  with(nolock) 
	  inner join tblInvoice IVMas with(nolock) on IVMas.InvoiceId=ID.InvoiceId where    IVMas.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0)
	  group by   ID.InvoiceId)tblRtn on tblRtn.InvoiceId=I.InvoiceId

	  LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn where PreviousQuantity<>sndReturnQuantity  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId 



            INNER JOIN dbo.tblCustMaster M ON I.CustomerMasterId = M.CustomerMasterId
            INNER JOIN tblOrder O ON O.OrderId = I.OrderId
			INNER JOIN dbo.tblMarket ON O.MarketId=dbo.tblMarket.MarketId
			inner join tblCustomerType on tblCustomerType.CustomerTypeId=O.CustTypeId

             WHERE M.CustomerCode= @Cust      AND (
        (@fromdate IS NULL AND @todate IS NULL) OR 
        (I.InvoiceDate BETWEEN @fromdate AND @todate)
    )
	order by format(I.InvoiceDate,'dd-MMM-yyyy') asc
 --  union all

  
	
	--SELECT 
 --          M.CustomerCode,M.CustomerName,I.OrderNo,I.CustomerType as OrderDate,I.InvoiceNo,I.InvoiceDate,M.ComUnitCode,M.ComUnitName,M.MarketCode,M.MarketName,
	--	   I.TpGrandTotal,D.DeliveryTpGrandTotal,I.DelivaryInvoiceNo,I.UpdateDate,I.PaymentAmount,I.PaymentStatus,O.CampaignName as DistrictCode
 --           FROM SalesDisDB_SMC..tblInvoice I
	--		--INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
	--		INNER JOIN (Select sum(DeliveryNetAmount)DeliveryTpGrandTotal,InvoiceId from SalesDisDB_SMC..tblInvoiceDetail 
	--		                  where (DeliveryStatus in ('Full','Partial')) group by InvoiceId) D ON I.InvoiceId = D.InvoiceId

 --           INNER JOIN SalesDisDB_SMC..View_CustomerMaster M ON I.CustomerMasterId = M.CustomerMasterId
 --           INNER JOIN SalesDisDB_SMC..tblOrder O ON O.OrderId = I.OrderId
 --            WHERE M.CustomerCode= SUBSTRING(@Cust, 2, 100)    AND (
 --       (@fromdate IS NULL AND @todate IS NULL) OR 
 --       (I.InvoiceDate BETWEEN @fromdate AND @todate)
 --   )

	
END
