
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_IntransitReportList_BI]

AS
BEGIN
   DECLARE @FromDate DATE = '2021-07-01';
DECLARE @ToDate   DATE = '2030-06-30';

DECLARE @Q NVARCHAR(MAX) = '
SELECT 
    cus.CellNo, 
    mas.ComUnitCode                         AS ComUnitCode, 
    MIO.EmpMasterCode                       AS MainMIOCODE, 
    MIO.EmpName                             AS MainMIONAME, 
    typ.CustomerType                        AS CustomerType, 
    tblarea.AreaCode                        AS AMCode,
    tblarea.AreaName                        AS AreaName,        -- ✅ NEW
    tblregion.RegionCode                    AS DZSMCode,
    tblregion.RegionName                    AS ZoneName,        -- ✅ NEW
    tblDetails.TotalPriceVatAmount          AS TradeDiscount,
    tblTerritory.TerritoryCode              AS Territory, 
    ''' + CONVERT(VARCHAR(10), @FromDate, 103) + '''            AS fromdate, 
    ''' + CONVERT(VARCHAR(10), @ToDate,   103) + '''            AS todate,
    tblDetails.DeliveryNetAmount            AS DeliveryNetAmount,
    CU.ComUnitName,
    C.CustomerCode,
    C.CustomerName,
    I.OrderNo,
    CONVERT(VARCHAR, I.OrderDate,   103)    AS OrderDate,
    I.InvoiceNo,
    CONVERT(VARCHAR, I.InvoiceDate, 103)    AS InvoiceDate,
    tblDetails.NetAmount                    AS NetAmount,
    tblDetails.UnitVatAmount                AS TotalPriceVatAmount,
    tblDetails.TotalPriceVatAmount          AS DiscountAmount,
    I.AreaCode,
    I.RegionCode                            AS MiaCode,
    I.DisCode                               AS DistrictCode,
    mas.MarketCode_Ord                      AS MarketCode,
    mas.MarketName_Ord                      AS MarketName,
    DATEDIFF(DAY, DATEADD(DAY, -1, InvoiceDate), GETDATE()) AS IntransitDay,
    MIO.EmpMasterCode                       AS MainMIOCODE,
    MIO.EmpName                             AS MainMIONAME,
    I.CustomerType                          AS SpecialAmount

FROM dbo.tblInvoice I WITH (NOLOCK)

INNER JOIN (
    SELECT 
        InvoiceId, 
        SUM(NetAmount)                                                                AS NetAmount, 
        ((SUM(DeliveryTotalPrice) + SUM(DeliveryTotalPriceVatAmount)) 
            - SUM(DeliveryDiscountAmount))                                            AS DeliveryNetAmount,
        SUM(TotalPriceVatAmount)                                                      AS UnitVatAmount,
        SUM(DiscountAmount)                                                           AS TotalPriceVatAmount 
    FROM dbo.tblInvoiceDetail 
    GROUP BY InvoiceId
) tblDetails ON I.InvoiceId = tblDetails.InvoiceId

INNER JOIN dbo.tblCompanyUnit  CU  ON CU.ComUnitId       = I.ComUnitId
INNER JOIN tblCustMaster       C   ON C.CustomerMasterId  = I.CustomerMasterId
INNER JOIN tblOrder            mas ON mas.OrderId         = I.OrderId
INNER JOIN tblCustMaster       cus ON mas.CustomerMasterId= cus.CustomerMasterId

LEFT JOIN tblCustomerType         typ  ON typ.CustomerTypeId = mas.CustTypeId
LEFT JOIN dbo.tblEmpGeneralInfo   DZSM WITH (NOLOCK) ON mas.RSMId  = DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo   AM   WITH (NOLOCK) ON mas.ASMId  = AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo   MIO  WITH (NOLOCK) ON mas.MIOId  = MIO.EmpInfoId

