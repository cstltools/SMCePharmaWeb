CREATE PROCEDURE [dbo].[sp_CHK_DCWiseArea]
	
	-- Add the parameters for the stored procedure here
	@DepotId INT

AS
BEGIN


	SELECT DcWiseAreaId,AreaId FROM tblDcWiseAreaInfo  WHERE DCId = @DepotId AND IsActive = 1
	

END



