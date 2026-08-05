CREATE PROCEDURE [dbo].[sp_Get_AreaAll_ByZoneId]
	-- Add the parameters for the stored procedure here
	@id NVARCHAR(MAX)
AS
BEGIN
		
		SELECT   AreaId, AreaName ,'' AS Amount FROM dbo.tblArea WITH (NOLOCK)  where IsActive=1 And RegionId= @id
END







