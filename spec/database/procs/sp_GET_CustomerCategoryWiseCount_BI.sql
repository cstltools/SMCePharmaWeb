

CREATE   PROCEDURE [dbo].[sp_GET_CustomerCategoryWiseCount_BI]
AS
BEGIN
    SET NOCOUNT ON;

     DECLARE @FromDate DATE = '2021-07-01';
    DECLARE @ToDate   DATE = '2030-06-30';

    SELECT 
        CC.CustomerCategoryId,
        CC.CustomerCategory,

        /* ===== Financial Year ===== */
        CASE 
            WHEN MONTH(C.CreateDate) >= 7 
            THEN YEAR(C.CreateDate)
            ELSE YEAR(C.CreateDate) - 1
        END AS FiscalYearStart,

        CONCAT(
            CASE 
                WHEN MONTH(C.CreateDate) >= 7 
                THEN YEAR(C.CreateDate)
                ELSE YEAR(C.CreateDate) - 1
            END,
            '-',
            CASE 
                WHEN MONTH(C.CreateDate) >= 7 
                THEN YEAR(C.CreateDate) + 1
                ELSE YEAR(C.CreateDate)
            END
        ) AS FinancialYear,

        -- Zone Info
        RG.RegionId,
        RG.RegionCode,
        RG.RegionName AS ZoneName,

        -- Area Info
        AR.AreaId,
        AR.AreaCode,
        AR.AreaName,

        -- Time Info
        YEAR(C.CreateDate) AS EntryYear,
        MONTH(C.CreateDate) AS EntryMonth,
        DATENAME(MONTH, C.CreateDate) AS EntryMonthName,

        -- Customer Count
        COUNT(DISTINCT C.CustomerMasterId) AS TotalCustomerCount

    FROM dbo.tblCustMaster C WITH (NOLOCK)

    LEFT JOIN dbo.tblCustomerCategory CC WITH (NOLOCK)
        ON C.CategoryId = CC.CustomerCategoryId

    LEFT JOIN dbo.tblRegion RG WITH (NOLOCK)
        ON RG.RegionId = C.RegionId

    LEFT JOIN dbo.tblArea AR WITH (NOLOCK)
        ON AR.AreaId = C.AreaId

    WHERE 
        CAST(C.CreateDate AS DATE)
            BETWEEN @FromDate AND @ToDate

    GROUP BY 
        CC.CustomerCategoryId,
        CC.CustomerCategory,

        RG.RegionId,
        RG.RegionCode,
        RG.RegionName,

        AR.AreaId,
        AR.AreaCode,
        AR.AreaName,

        YEAR(C.CreateDate),
        MONTH(C.CreateDate),
        DATENAME(MONTH, C.CreateDate),

        CASE 
            WHEN MONTH(C.CreateDate) >= 7 
            THEN YEAR(C.CreateDate)
            ELSE YEAR(C.CreateDate) - 1
        END

    ORDER BY 
        TotalCustomerCount DESC;
END

