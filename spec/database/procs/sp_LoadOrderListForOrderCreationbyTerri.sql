CREATE PROCEDURE [dbo].[sp_LoadOrderListForOrderCreationbyTerri] 

	@manufacId int,
	@comunitId int,
	@TerritoryId int
AS
BEGIN
    SET NOCOUNT ON;

SELECT 
    tblOrder.PaymentType, 
    tblOrder.DistributionRouteId, 
    tblOrder.DistributionRouteId,   
    CASE
        WHEN ISNULL(ValidationInfo.MaxDueDays,0) > 30
        THEN 1
        ELSE 0 
    END DueAlert, 
    tblOrder.CustomerMasterId, 
    tblOrder.Remarks, 
    tblOrder.ComunitId, 
    tblOrder.ManufacId, 
    tblOrder.OrderId, 
    tblOrder.OrderCode, 
    tblOrder.SubmissionDate, 
    ISNULL(ValidationInfo.ReceivableTotalAmnt,0) DueAmount, 
    tblCustomerType.CustomerType,
    tblMarket.MarketName,
    tblOrder.TerritoryName_Ord TerritoryName, 
    tblOrder.CustomerMasterId, 
    tblOrder.CustomerCode, 
    tblOrder.CustomerName,
    tblOrder.GrossValue, 
    tblOrder.CustomerType,
    tblOrder.DeliveryDate, 
    tblOrder.DistributionRoute_Ord,
    tblOrder.TerritoryId,   
    ISNULL(ValidationInfo.OutstandingInvoiceCount,0) AS OutstandingInvoiceCount,
    ISNULL(ValidationInfo.MaxDueDays,0) AS MaxDueDays,

    CASE
        WHEN ISNULL(ValidationInfo.OutstandingInvoiceCount,0) >= ISNULL(NB.AllowedNoOfInvoice, 2)
        THEN 1
        ELSE 0
    END AS IsMaxOutstandingExceeded,

     CASE
        WHEN ISNULL(ValidationInfo.MaxDueDays,0) > ISNULL(NB.NumberOfDaysInTransit, 45)
             OR ISNULL(tblOrder.GrossValue,0) > ISNULL(NB.AllowedCreditLimit, 50000)
        THEN 1
        ELSE 0
    END AS IsCreditPeriodExceeded

FROM dbo.tblOrder WITH (NOLOCK) 

    INNER JOIN dbo.tblMarket WITH (NOLOCK) 
        ON tblOrder.MarketId = dbo.tblMarket.MarketId

    INNER JOIN tblCustomerType WITH (NOLOCK) 
        ON tblOrder.CustTypeId = dbo.tblCustomerType.CustomerTypeId 

    LEFT JOIN (
        SELECT 
            I.CustomerMasterId,  
            SUM(ISNULL(ISNULL(TD.TotalDelivery,0) - ISNULL(P.PP,0),0)) ReceivableTotalAmnt 
        FROM dbo.tblInvoice I WITH(NOLOCK) 
        INNER JOIN (
            SELECT InvoiceId, SUM(PaymentNetAmount) AS TotalDelivery 
            FROM tblInvoiceDetail AS IVD WITH(NOLOCK) 
            GROUP BY InvoiceId
        ) AS TD ON I.InvoiceId = TD.InvoiceId 
        LEFT JOIN (
            SELECT InvoiceId, SUM(ISNULL(TPAmount,0)+ISNULL(VATAmount,0)) AS PP 
            FROM tblCustPayDetail 
            GROUP BY InvoiceId
        ) AS P ON I.InvoiceId = P.InvoiceId 
        WHERE ISNULL(ISNULL(TD.TotalDelivery,0) - ISNULL(P.PP,0),0) > 10 
          AND ISNULL(TD.TotalDelivery,0) <> ISNULL(P.PP,0)
        GROUP BY I.CustomerMasterId
    ) tblDue ON tblDue.CustomerMasterId = tblOrder.CustomerMasterId

    -- ★★★ NB: Customer-level rule কে CustomerType-level এর চেয়ে priority (TOP 1) ★★★
    OUTER APPLY (
        SELECT TOP 1 
            NB1.CustomerId,
            NB1.CustomerTypeId,
            NB1.AllowedNoOfInvoice,
            NB1.AllowedCreditLimit,
            NB1.NumberOfDaysInTransit
        FROM dbo.tblInvoiceNotBinding NB1 WITH (NOLOCK)
        WHERE 
            (
                (NB1.ApplyType = 'Customer' AND NB1.CustomerId = tblOrder.CustomerMasterId)
                OR 
                (NB1.ApplyType = 'CustomerType' AND NB1.CustomerTypeId = tblOrder.CustTypeId)
            )
            AND NB1.IsActive = 1
            AND CONVERT(date, GETDATE()) BETWEEN NB1.ActiveFromDate AND ISNULL(NB1.ActiveToDate, CONVERT(date, GETDATE()))
        ORDER BY 
            CASE WHEN NB1.ApplyType = 'Customer' THEN 0 ELSE 1 END ASC
    ) NB

    -- ★★★ ValidationInfo (Business Rule 1 & 2 এর জন্য) ★★★
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

WHERE 
    IsInvoice = 0 
    AND OrderType = 'Regular' 
    AND tblOrder.ComUnitId = @comunitId 
    AND tblOrder.DistributionRouteId = @manufacId 
    AND tblOrder.TerritoryId = @TerritoryId  
    AND IsInvoice = 0  
    AND IsPrepareforInvoice = 1  
    AND tblOrder.ActionStatus = '2' 
    AND tblOrder.IsSubDepo = 0

END