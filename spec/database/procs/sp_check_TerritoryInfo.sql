


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_TerritoryInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT , @areaId int,
      @Name   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblTerritory WHERE TerritoryName=@Name AND TerritoryId NOT IN ( @id) and AreaId=@areaId

END




