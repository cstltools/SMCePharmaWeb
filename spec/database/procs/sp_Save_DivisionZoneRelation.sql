
CREATE PROCEDURE [dbo].[sp_Save_DivisionZoneRelation]
	-- Add the parameters for the stored procedure here
    @zoneId INT ,
    @divisionId INT
AS
    BEGIN
	

        INSERT  INTO dbo.tbl_ZoneDivisionRelation
                ( ZoneId, DivisionId )
        VALUES  ( @zoneId,@divisionId
                  )


    END

