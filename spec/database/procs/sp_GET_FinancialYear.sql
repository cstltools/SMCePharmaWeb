-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_FinancialYear] 

	@CompanyId NVARCHAR(MAX)

AS
BEGIN
	

	  SELECT CONVERT(VARCHAR(10), StartDate, 111) + '|' + CONVERT(VARCHAR(10), EndDate, 111) FinancialYearId,FinancialYearDesc AS FinancialYear 
	  FROM ZAS_ACCDB..tblFinancialYear WHERE CompanyId = @CompanyId
	  

	  --SELECT * FROM ZAS_ACCDB..tblFinancialYear
	  
	  --SELECT * FROM tblFinancialYear

END


