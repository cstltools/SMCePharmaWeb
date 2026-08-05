
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,0@CompanyId/@CompanyId5/20@CompanyId6,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DSB_BusinessSummery] 

	@Parameter1 NVARCHAR(MAX),
	@Parameter2 NVARCHAR(MAX),
	@Parameter3 NVARCHAR(MAX),
	@Parameter4 NVARCHAR(MAX)
	
AS
BEGIN
	
	DECLARE @Query NVARCHAR(MAX)


	SET @Query = 'SELECT RGN.RegionName,ISNULL(DD.Amount,0) PreviousDue,ISNULL(DDP.Amount,0) TodaysDue,(ISNULL(DD.Amount,0) + ISNULL(DDP.Amount,0)) AS TotalDue,
	ISNULL(CTPD.PrevousDueCollection,0) PrevousDueCollection,ISNULL(CTD.TodaysCollection,0) TodaysCollection,
	(ISNULL(CTPD.PrevousDueCollection,0) + ISNULL(CTD.TodaysCollection,0)) AS TotalCollection  FROM tblRegion AS RGN
	LEFT JOIN (SELECT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PaymentAmount,0) + ISNULL(AIT,0)  + ISNULL(DiscountOnPayment,0))) AS Amount FROM tblinvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter1 + '
	GROUP BY RegionName) AS DD ON RGN.RegionName = DD.RegionName 
	LEFT JOIN (SELECT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PaymentAmount,0) + ISNULL(AIT,0)  + ISNULL(DiscountOnPayment,0))) AS Amount FROM tblinvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter2 + '
	GROUP BY RegionName) AS DDP ON RGN.RegionName = DDP.RegionName	
	LEFT JOIN (	SELECT RegionName,ISNULL(SUM(CPD.PaymentAmount),0) AS TodaysCollection FROM tblCustPayDetail AS CPD
	LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId
	LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	WHERE RegionName IS NOT NULL ' + @Parameter3 + ' GROUP BY RegionName) AS CTD ON RGN.RegionName = CTD.RegionName
	LEFT JOIN (	SELECT RegionName,ISNULL(SUM(CPD.PaymentAmount),0) AS PrevousDueCollection FROM tblCustPayDetail AS CPD
	LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId
	LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	WHERE RegionName IS NOT NULL ' + @Parameter4 + ' GROUP BY RegionName) AS CTPD ON RGN.RegionName = CTPD.RegionName
	GROUP BY RGN.RegionName,ISNULL(DD.Amount,0) ,ISNULL(DDP.Amount,0),ISNULL(CTD.TodaysCollection,0),ISNULL(CTPD.PrevousDueCollection,0) 
	HAVING ISNULL(DD.Amount,0) > 0 OR ISNULL(DDP.Amount,0) > 0 OR ISNULL(CTD.TodaysCollection,0) > 0 OR ISNULL(CTPD.PrevousDueCollection,0) > 0'


	EXEC(@Query)

END




