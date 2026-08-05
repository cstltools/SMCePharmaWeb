CREATE PROCEDURE [dbo].[sp_Webapi_delete_TourPlanData]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
	
		DELETE FROM dbo.tbl_TourPlanInfo WHERE TourPlanId = @id
END
