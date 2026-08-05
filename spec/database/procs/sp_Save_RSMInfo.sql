
CREATE PROCEDURE [dbo].[sp_Save_RSMInfo]
	
	-- Add the parameters for the stored procedure here

	@RSMId INT,
    @CompanyId INT,
	@RegionId INT,
	@EmployeeId INT,
    @entryBy INT,
	@isActive BIT,
	@acInAcDate DATETIME

 AS
    BEGIN
	
	IF NOT EXISTS (select RegionId from tblRSMInfo where RegionId = @RegionId and IsActive=1)
    BEGIN 
        INSERT INTO tblRSMInfo
           (CompanyId
           ,RegionId
           ,EmployeeId
           ,IsActive
           ,ActiveDate
           ,EntryBy
           ,EntryDate)
     VALUES
           (@CompanyId,
		   @RegionId,
		   @EmployeeId,
		   @isActive,
		   @acInAcDate,
		   @entryBy,
		   GETDATE())

		SELECT SCOPE_IDENTITY()
		END
		ELSE  	
		Return 0

    END
