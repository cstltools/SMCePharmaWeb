
create PROCEDURE [dbo].[sp_UD_MIOInfo]
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

	UPDATE tblMIOInfo
	SET CompanyId=@CompanyId
           ,TerritoryId=@TerritoryId
           ,EmployeeId=@EmployeeId
           ,IsActive=@IsActive
           ,ActiveInActiveDate=@acInAcDate
           
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE MIOId = @MIOId

 END
