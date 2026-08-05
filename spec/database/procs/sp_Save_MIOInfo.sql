
CREATE PROCEDURE [dbo].[sp_Save_MIOInfo]
	
	-- Add the parameters for the stored procedure here

	@MIOId INT,
    @CompanyId INT,
	@TerritoryId INT,
	@EmployeeId INT,
    @entryBy INT,
	@isActive BIT,
	@acInAcDate DATETIME

 AS
    BEGIN
	IF NOT EXISTS (select MIOId from tblMIOInfo where  TerritoryId = @TerritoryId and IsActive=1)
    BEGIN 

	declare @SapCode nvarchar(max)=''
	select @SapCode=c.SAP_MIOCode from tblMIOInfo c where c.EmployeeId=@EmployeeId
        INSERT INTO tblMIOInfo
           (CompanyId
           ,TerritoryId
           ,EmployeeId
           ,IsActive
           ,ActiveInActiveDate
           ,EntryBy
           ,EntryDate, SAP_MIOCode)
     VALUES
           (@CompanyId,
		   @TerritoryId,
		   @EmployeeId,
		   @isActive,
		   @acInAcDate,
		   @entryBy,
		   GETDATE(),@SapCode)

		SELECT SCOPE_IDENTITY()

		END
		ELSE  	
		Return 0
    END
