-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_Dashboard_NationalProductSales] 

 @CompanyId INT,
 @Prameter NVARCHAR(MAX)

AS
BEGIN
	

	DECLARE @Query NVARCHAR(MAX)

	SET @Query = 'SELECT NTP.ProductCode + '':'' + PD.ProductName AS Product,SUM(NTP.DeliveryQuantity) AS SalesQuantity,SUM(NTP.Value) AS SalesValue FROM tblProduct AS PD 
	  LEFT JOIN (SELECT INVD.ProductCode,INVD.DeliveryQuantity,(CASE WHEN INVD.DeliveryNetAmount > 0 THEN  INVD.DeliveryNetAmount  ELSE 0 END) Value FROM dbo.tblInvoice AS INV 
	  LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INVD.InvoiceId = INV.InvoiceId 
	  WHERE INVD.DeliveryStatus IN (''Full'',''Partial'') AND INVD.Quantity > 0 ' + @Prameter + ') AS NTP ON NTP.ProductCode = PD.ProductCode WHERE PD.CompanyId = 1
	  GROUP BY NTP.ProductCode,PD.PackSize,PD.ProductName HAVING NTP.ProductCode IS NOT NULL ORDER BY SalesQuantity DESC'

	EXEC(@Query)  

END

--SELECT TOP 10 * FROM tblInvoice ORDER BY InvoiceId DESC



