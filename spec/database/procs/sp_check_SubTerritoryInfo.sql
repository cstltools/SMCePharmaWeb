


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_SubTerritoryInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT , @TerritoryId INT ,
      @Name   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblSubTerritory WHERE SubTerritoryName=@Name AND SubTerritoryId NOT IN ( @id) and  TerritoryId=@TerritoryId

END




