CREATE PROCEDURE [dbo].[sp_CS_GetArea_ByZoneId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		
		SELECT AreaId, AreaCode+' : '+AreaName AreaName FROM dbo.tblArea  WITH (NOLOCK)  WHERE IsActive = 1 AND RegionId= @id
END


