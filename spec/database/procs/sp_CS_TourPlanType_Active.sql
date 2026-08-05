CREATE PROCEDURE [dbo].[sp_CS_TourPlanType_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT   *	FROM dbo.tbl_TourPlanType   WITH (NOLOCK) WHERE IsActive=1
END
