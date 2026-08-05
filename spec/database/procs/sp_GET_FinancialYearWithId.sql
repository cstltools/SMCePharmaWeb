

-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_FinancialYearWithId] 

	@CompanyId NVARCHAR(MAX)

AS
BEGIN
	

	  SELECT FinancialYearId,FinancialYearDesc AS FinancialYear 
	  FROM ZAS_ACCDB..tblFinancialYear WHERE CompanyId = @CompanyId
	  

	  --SELECT * FROM ZAS_ACCDB..tblFinancialYear
	  
	  --SELECT * FROM tblFinancialYear

END




