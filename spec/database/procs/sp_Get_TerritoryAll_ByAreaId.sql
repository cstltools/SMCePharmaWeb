create PROCEDURE [dbo].[sp_Get_TerritoryAll_ByAreaId]
	-- Add the parameters for the stored procedure here
	@id NVARCHAR(MAX)
AS
BEGIN
		
		SELECT   TerritoryId, TerritoryCode+' : '+TerritoryName TerritoryName  ,'' AS Amount FROM dbo.tblTerritory WITH (NOLOCK)  where IsActive=1 And AreaId= @id
END







