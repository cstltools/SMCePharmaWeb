
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_Get_TransitVSCollection_BI]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2021-07-01';
    DECLARE @ToDate   DATE = '2030-06-30';

    DECLARE @Q NVARCHAR(MAX) = '

    SELECT 
        tblregion.RegionCode                            AS ZoneCode,
        tblregion.RegionName                            AS ZoneName,
        tblarea.AreaCode                                AS AreaCode,
        tblarea.AreaName                                AS AreaName,

        -- ✅ Due vs Collection
        SUM(ISNULL(tblDetails.NetAmount, 0))            AS TotalInvoiceAmount,
        SUM(ISNULL(pay.TotalPaid, 0))                   AS TotalCollection,
        SUM(ISNULL(tblDetails.NetAmount, 0)) 
            - SUM(ISNULL(pay.TotalPaid, 0))             AS TotalDue

    FROM dbo.tblInvoice I WITH (NOLOCK)

    INNER JOIN (
        SELECT 
            InvoiceId,
            SUM(ISNULL(NetAmount, 0))                   AS NetAmount
        FROM dbo.tblInvoiceDetail
        GROUP BY InvoiceId
    ) tblDetails ON I.InvoiceId = tblDetails.InvoiceId

    -- ✅ Payment table join
    LEFT JOIN (
        SELECT
            InvoiceId,
            SUM(ISNULL(PaymentAmount, 0))               AS TotalPaid
        FROM dbo.tblCustPayDetail
        GROUP BY InvoiceId
    ) pay ON pay.InvoiceId = I.InvoiceId

    INNER JOIN tblOrder            mas ON mas.OrderId          = I.OrderId
    INNER JOIN tblCustMaster       cus ON mas.CustomerMasterId = cus.CustomerMasterId

    LEFT JOIN tblMarket        WITH (NOLOCK) ON tblMarket.MarketId             = cus.MarketId
    LEFT JOIN tblSubTerritory  WITH (NOLOCK) ON tblSubTerritory.SubTerritoryId = tblMarket.SubTerritoryId
    LEFT JOIN tblTerritory     WITH (NOLOCK) ON tblTerritory.TerritoryId       = tblSubTerritory.TerritoryId
    LEFT JOIN tblarea          WITH (NOLOCK) ON tblarea.AreaId                 = tblTerritory.AreaId
    LEFT JOIN tblregion        WITH (NOLOCK) ON tblregion.RegionId             = tblarea.RegionId

    WHERE 
        I.TpTotal > 0
        AND I.InvoiceDate >= ''' + CONVERT(VARCHAR(10), @FromDate, 112) + '''
        AND I.InvoiceDate <  DATEADD(DAY, 1, ''' + CONVERT(VARCHAR(10), @ToDate, 112) + ''')

    GROUP BY
        tblregion.RegionCode,
        tblregion.RegionName,
        tblarea.AreaCode,
        tblarea.AreaName

    ORDER BY
        tblregion.RegionName,
        tblarea.AreaName

    '

    EXEC sp_executesql @Q


END





  
            



