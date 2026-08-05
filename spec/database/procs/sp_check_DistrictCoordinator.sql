

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DistrictCoordinator]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @EmpInfoId     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblDistrictCoordinator WHERE EmpInfoId=@EmpInfoId AND DistCoordinatorId NOT IN ( @id)

END



