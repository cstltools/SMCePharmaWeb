
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TerritoryWiseTargetList]
	-- Add the parameters for the stored procedure here
	@Parameter nvarchar(max)=null
AS
BEGIN
   DECLARE @Query NVARCHAR(MAX)

SET @Query ='SELECT  CASE WHEN AR.IsActive=1 THEN AR.TerritoryCode   +'' : '' +AR.TerritoryName ELSE  AR.TerritoryCode   +'' : '' +AR.TerritoryName+'' (Inactive)''  END TerritoryName  , AR.IsActive,* FROM tblTerritoryWiseTargetSetup AWT
 
LEFT JOIN tblTerritory  AR ON AWT.TerritoryId = AR.TerritoryId
Where AWT.TerritoryWTSetupId IS NOT NULL '+@Parameter  +' order by AR.TerritoryCode '

EXEC(@Query)
	
END



