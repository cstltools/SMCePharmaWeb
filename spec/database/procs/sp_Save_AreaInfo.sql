
CREATE PROCEDURE [dbo].[sp_Save_AreaInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @zoneId INT ,
    @areaName NVARCHAR(MAX) ,
    @CodeStr NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME
AS
    BEGIN

		IF  NOT EXISTS (SELECT * FROM tblArea WHERE AreaName = @areaName and RegionId= @zoneId)
		BEGIN
	
        DECLARE @codeD NVARCHAR(MAX)

        SELECT  @codeD = 'AR-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(AreaId)
                                                           + 10001 )) )
        FROM    dbo.tblArea 


        INSERT  INTO dbo.tblArea
                ( AreaCode ,CodeStr,
                  AreaName ,
                  RegionId ,
                  IsActive ,
                  AcOrInAcDate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  (@CodeStr, @codeD ,
                  @areaName ,
                  @zoneId ,
                  @isActive ,
                  @acInAcDate ,
                  @createdBy ,
                  GETDATE()
                )


				SELECT SCOPE_IDENTITY()
		END

       	ELSE  	
		Return 0 
    END
