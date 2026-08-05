
create PROCEDURE [dbo].[sp_UD_NSMHeadInfo]
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

	UPDATE tblNational_NSM
	SET CompanyId=@CompanyId
           ,NationalId=@GroupId
           ,EmployeeId=@EmployeeId
           ,IsActive=@isActive
           ,ActiveDate=@acInAcDate
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE National_NSMId = @NSMId

 END
