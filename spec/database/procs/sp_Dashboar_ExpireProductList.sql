-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Dashboar_ExpireProductList]
	
	-- Add the parameters for the stored procedure here
	@expireIn INT,
	@companyId INT

AS
BEGIN
   
	SELECT ProductCode,ProductName,PackSize,CONVERT(varchar, MfgDate, 7) MfgDate,CONVERT(varchar, ExpDate, 7) ExpDate,BatchNo,SUM(StockQty) AS StockQty FROM dbo.tblDCStore 
    INNER JOIN dbo.tblCompanyUnit AS CU ON CU.ComUnitId = tblDCStore.ComUnitId
    WHERE ProductCode IS NOT NULL AND (GETDATE() BETWEEN DATEADD(MONTH, (@expireIn * -1), CAST(ExpDate AS DATETIME)) AND ExpDate) 
    AND tblDCStore.ComUnitId = @companyId GROUP BY ProductCode,ProductName,PackSize,MfgDate,ExpDate,BatchNo HAVING SUM(StockQty) > 0


END
