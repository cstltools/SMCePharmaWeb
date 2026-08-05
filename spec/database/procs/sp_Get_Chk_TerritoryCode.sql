create PROCEDURE [dbo].[sp_Get_Chk_TerritoryCode]
	-- Add the parameters for the stored procedure here
	@TerritoryCode nvarchar(max)  

AS
BEGIN


  select TerritoryCode from  tblTerritory where TerritoryCode=@TerritoryCode

  end 