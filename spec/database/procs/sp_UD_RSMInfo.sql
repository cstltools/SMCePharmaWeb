
create PROCEDURE [dbo].[sp_UD_RSMInfo]
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

	UPDATE tblRSMInfo
	SET CompanyId=@CompanyId
           ,RegionId=@RegionId
           ,EmployeeId=@EmployeeId
           ,IsActive=@isActive
           ,ActiveDate=@acInAcDate
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE RSMId = @RSMId

 END