LEFT JOIN tblMarket        WITH (NOLOCK) ON tblMarket.MarketId            = cus.MarketId
LEFT JOIN tblSubTerritory  WITH (NOLOCK) ON tblSubTerritory.SubTerritoryId= tblMarket.SubTerritoryId
LEFT JOIN tblTerritory     WITH (NOLOCK) ON tblTerritory.TerritoryId      = tblSubTerritory.TerritoryId
LEFT JOIN tblarea          WITH (NOLOCK) ON tblarea.AreaId                = tblTerritory.AreaId
LEFT JOIN tblregion        WITH (NOLOCK) ON tblregion.RegionId            = tblarea.RegionId

WHERE 
    I.TpTotal > 0 
    AND I.DelivaryInvoiceNo IS NULL
    AND I.InvoiceDate >= ''' + CONVERT(VARCHAR(10), @FromDate, 112) + '''
    AND I.InvoiceDate <  DATEADD(DAY, 1, ''' + CONVERT(VARCHAR(10), @ToDate, 112) + ''')

UNION ALL

SELECT 
    ''''                                    AS CellNo, 
    CU.ComUnitCode,
    I.MIACode                               AS MainMIOCODE,
    I.MIAName                               AS MainMIONAME,
    I.CustomerType                          AS CustomerType,
    I.DisCode                               AS AMCode,
    ''''                                    AS AreaName,        -- ✅ NEW (SMC DB তে নেই তাই blank)
    I.RegionCode                            AS DZSMCode,
    ''''                                    AS ZoneName,        -- ✅ NEW (SMC DB তে নেই তাই blank)
    tblDetails.TotalPriceVatAmount          AS TradeDiscount,
    I.AreaCode                              AS Territory,
    ''' + CONVERT(VARCHAR(10), @FromDate, 103) + '''            AS fromdate,
    ''' + CONVERT(VARCHAR(10), @ToDate,   103) + '''            AS todate,
    tblDetails.NetAmount                    AS DeliveryNetAmount,
    CU.ComUnitName,
    C.CustomerCode,
    C.CustomerName,
    I.OrderNo,
    CONVERT(VARCHAR, I.OrderDate,   103)    AS OrderDate,
    I.InvoiceNo,
    CONVERT(VARCHAR, I.InvoiceDate, 103)    AS InvoiceDate,
    tblDetails.NetAmount                    AS NetAmount,
    tblDetails.UnitVatAmount                AS TotalPriceVatAmount,
    tblDetails.TotalPriceVatAmount          AS DiscountAmount,
    I.AreaCode,
    I.RegionCode                            AS MiaCode,
    I.DisCode                               AS DistrictCode,
    I.MarketCode,
    I.MarketName,
    DATEDIFF(DAY, DATEADD(DAY, -1, InvoiceDate), GETDATE()) AS IntransitDay,
    I.MIACode                               AS MainMIOCODE,
    I.MIAName                               AS MainMIONAME,
    I.CustomerType                          AS SpecialAmount

FROM SalesDisDB_SMC..tblInvoice I WITH (NOLOCK)

INNER JOIN (
    SELECT 
        InvoiceId,
        ((SUM(TotalPrice) + SUM(TotalPriceVatAmount)) - SUM(DiscountAmount)) AS NetAmount,
        SUM(TotalPriceVatAmount)                                              AS UnitVatAmount,
        SUM(DiscountAmount)                                                   AS TotalPriceVatAmount 
    FROM SalesDisDB_SMC..tblInvoiceDetail 
    GROUP BY InvoiceId
) tblDetails ON I.InvoiceId = tblDetails.InvoiceId

INNER JOIN SalesDisDB_SMC..tblCompanyUnit      CU ON CU.ComUnitId       = I.ComUnitId
INNER JOIN SalesDisDB_SMC..View_CustomerMaster C  ON C.CustomerMasterId = I.CustomerMasterId

WHERE 
    I.TpTotal > 0 
    AND I.DelivaryInvoiceNo IS NULL
    AND I.InvoiceDate >= ''' + CONVERT(VARCHAR(10), @FromDate, 112) + '''
    AND I.InvoiceDate <  DATEADD(DAY, 1, ''' + CONVERT(VARCHAR(10), @ToDate, 112) + ''')
'

EXEC sp_executesql @Q
END





  
            



