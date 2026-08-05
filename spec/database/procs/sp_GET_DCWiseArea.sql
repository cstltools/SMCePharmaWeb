CREATE PROCEDURE [dbo].[sp_GET_DCWiseArea]
	
	-- Add the parameters for the stored procedure here
	@DepotId INT

AS
BEGIN


	SELECT ISNULL(DCA.DcWiseAreaId,0) AS DcWiseAreaId,ARA.AreaId,AreaCode+':'+AreaName AS Area, 
	CASE WHEN DCA.AreaId IS NOT NULL THEN ' checked' ELSE '' END AS CheckStatus FROM tblArea AS ARA
	LEFT JOIN (SELECT DcWiseAreaId,AreaId FROM tblDcWiseAreaInfo  
	WHERE DCId = @DepotId AND IsActive = 1) AS DCA ON DCA.AreaId = ARA.AreaId
	

END

