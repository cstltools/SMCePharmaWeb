
CREATE PROCEDURE [dbo].[sp_Save_ASMInfo]
	
	-- Add the parameters for the stored procedure here

	@ASMId INT,
    @CompanyId INT,
	@AreaId INT,
	@EmployeeId INT,
    @entryBy INT,
	@isActive BIT,
	@acInAcDate DATETIME

 AS
    BEGIN
	
	IF NOT EXISTS (select ASMId from tblASMInfo where AreaId = @AreaId and IsActive=1)
    BEGIN 
        INSERT INTO tblASMInfo
           (CompanyId
           ,AreaId
           ,EmployeeId
           ,IsActive
           ,ActiveInActiveDate
           ,EntryBy
           ,EntryDate)
     VALUES
           (@CompanyId,
		   @AreaId,
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
