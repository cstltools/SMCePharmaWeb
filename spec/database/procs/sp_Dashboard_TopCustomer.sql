-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Dashboard_TopCustomer]
	
	-- Add the parameters for the stored procedure here
	@FromDate DATETIME,
	@ToDate DATETIME,
	@companyId INT

AS
BEGIN
   
		SELECT TOP 20 MST.CustomerCode,MST.CustomerName,SUM(CASE WHEN INVD.DeliveryNetAmount > 0 THEN  INVD.DeliveryNetAmount  ELSE 0 END) ActualSales,ISNULL(DD.DUE,0) AS Due
		FROM dbo.tblInvoice AS INV 
		LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
		LEFT JOIN tblCustMaster AS MST ON INV.CustomerMasterId = MST.CustomerMasterId
		LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
		LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
		LEFT JOIN (SELECT INV.CustomerMasterId,
        SUM(DeliveryTpGrandTotal)- SUM((ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0) + ISNULL(PMNT.Discount,0))) AS DUE FROM dbo.tblInvoice AS INV 
        LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD   
        LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId  WHERE CP.PaymentDate <= @ToDate GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
        LEFT JOIN dbo.tblCustMaster AS CSTMR ON CSTMR.CustomerMasterId = INV.CustomerMasterId 
        LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId 
        LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId 
        LEFT JOIN dbo.tblMarket AS MKT ON CSTMR.MarketId = MKT.MarketId 
        LEFT JOIN dbo.tblTerritory AS TTR ON MKT.TerritoryId = TTR.TerritoryId 
        LEFT JOIN dbo.tblArea AS ARA ON TTR.AreaId = ARA.AreaId  WHERE (INV.DeliveryInvoiceStatus IS NOT NULL AND INV.DeliveryInvoiceStatus != 'Reject')  AND CI.CompanyId = @companyId 
        AND INV.InvoiceDate <= @ToDate GROUP BY INV.CustomerMasterId
        HAVING SUM(DeliveryTpGrandTotal)- SUM((ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0) + ISNULL(PMNT.Discount,0))) > 0 ) AS DD ON DD.CustomerMasterId = INV.CustomerMasterId
		WHERE INV.DeliveryInvoiceStatus IN ('Full','Partial') AND INVD.Quantity > 0  
        AND INV.InvoiceDate BETWEEN @FromDate AND @ToDate AND CI.CompanyId = @companyId 
		GROUP BY MST.CustomerName, MST.CustomerCode,ISNULL(DD.DUE,0) ORDER BY SUM(CASE WHEN INVD.DeliveryNetAmount > 0 THEN  INVD.DeliveryNetAmount  ELSE 0 END) DESC 


END
