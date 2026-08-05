
create PROCEDURE [dbo].[sp_LoadOrderListForOrderRouteDayWiseN] 

	 
	@comunitId int,
	@routeId int,
	@RouteDate date
AS
BEGIN
    SET NOCOUNT ON;
 SET NOCOUNT ON;
SELECT tblOrder.PaymentType, tblOrder.DistributionRouteId, tblOrder.DistributionRoute_Ord,   CASE
            WHEN ISNULL(ValidationInfo.MaxDueDays,0) >  30
            THEN 1
            ELSE 0 end  DueAlert , tblOrder.CustomerMasterId, tblOrder.Remarks, tblOrder.ComunitId, tblOrder.ManufacId, tblOrder.OrderId, tblOrder.OrderCode, tblOrder.SubmissionDate, isnull(ValidationInfo.ReceivableTotalAmnt,0) DueAmount, tblCustomerType.CustomerType,tblMarket.MarketName,tblOrder.TerritoryName_Ord TerritoryName, tblOrder.CustomerMasterId, tblOrder.CustomerCode, tblOrder.CustomerName,tblOrder.GrossValue, tblOrder.CustomerType,tblOrder.DeliveryDate, tblOrder.DistributionRoute_Ord,tblOrder.TerritoryId ,   ISNULL(ValidationInfo.OutstandingInvoiceCount,0) AS OutstandingInvoiceCount,
        ISNULL(ValidationInfo.MaxDueDays,0) AS MaxDueDays,

         CASE
            WHEN NB.CustomerId IS NOT NULL THEN 0
            WHEN ISNULL(ValidationInfo.OutstandingInvoiceCount,0) >= 2
            THEN 1
            ELSE 0
        END AS IsMaxOutstandingExceeded,

        CASE
            WHEN NB.CustomerId IS NOT NULL THEN 0
            WHEN ISNULL(ValidationInfo.MaxDueDays,0) > 45
            THEN 1
            ELSE 0
        END AS IsCreditPeriodExceeded  FROM dbo.tblOrder  With (NOLOCK) 
          -- inner JOIN tblcustmaster V  With (NOLOCK)  ON dbo.tblOrder.CustomerMasterId = V.CustomerMasterId
           -- inner JOIN dbo.tblCompanyUnit  With (NOLOCK)  ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket  With (NOLOCK)  ON tblOrder.MarketId = dbo.tblMarket.MarketId
            inner JOIN tblCustomerType  With (NOLOCK)  ON tblOrder.CustTypeId = dbo.tblCustomerType.CustomerTypeId 
			left join (select I.CustomerMasterId,  sum(ISNULL(ISNULL(TD.TotalDelivery,0) -  ISNULL(P.PP,0),0)) ReceivableTotalAmnt 
 
FROM dbo.tblInvoice I WITH(nolock) 
inner JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON I.InvoiceId = TD.InvoiceId 

LEFT JOIN (SELECT InvoiceId,SUM(isnull(TPAmount,0)+isnull(VATAmount,0)) AS PP FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON I.InvoiceId = P.InvoiceId 
where   ISNULL(ISNULL(TD.TotalDelivery,0) -  ISNULL(P.PP,0),0)>10 and ISNULL(TD.TotalDelivery,0) <>  ISNULL(P.PP,0)
group by I.CustomerMasterId)tblDue on  tblDue.CustomerMasterId=tblOrder.CustomerMasterId

--OUTER APPLY (
--    SELECT TOP 1 
        
--        DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) AS DaysSinceUpdate
--    FROM tblInvoice WITH (NOLOCK)
--    WHERE tblInvoice.CustomerMasterId = tblOrder.CustomerMasterId
--      AND tblInvoice.DelivaryInvoiceNo IS NOT NULL
--      AND (tblInvoice.PaymentStatus IS NULL OR tblInvoice.PaymentStatus = 'Partial')
--      AND DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) >= 30
--      AND tblInvoice.DeliveryTpGrandTotal > 0
--      AND tblInvoice.PaymentInvoiceStatus <> 'Reject'
--    ORDER BY DATEDIFF(DAY, tblInvoice.UpdateDate, GETDATE()) DESC
--) InvoiceInfo



LEFT JOIN dbo.tblInvoiceNotBinding NB WITH (NOLOCK)
    ON NB.CustomerId = tblOrder.CustomerMasterId
    AND CONVERT(date, GETDATE()) BETWEEN NB.ActiveFromDate AND ISNULL(NB.ActiveToDate, CONVERT(date, GETDATE()))


  -- ★★★ নতুন যোগ করা ValidationInfo (Business Rule 1 & 2 এর জন্য) ★★★
 LEFT JOIN (
    SELECT 
        I.CustomerMasterId,
        COUNT(*) AS OutstandingInvoiceCount,
        MAX(DATEDIFF(DAY, DATEADD(day,-1, CONVERT(date, I.InvoiceDate)), CONVERT(date, GETDATE()))) AS MaxDueDays,
        SUM(
            ISNULL(
                CASE WHEN I.SndReturnInvoiceNo IS NOT NULL 
                     THEN ISNULL(sndRTN.sndReturnNetAmount,0) 
                     ELSE ISNULL(TD.TotalDelivery,0) 
                END - ISNULL(P.PP,0)
            ,0)
        ) AS ReceivableTotalAmnt
    FROM dbo.tblInvoice I WITH(NOLOCK)
    INNER JOIN (
        SELECT InvoiceId, SUM(PaymentNetAmount) AS TotalDelivery 
        FROM tblInvoiceDetail WITH(NOLOCK) 
        GROUP BY InvoiceId
    ) TD ON I.InvoiceId = TD.InvoiceId
    LEFT JOIN (
        SELECT InvoiceId, SUM(sndReturnNetAmount) AS sndReturnNetAmount 
        FROM tblInvoiceDetailReturn 
        GROUP BY InvoiceId
    ) sndRTN ON I.InvoiceId = sndRTN.InvoiceId
    LEFT JOIN (
        SELECT InvoiceId, SUM(ISNULL(TPAmount,0)+ISNULL(VATAmount,0)) AS PP 
        FROM tblCustPayDetail 
        GROUP BY InvoiceId
    ) P ON I.InvoiceId = P.InvoiceId
    WHERE 
        ISNULL(
            CASE WHEN I.SndReturnInvoiceNo IS NOT NULL 
                 THEN ISNULL(sndRTN.sndReturnNetAmount,0) 
                 ELSE ISNULL(TD.TotalDelivery,0) 
            END - ISNULL(P.PP,0)
        ,0) > 5
        AND 
        ISNULL(
            CASE WHEN I.SndReturnInvoiceNo IS NOT NULL 
                 THEN ISNULL(sndRTN.sndReturnNetAmount,0) 
                 ELSE ISNULL(TD.TotalDelivery,0) 
            END
        ,0) <> ISNULL(P.PP,0)
        AND I.PaymentInvoiceStatus <> 'Reject'
    GROUP BY I.CustomerMasterId
) ValidationInfo ON ValidationInfo.CustomerMasterId = tblOrder.CustomerMasterId

            WHERE IsInvoice = 0 and OrderType='Regular' and   tblOrder.ComUnitId=@comunitId AND tblOrder.DistributionRouteId=@routeId and   IsInvoice =0  and  IsPrepareforInvoice=1  and  tblOrder.ActionStatus='2' and  tblOrder.IsSubDepo =0

			end