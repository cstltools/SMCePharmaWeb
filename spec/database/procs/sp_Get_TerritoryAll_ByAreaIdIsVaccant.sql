create PROCEDURE [dbo].[sp_Get_TerritoryAll_ByAreaIdIsVaccant]
	-- Add the parameters for the stored procedure here
	@id NVARCHAR(MAX)
AS
BEGIN
		
		SELECT   TerritoryId, TerritoryCode+' : '+TerritoryName TerritoryName  ,'' AS Amount FROM dbo.tblTerritory WITH (NOLOCK)  where IsActive=1 And AreaId= @id  

		and TerritoryId not in (select TerritoryId from tblMIOInfo  where IsActive=1)
END
 






