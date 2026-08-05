
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,0@CompanyId/@CompanyId5/20@CompanyId6,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DSB_AglingReport] 

	@Parameter NVARCHAR(MAX)

	
AS
BEGIN
	
	DECLARE @Query NVARCHAR(MAX)


	SET @Query = 'SELECT RGN.RegionName,ISNULL(SUM(D9.DueAmount),0) AS D10,ISNULL(SUM(D20.DueAmount),0) AS D20, ISNULL(SUM(D30.DueAmount),0) AS D30,
	ISNULL(SUM(D40.DueAmount),0) AS D40,ISNULL(SUM(D50.DueAmount),0) AS D50,ISNULL(SUM(D60.DueAmount),0) AS D60,ISNULL(SUM(D61.DueAmount),0) D61 FROM tblRegion AS RGN
	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter + ' AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 60)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D61 ON RGN.RegionName = D61.RegionName   

	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'')AND RegionName IS NOT NULL ' + @Parameter + '  AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 0 AND DATEDIFF(DAY, InvoiceDate, GETDATE()) < 11)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D9 ON RGN.RegionName = D9.RegionName 

	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter + ' AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 10 AND DATEDIFF(DAY, InvoiceDate, GETDATE()) < 21)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D20 ON RGN.RegionName = D20.RegionName 

	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter + '  AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 20 AND DATEDIFF(DAY, InvoiceDate, GETDATE()) < 31)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D30 ON RGN.RegionName = D30.RegionName 

	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter + ' AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 30 AND DATEDIFF(DAY, InvoiceDate, GETDATE()) < 41)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D40 ON RGN.RegionName = D40.RegionName 

	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter + '  AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 40 AND DATEDIFF(DAY, InvoiceDate, GETDATE()) < 51)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D50 ON RGN.RegionName = D50.RegionName

	LEFT JOIN (SELECT DISTINCT RegionName,SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) DueAmount FROM tblInvoice AS INV
	LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId
	LEFT JOIN tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= GETDATE() GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
	WHERE DeliveryInvoiceStatus IN (''Full'',''Partial'') AND RegionName IS NOT NULL ' + @Parameter + '  AND (DATEDIFF(DAY, InvoiceDate, GETDATE()) > 50 AND DATEDIFF(DAY, InvoiceDate, GETDATE()) < 61)
	GROUP BY RegionName
	HAVING SUM(DeliveryTpGrandTotal - (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0)  + ISNULL(DiscountOnPayment,0))) > 0
	) AS D60 ON RGN.RegionName = D60.RegionName GROUP BY RGN.RegionName
	HAVING ISNULL(SUM(D9.DueAmount),0) > 0 OR ISNULL(SUM(D20.DueAmount),0) >0 OR ISNULL(SUM(D30.DueAmount),0) > 0 
	OR ISNULL(SUM(D40.DueAmount),0) > 0 OR ISNULL(SUM(D50.DueAmount),0) > 0 OR ISNULL(SUM(D60.DueAmount),0) > 0 OR ISNULL(SUM(D61.DueAmount),0) > 0'


	EXEC(@Query)

END




