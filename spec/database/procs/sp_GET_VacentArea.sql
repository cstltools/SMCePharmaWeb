CREATE PROCEDURE [dbo].[sp_GET_VacentArea]
	
	-- Add the parameters for the stored procedure here
	@RegionId INT

AS
BEGIN


		SELECT distinct AR.AreaId, AR.AreaCode + ' : ' + AR.AreaName AS AreaName FROM tblArea AS AR 
        INNER JOIN tblRegion AS RGN ON AR.RegionId = RGN.RegionId
        LEFT JOIN tblASMInfo AS ASM ON AR.AreaId = ASM.AreaId
        WHERE AR.RegionId = @RegionId AND AR.IsActive = 1 AND AR.AreaId not in (SELECT AreaId FROM tblASMInfo WHERE IsActive = 1)

		
END


