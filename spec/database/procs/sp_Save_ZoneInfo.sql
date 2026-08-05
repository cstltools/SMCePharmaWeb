
CREATE PROCEDURE [dbo].[sp_Save_ZoneInfo]
	-- Add the parameters for the stored procedure here
	@zoneId INT,
    @zoneName NVARCHAR(MAX) ,
    @CodeStr NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) =null,
    @remarks NVARCHAR(MAX)=null ,
	@isActive BIT,
	@acInAcDate DATETIME,
	@GroupId INT
 AS
    BEGIN
	


		IF  NOT EXISTS (SELECT * FROM tblRegion WHERE RegionName = @zoneName AND GroupId=@GroupId)
		BEGIN

			DECLARE @zoneCode NVARCHAR(MAX)

			SELECT  @zoneCode = 'Z-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(RegionId)
			                                                      + 10001 )) )
			FROM    dbo.tblRegion 


			INSERT INTO tblRegion
			   (RegionName
			   ,RegionCode,CodeStr
			   ,IsActive
			   ,AcOrInAcDate
			   ,EntryBy
			   ,EntryDate,
			   GroupId
			   )
			VALUES
			   (@zoneName , @CodeStr,
			   @zoneCode ,
			   @isActive ,
			   @acInAcDate ,
			   @createdBy ,
			   GETDATE(),
			   @GroupId)

			SELECT SCOPE_IDENTITY()

		END

       	ELSE  	
		Return 0 



    END
