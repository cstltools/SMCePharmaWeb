create PROCEDURE [dbo].[sp_CS_TourPlanType_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT   CASE WHEN IsActive=1 THEN   TourTypeName+' (Active)' ELSE   TourTypeName+' (Inactive)' END  TourTypeName,   *	FROM dbo.tbl_TourPlanType   WITH (NOLOCK) 
END
