CREATE PROCEDURE [dbo].[sp_CS_GetArea_ByZoneId_All]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		
		SELECT   AreaId, AreaCode+' : '+  CASE WHEN IsActive=1 THEN   AreaName  ELSE   AreaName+' (Inactive)' END  AreaName  FROM dbo.tblArea WITH (NOLOCK)  where  RegionId= @id
END


