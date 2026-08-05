
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_CS_GetTerritory_All]
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN
		SELECT  TerritoryId,TerritoryCode+' : '+  CASE WHEN IsActive=1 THEN   TerritoryName ELSE   TerritoryName+' (Inactive)' END  TerritoryName  FROM dbo.tblTerritory WITH (NOLOCK)  
END


