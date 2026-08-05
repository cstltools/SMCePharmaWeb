create PROCEDURE [dbo].[sp_DEL_TargetInfo]
	-- Add the parameters for the stored procedure here
    @SL INT 
AS
    BEGIN

    Delete from tblTerritoryDataMigration where SL =@SL
		
END
