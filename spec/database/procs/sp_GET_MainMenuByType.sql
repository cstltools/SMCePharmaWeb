
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_MainMenuByType] 
@TypeId INT 

AS
BEGIN
	
	if(@TypeId=2)
	begin
	  	  SELECT * FROM dbo.tblMainMenuNew WHERE  IsApprovalPage=1

	   end
	   else
	   begin
	  SELECT * FROM dbo.tblMainMenuNew WHERE  IsApprovalPage=1

	   end

END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 



