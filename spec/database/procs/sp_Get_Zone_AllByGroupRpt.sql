
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Zone_AllByGroupRpt]
	-- Add the parameters for the stored procedure here

	@GroupId INT

AS
BEGIN
	

	SELECT RegionId,RegionCode+' : '+CASE WHEN IsActive=1 THEN   RegionName  ELSE   RegionName+' (Inactive)' END  RegionName  FROM dbo.tblRegion WITH (NOLOCK) WHERE   GroupId = @GroupId

END


