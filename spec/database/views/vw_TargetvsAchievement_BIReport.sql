CREATE VIEW dbo.vw_TargetvsAchievement_BIReport
AS

SELECT
    CASE 
        WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
        ELSE CAST(ISNULL(OrderValue,0) * 100.0 / TargetValue AS DECIMAL(18,2))
    END AS OrderAchiv,

    CASE 
        WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
        ELSE CAST(ISNULL(InvoiceValue,0) * 100.0 / TargetValue AS DECIMAL(18,2))
    END AS InvoiceAchiv,

    CASE 
        WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
        ELSE CAST(ISNULL(SalesValue,0) * 100.0 / TargetValue AS DECIMAL(18,2))
    END AS SalesAchiv,

    tbl.*
FROM
(
    SELECT
        ROW_NUMBER() OVER (ORDER BY rg.RegionCode, ar.AreaCode) AS SerialNo,

        rg.RegionCode,
        rg.RegionName + ' : ' + rg.RegionCode AS RegionName,

        ar.AreaCode,
        ar.AreaName + ' : ' + ar.AreaCode AS AreaName,

        tm.MonthName AS targetMonthNo,
        tm.YearValue AS targetYear,

        DATEFROMPARTS(tm.YearValue, tm.MonthName, 1) AS MonthDate,

        FORMAT(
            DATEFROMPARTS(tm.YearValue, tm.MonthName, 1),
            'MMM-yyyy'
        ) AS MonthName,

        CAST(
            FORMAT(
                DATEFROMPARTS(tm.YearValue, tm.MonthName, 1),
                'yyyyMM'
            ) AS INT
        ) AS MonthSort,

        SUM(CAST(ISNULL(tm.Value,0) AS DECIMAL(18,2))) AS TargetValue,

        ISNULL(tblOrd.TotalOrder,0) AS OrderValue,
        ISNULL(tblInv.TotalInvoice,0) AS InvoiceValue,
        ISNULL(tblSal.TotalSales,0) AS SalesValue

    FROM tblRegion rg WITH (NOLOCK)

    INNER JOIN tblTerritoryDataMigration tm WITH (NOLOCK)
        ON tm.ZoneId_tr = rg.RegionId

    INNER JOIN tblArea ar WITH (NOLOCK)
        ON ar.AreaId = tm.AreaId_tr

    LEFT JOIN
    (
        SELECT
            Ord.AreaId,
            MONTH(Ord.SubmissionDate) AS MonthName,
            YEAR(Ord.SubmissionDate) AS YearValue,
            CONVERT(
                DECIMAL(18,2),
                ISNULL(SUM(OrdD.TotalTradePrice) - SUM(OrdD.DiscountAmount), 0)
            ) AS TotalOrder
        FROM tblOrder Ord WITH (NOLOCK)

        INNER JOIN tblOrderDetail OrdD WITH (NOLOCK)
            ON Ord.OrderId = OrdD.OrderId

        WHERE Ord.ActionStatus = '2'

        GROUP BY
            Ord.AreaId,
            MONTH(Ord.SubmissionDate),
            YEAR(Ord.SubmissionDate)
    ) tblOrd
        ON tblOrd.AreaId = ar.AreaId
       AND tblOrd.MonthName = tm.MonthName
       AND tblOrd.YearValue = tm.YearValue

    LEFT JOIN
    (
        SELECT
            ord.AreaId,
            MONTH(A.InvoiceDate) AS MonthName,
            YEAR(A.InvoiceDate) AS YearValue,
            CONVERT(
                DECIMAL(18,2),
                ISNULL(
                    SUM(ID.TotalPrice - ID.DiscountAmount) 
                    - SUM(ISNULL(ID.AdjustmentAmount,0)),
                    0
                )
            ) AS TotalInvoice
        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID WITH (NOLOCK)
            ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId

        GROUP BY
            ord.AreaId,
            MONTH(A.InvoiceDate),
            YEAR(A.InvoiceDate)
    ) tblInv
        ON tblInv.AreaId = ar.AreaId
       AND tblInv.MonthName = tm.MonthName
       AND tblInv.YearValue = tm.YearValue

    LEFT JOIN
    (
        SELECT
            ord.AreaId,
            MONTH(A.UpdateDate) AS MonthName,
            YEAR(A.UpdateDate) AS YearValue,
            CONVERT(
                DECIMAL(18,0),
                ISNULL(
                    SUM(ID.TotalPrice - ID.DiscountAmount) 
                    - SUM(ISNULL(ID.AdjustmentAmount,0)),
                    0
                )
            ) AS TotalSales
        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID WITH (NOLOCK)
            ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId

        WHERE A.DeliveryInvoiceStatus IN ('Full', 'Partial')

        GROUP BY
            ord.AreaId,
            MONTH(A.UpdateDate),
            YEAR(A.UpdateDate)
    ) tblSal
        ON tblSal.AreaId = ar.AreaId
       AND tblSal.MonthName = tm.MonthName
       AND tblSal.YearValue = tm.YearValue

    WHERE tm.TerritoryId IS NOT NULL

    GROUP BY
        rg.RegionCode,
        rg.RegionName,
        ar.AreaCode,
        ar.AreaName,
        tm.MonthName,
        tm.YearValue,
        tblOrd.TotalOrder,
        tblInv.TotalInvoice,
        tblSal.TotalSales

) tbl;