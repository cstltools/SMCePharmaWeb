-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_Dashboard_PriorityProductSales] 

 @CompanyId INT,
 @fromDate DATETIME,
 @todate DATETIME,
 @RegionId INT

AS
BEGIN
	

	SELECT INVD.ProductCode,INVD.ProductName,ISNULL(TGT.TargetQty,0) TargetQty,ISNULL(SUM(DeliveryTotalQuantity),0) AS SalesQty,
            CASE WHEN TGT.TargetQty IS NOT NULL THEN (ISNULL(SUM(DeliveryTotalQuantity),0) * 100) / NULLIF(TGT.TargetQty,0) 
            ELSE 0 END  AS Achivment,CASE WHEN MAX(InvoiceDate) IS NOT NULL THEN (ISNULL(DATEDIFF(DAY, @fromDate, 
			MAX(InvoiceDate)),0) * 100) / NULLIF(DATEDIFF(DAY, @fromDate, @todate),0)
            ELSE 0 END  AS TimePass FROM tblInvoice AS INV 
            LEFT JOIN tblInvoiceDetail AS INVD ON INV.invoiceId = INVD.InvoiceId 
            LEFT JOIN tblOrder AS ODR ON ODR.OrderId = INV.OrderId 
            LEFT JOIN tblRegion AS RGN ON ODR.RegionId = RGN.RegionId 
            LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId 
            LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId 
            LEFT JOIN (SELECT RGN.RegionName,RSM.EmpName AS RSM,ProductCode,ProductName,SUM(TargetQty) TargetQty  FROM tblMIATargetProductWise AS MTP 
            LEFT JOIN tblProduct AS PD ON MTP.ProductId = PD.ProductId 
            LEFT JOIN tblMIOInfo AS MIO ON MTP.MiaId = MIO.MIOId 
            LEFT JOIN tblTerritory AS TTR ON MIO.TerritoryId = TTR.TerritoryId 
            LEFT JOIN tblArea AS ARA ON ARA.AreaId = TTR.AreaId 
            LEFT JOIN tblRegion AS RGN ON RGN.RegionId = ARA.RegionId 
            LEFT JOIN (SELECT EGI.EmpName,RegionId FROM tblRSMInfo AS RSM  
            LEFT JOIN tblEmpGeneralInfo AS EGI ON RSM.EmployeeId = EGI.EmpInfoId 
            WHERE RSM.CompanyId = 1) AS RSM ON RSM.RegionId = RGN.RegionId WHERE MTP.Year = DATENAME(year,@fromDate) 
            AND (MTP.Period = DATENAME(month,@fromDate))
            GROUP BY RGN.RegionName,RSM.EmpName,ProductCode,ProductName) AS TGT ON INVD.ProductCode = TGT.ProductCode AND RGN.RegionName = TGT.RegionName
            WHERE DeliveryInvoiceStatus IN ('Full','Partial') AND INV.InvoiceDate BETWEEN @fromDate AND @todate AND RGN.RegionId = @RegionId
            AND CI.CompanyId = 1 GROUP BY INVD.ProductCode,INVD.ProductName,TGT.TargetQty  ORDER BY ProductCode

END

			


