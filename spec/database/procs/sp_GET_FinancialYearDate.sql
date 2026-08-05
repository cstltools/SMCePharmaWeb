
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_FinancialYearDate] 

	@CompanyId NVARCHAR(MAX),
	@FinYearId NVARCHAR(MAX)

AS
BEGIN
	

	  SELECT StartDate,EndDate,FinancialYearId
	  FROM ZAS_ACCDB..tblFinancialYear WHERE CompanyId = @CompanyId AND FinancialYearId=@FinYearId
	   

	  --SELECT * FROM ZAS_ACCDB..tblFinancialYear
	  
	  --SELECT * FROM tblFinancialYear

END



