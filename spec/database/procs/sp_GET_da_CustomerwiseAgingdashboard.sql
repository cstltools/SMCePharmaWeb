
--------------------------------------------------
-- PROCEDURE: sp_GET_da_CustomerwiseAgingdashboard
--------------------------------------------------
CREATE   PROCEDURE [dbo].[sp_GET_da_CustomerwiseAgingdashboard]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int


AS
BEGIN

  
  -- Customer-wise Aging: 1-20d, 21-40d, 41-60d buckets
SELECT
    C.CustomerCode,
    C.CustomerName,
    MIO.EmpMasterCode AS MIOCode,
    MIO.EmpName      AS MIOName,
    AM.EmpMasterCode AS AMCode,
    AM.EmpName       AS AMName,
    DZSM.EmpMasterCode AS DSMCode,
    DZSM.EmpName       AS DSMName,
    cc.TerritoryCode,
    REPLACE(mas.MarketName_Ord, ',', ' ') AS MarketName,

    -- Receivable = NetAmount - Payment
    SUM(
        CASE WHEN DiffDay BETWEEN 1 AND 20
             THEN Receivable ELSE 0
        END
    ) AS [1-20D],

    SUM(
        CASE WHEN DiffDay BETWEEN 21 AND 40
             THEN Receivable ELSE 0
        END
    ) AS [21-40D],

    SUM(
        CASE WHEN DiffDay BETWEEN 41 AND 60
             THEN Receivable ELSE 0
        END
    ) AS [41-60D],

    SUM(Receivable) AS TotalReceivable

FROM (

    -- Inner: per-invoice receivable + aging days
    SELECT
        I.InvoiceId,
        I.CustomerMasterId,
        I.OrderId,
        I.ComUnitId,

        DATEDIFF(
            DAY,
            DATEADD(day, -1, CONVERT(date, I.InvoiceDate)),
            CONVERT(date, GETDATE())
        ) AS DiffDay,

        CASE
            WHEN I.SndReturnInvoiceNo IS NOT NULL
                THEN ISNULL(sndRTN.sndReturnNetAmount, 0)
            ELSE ISNULL(TD.TotalDelivery, 0)
        END
        - ISNULL(P.PP, 0) AS Receivable

    FROM dbo.tblInvoice I WITH (NOLOCK)

    LEFT JOIN (
        SELECT InvoiceId,
               SUM(PaymentNetAmount) AS TotalDelivery
        FROM dbo.tblInvoiceDetail WITH (NOLOCK)
        GROUP BY InvoiceId
    ) TD ON I.InvoiceId = TD.InvoiceId

    LEFT JOIN (
        SELECT InvoiceId,
               SUM(sndReturnNetAmount) AS sndReturnNetAmount
        FROM tblInvoiceDetailReturn
        GROUP BY InvoiceId
    ) sndRTN ON I.InvoiceId = sndRTN.InvoiceId

    LEFT JOIN (
        SELECT InvoiceId,
               SUM(ISNULL(TPAmount, 0) + ISNULL(VATAmount, 0)) AS PP
        FROM tblCustPayDetail
        GROUP BY InvoiceId
    ) P ON I.InvoiceId = P.InvoiceId

    WHERE
        -- শুধু unpaid/partially paid invoices
        ISNULL(
            CASE
                WHEN I.SndReturnInvoiceNo IS NOT NULL
                    THEN ISNULL(sndRTN.sndReturnNetAmount, 0)
                ELSE ISNULL(TD.TotalDelivery, 0)
            END, 0
        ) - ISNULL(P.PP, 0) > 5
        AND DATEDIFF(
                DAY,
                DATEADD(day, -1, CONVERT(date, I.InvoiceDate)),
                CONVERT(date, GETDATE())
            ) BETWEEN 1 AND 60

) base

INNER JOIN tblCustMaster C
    ON C.CustomerMasterId = base.CustomerMasterId
LEFT JOIN  tblOrder mas
    ON mas.OrderId = base.OrderId
LEFT JOIN  dbo.tblEmpGeneralInfo MIO  WITH (NOLOCK)
    ON mas.MIOId   = MIO.EmpInfoId
LEFT JOIN  dbo.tblEmpGeneralInfo AM   WITH (NOLOCK)
    ON mas.ASMId   = AM.EmpInfoId
LEFT JOIN  dbo.tblEmpGeneralInfo DZSM WITH (NOLOCK)
    ON mas.RSMId   = DZSM.EmpInfoId
LEFT JOIN  tblMarket aa               WITH (NOLOCK)
    ON aa.MarketId = C.MarketId
LEFT JOIN  tblSubTerritory bb         WITH (NOLOCK)
    ON bb.SubTerritoryId = aa.SubTerritoryId  AND bb.IsActive = 1
LEFT JOIN  tblTerritory cc            WITH (NOLOCK)
    ON cc.TerritoryId = bb.TerritoryId        AND cc.IsActive = 1

    where     mas.ComUnitId= @ComUnitId and  mas.DistributionRouteId= @RouteId 

GROUP BY
    C.CustomerCode, C.CustomerName,
    MIO.EmpMasterCode, MIO.EmpName,
    AM.EmpMasterCode,  AM.EmpName,
    DZSM.EmpMasterCode, DZSM.EmpName,
    cc.TerritoryCode,
    REPLACE(mas.MarketName_Ord, ',', ' ')

HAVING
    SUM(Receivable) > 0

ORDER BY
    MIO.EmpMasterCode ASC,
    TotalReceivable   DESC;
     

            end 

             

        
