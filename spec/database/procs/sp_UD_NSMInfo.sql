
create PROCEDURE [dbo].[sp_UD_NSMInfo]
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

	UPDATE tblNSMInfo
	SET CompanyId=@CompanyId
           ,GroupId=@GroupId
           ,EmployeeId=@EmployeeId
           ,IsActive=@isActive
           ,ActiveDate=@acInAcDate
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE NSMId = @NSMId

 END
