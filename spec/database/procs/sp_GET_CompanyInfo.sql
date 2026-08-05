-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_CompanyInfo] 


AS
BEGIN
	

	  SELECT CompanyId,CompanyName FROM tblCompanyInfo

END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 


