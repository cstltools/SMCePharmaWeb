-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_DashboardCardInfo] 

 @CurrentDate DATETIME,
 @CompanyId NVARCHAR(MAX)


AS
BEGIN
	

	  DECLARE @Sales TABLE 
	(

	  NoOfOrder DECIMAL(18,2),
	  NoOfInvoice DECIMAL(18,2),
	  DeliveryConfirmed DECIMAL(18,2),
	  ActualSales DECIMAL(18,2),
	  TotalCollection DECIMAL(18,2),
	  TotalDue DECIMAL(18,2)
	)


	DECLARE @NoOfOrder DECIMAL(18,2)
	DECLARE @NoOfInvoice DECIMAL(18,2)
	DECLARE @DeliveryConfirmed DECIMAL(18,2)
	DECLARE @ActualSales DECIMAL(18,2) 
	DECLARE @TotalCollection DECIMAL(18,2)
	DECLARE @TotalDue DECIMAL(18,2)

	SELECT @NoOfOrder =  COUNT(OrderCode) FROM tblOrder WHERE SubmissionDate = @CurrentDate AND ActionStatus IN ('Accepted') 
	SELECT @NoOfInvoice = COUNT(INV.InvoiceNo) FROM tblInvoice AS INV 
	LEFT JOIN  tblCompanyUnit AS UT ON UT.ComUnitId = INV.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON Ci.CompanyId = UT.CompanyId
	WHERE INV.InvoiceDate = @CurrentDate AND INV.InvoiceNo IS NOT NULL AND CI.CompanyId = @CompanyId

	SELECT @DeliveryConfirmed = COUNT(INV.DelivaryInvoiceNo) FROM tblInvoice AS INV 
	LEFT JOIN  tblCompanyUnit AS UT ON UT.ComUnitId = INV.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON Ci.CompanyId = UT.CompanyId
	WHERE INV.UpdateDate = @CurrentDate AND INV.DelivaryInvoiceNo IS NOT NULL AND INV.DeliveryInvoiceStatus IN ('Full','Partial') 

    SELECT @ActualSales = SUM(CASE WHEN INVD.DeliveryNetAmount > 0 THEN  INVD.DeliveryNetAmount  ELSE 0 END) 
    FROM dbo.tblInvoice AS INV 
    LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
    LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
    LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
    WHERE INV.DeliveryInvoiceStatus IN ('Full','Partial') AND INVD.Quantity > 0  
    AND INV.InvoiceDate = @CurrentDate 

	SELECT @TotalCollection = SUM(CPD.PaymentAmount) FROM tblCustPayDetail AS CPD
	LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId
	LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	WHERE PaymentDate = @CurrentDate 


	SELECT @TotalDue = SUM(DeliveryTpGrandTotal- (ISNULL(PMNT.PaymentAmount,0) + ISNULL(PMNT.AIT,0) + ISNULL(PMNT.Discount,0)))  FROM dbo.tblInvoice AS INV 
LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId  
LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId 
LEFT JOIN ( SELECT InvoiceId,SUM(CPD.PaymentAmount) AS PaymentAmount,SUM(CPD.AIT) AIT, SUM(CPD.Discount) Discount FROM tblCustPayDetail AS CPD  
LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId 
WHERE CP.PaymentDate <= @CurrentDate GROUP BY InvoiceId ) AS PMNT ON PMNT.InvoiceId = inv.InvoiceId 
LEFT JOIN dbo.View_CustomerMaster AS VC ON INV.CustomerMasterId = VC.CustomerMasterId WHERE DeliveryInvoiceStatus IN ('Full','Partial') 
AND INV.InvoiceDate <= @CurrentDate 


	INSERT INTO @Sales
		(
		    NoOfOrder,
			NoOfInvoice,
			DeliveryConfirmed,
			ActualSales,
			TotalCollection,
			TotalDue
		)
		VALUES
		(   
		    ISNULL(@NoOfOrder,0), -- InvoiceValue - decimal(18, 2)
		    ISNULL(@NoOfInvoice,0), -- ActualSales - decimal(18, 2)
		    ISNULL(@DeliveryConfirmed,0), -- InTransit - decimal(18, 2)
		    ISNULL(@ActualSales,0),  -- Reject - decimal(18, 2)
			ISNULL(@TotalCollection,0),  -- Reject - decimal(18, 2)
			ISNULL(@TotalDue,0) 
			
		)


	SELECT * FROM @Sales 


END


