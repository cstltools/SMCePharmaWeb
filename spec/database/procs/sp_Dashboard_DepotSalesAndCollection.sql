-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_Dashboard_DepotSalesAndCollection] 

 @DepotId NVARCHAR(MAX),
 @fromDate datetime,
 @toDate datetime

AS
BEGIN
	

	  SELECT INV.InvoiceDate,CONVERT(varchar, INV.InvoiceDate, 7)  + ' : '+ LEFT(DATENAME(DW,INV.InvoiceDate),3) AS InvoiceDate2 ,
	  SUM(CASE WHEN INVD.DeliveryNetAmount > 0 THEN  INVD.DeliveryNetAmount  ELSE 0 END) AS SalesValue,ISNULL(PM.Collection,0) Collection FROM tblInvoice AS INV 
	  LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
	  LEFT JOIN (SELECT PaymentDate,SUM(CPD.PaymentAmount) AS Collection FROM tblCustPayDetail AS CPD
	  LEFT JOIN tblCustomerPay AS CP ON CPD.CustPayId = CP.CustPayId
	  LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	  LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
	  WHERE PaymentDate BETWEEN  @fromDate AND @toDate AND UNT.ComUnitId = @DepotId GROUP BY PaymentDate) AS PM ON INV.InvoiceDate = PM.PaymentDate
	  WHERE INV.DeliveryInvoiceStatus IN ('Full','Partial') AND INVD.Quantity > 0  AND INV.InvoiceDate BETWEEN  @fromDate AND @toDate AND ComUnitId = @DepotId
	  GROUP BY INV.InvoiceDate, ISNULL(PM.Collection,0) ORDER BY INV.InvoiceDate

END

--SELECT TOP 10 * FROM tblInvoice ORDER BY InvoiceId DESC



