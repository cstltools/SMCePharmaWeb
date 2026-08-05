CREATE PROCEDURE [dbo].[sp_GET_VacentRegion]
	
	-- Add the parameters for the stored procedure here
	@GroupId INT

AS
BEGIN


		--SELECT distinct AR.AreaId, AR.AreaCode + ' : ' + AR.AreaName AS AreaName FROM tblArea AS AR 
  --      INNER JOIN tblRegion AS RGN ON AR.RegionId = RGN.RegionId
  --      LEFT JOIN tblASMInfo AS ASM ON AR.AreaId = ASM.AreaId
  --      WHERE AR.RegionId = '" + regionId + "' AND AR.IsActive = 'True' AND AR.AreaId not in (SELECT AreaId FROM tblASMInfo WHERE IsActive = 'True')
		
		SELECT distinct RGN.RegionId, RGN.RegionCode + ' : ' + RGN.RegionName AS RegionName FROM tblRegion AS RGN WITH (NOLOCK)
        LEFT JOIN tblRSMInfo AS RSM ON RGN.RegionId = RSM.RegionId
        WHERE RGN.IsActive = 1 AND GroupId = @GroupId AND  RGN.RegionId not in (select RegionId from tblRSMInfo where IsActive = 1)
END


