
create PROCEDURE [dbo].[sp_Get_Zone_ForDSM]
    -- Add the parameters for the stored procedure here

    @GroupId nvarchar(max)

AS
BEGIN
    

    SELECT RegionId,RegionCode+' : '+CASE WHEN IsActive=1 THEN   RegionName  ELSE   RegionName+' (Inactive)' END  RegionName  FROM dbo.tblRegion WITH (NOLOCK) WHERE   RegionId in (select * from fnSplit(@GroupId,','))

END