
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_RoleType] 


AS
BEGIN
	

	  SELECT DisplayName  RoleType, * FROM dbo.tblRoleType with (nolock)
	   

END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 



