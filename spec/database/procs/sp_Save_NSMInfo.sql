
CREATE PROCEDURE [dbo].[sp_Save_NSMInfo]
	
	-- Add the parameters for the stored procedure here

	@NSMId INT,
    @CompanyId INT,
	@GroupId INT,
	@EmployeeId INT,
    @entryBy INT,
	@isActive BIT,
	@acInAcDate DATETIME

 AS
    BEGIN
	
	IF NOT EXISTS (select NSMId from tblNSMInfo where GroupId = @GroupId and IsActive=1)
    BEGIN 
        INSERT INTO tblNSMInfo
           (CompanyId
           ,GroupId
           ,EmployeeId
           ,IsActive
           ,ActiveDate
           ,EntryBy
           ,EntryDate)
     VALUES
           (@CompanyId,
		   @GroupId,
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
