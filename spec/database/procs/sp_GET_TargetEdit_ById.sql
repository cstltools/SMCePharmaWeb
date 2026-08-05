create    PROCEDURE [dbo].[sp_GET_TargetEdit_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select  * from tblTerritoryDataMigration where SL = @id
      
    END



