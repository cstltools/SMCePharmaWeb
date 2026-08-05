

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_DistrictCoordinator]
	-- Add the parameters for the stored procedure here
	  @id  INT 

AS
BEGIN
		 
	Delete FROM dbo.tblDistrictCoordinator WHERE DistCoordinatorId = @id

END



