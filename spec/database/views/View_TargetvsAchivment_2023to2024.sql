CREATE VIEW dbo.View_TargetvsAchivment_2023to2024
AS
SELECT        (SELECT        dbo.MonthValueToName(tbl.MonthName) AS Expr1) AS MonthName, YearValue, CASE WHEN CAST(ISNULL(TargetValue, 0) AS DECIMAL(18, 2)) = 0 THEN 0 ELSE CAST(ISNULL(SalesValue, 0) 
                         * 100.0 / CAST(ISNULL(TargetValue, 0) AS DECIMAL(18, 2)) AS DECIMAL(18, 2)) END AS SalesAchivPercent, RegionCode AS ZoneCode, AreaCode, TerritoryCode, TargetValue, SalesValue
FROM            (SELECT        tm.MonthName, tm.YearValue, rg.RegionCode, ar.AreaCode, tm.TerritoryCode, SUM(CAST(ISNULL(tm.Value, 0) AS DECIMAL(18, 2))) AS TargetValue, ISNULL(tblOrd.TotalOrder, 0) AS OrderValue, 
                                                    ISNULL(tblInv.TotalInvoice, 0) AS InvoiceValue, ISNULL(tblSal.TotalSales, 0) AS SalesValue
                          FROM            dbo.tblTerritory AS tr WITH (nolock) INNER JOIN
                                                    dbo.tblArea AS ar WITH (nolock) ON ar.AreaId = tr.AreaId INNER JOIN
                                                    dbo.tblRegion AS rg WITH (nolock) ON ar.RegionId = rg.RegionId INNER JOIN
                                                    dbo.tblTerritoryDataMigration AS tm ON tm.TerritoryId = tr.TerritoryId LEFT OUTER JOIN
                                                        (SELECT        Ord.TerritoryId, CONVERT(decimal(18, 2), ISNULL(SUM(OrdD.TotalTradePrice) - SUM(OrdD.DiscountAmount), 0)) AS TotalOrder
                                                          FROM            dbo.tblOrder AS Ord WITH (nolock) INNER JOIN
                                                                                    dbo.tblOrderDetail AS OrdD WITH (nolock) ON Ord.OrderId = OrdD.OrderId
                                                          WHERE        (Ord.ActionStatus = '2') AND (CONVERT(Date, Ord.SubmissionDate) BETWEEN CONVERT(Date, '1-july-2023') AND CONVERT(Date, '30-june-2024'))
                                                          GROUP BY Ord.TerritoryId) AS tblOrd ON tblOrd.TerritoryId = tr.TerritoryId LEFT OUTER JOIN
                                                        (SELECT        ord.TerritoryId, CONVERT(decimal(18, 2), ISNULL(SUM(ID.TotalPrice - ID.DiscountAmount) - SUM(ISNULL(ID.AdjustmentAmount, 0)), 0)) AS TotalInvoice
                                                          FROM            dbo.tblInvoice AS A WITH (nolock) INNER JOIN
                                                                                    dbo.tblInvoiceDetail AS ID ON A.InvoiceId = ID.InvoiceId INNER JOIN
                                                                                    dbo.tblOrder AS ord WITH (nolock) ON ord.OrderId = A.OrderId
                                                          WHERE        (CONVERT(Date, A.InvoiceDate) BETWEEN CONVERT(Date, '1-july-2023') AND CONVERT(Date, '30-june-2024'))
                                                          GROUP BY ord.TerritoryId) AS tblInv ON tblInv.TerritoryId = tr.TerritoryId LEFT OUTER JOIN
                                                        (SELECT        ord.TerritoryId, CONVERT(decimal(18, 0), ISNULL(SUM(ID.TotalPrice - ID.DiscountAmount) - SUM(ISNULL(ID.AdjustmentAmount, 0)), 0)) AS TotalSales
                                                          FROM            dbo.tblInvoice AS A WITH (nolock) INNER JOIN
                                                                                    dbo.tblInvoiceDetail AS ID ON A.InvoiceId = ID.InvoiceId INNER JOIN
                                                                                    dbo.tblOrder AS ord WITH (nolock) ON ord.OrderId = A.OrderId
                                                          WHERE        (CONVERT(Date, A.UpdateDate) BETWEEN CONVERT(Date, '1-july-2023') AND CONVERT(Date, '30-june-2024')) AND (A.DeliveryInvoiceStatus IN ('Full', 'Partial'))
                                                          GROUP BY ord.TerritoryId) AS tblSal ON tblSal.TerritoryId = tr.TerritoryId
                          WHERE        (tm.MonthName IN
                                                        (SELECT        MonthValue
                                                          FROM            dbo.GetMonthYearValuesDateRange('1-july-2023', '30-june-2024') AS GetMonthYearValuesDateRange_2)) AND (tm.YearValue IN
                                                        (SELECT        YearValue
                                                          FROM            dbo.GetMonthYearValuesDateRange('1-july-2023', '30-june-2024') AS GetMonthYearValuesDateRange_1))
                          GROUP BY tm.MonthName, tm.YearValue, rg.RegionCode, rg.RegionName, ar.AreaName, ar.AreaCode, tm.TerritoryCode, tr.TerritoryName, ISNULL(tblOrd.TotalOrder, 0), ISNULL(tblInv.TotalInvoice, 0), ISNULL(tblSal.TotalSales, 
                                                    0)) AS tbl
