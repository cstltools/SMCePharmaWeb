
create PROCEDURE [dbo].[sp_UD_ASMInfo]
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

	UPDATE tblASMInfo
	SET CompanyId=@CompanyId
           ,AreaId=@AreaId
           ,EmployeeId=@EmployeeId
           ,IsActive=@isActive
           ,ActiveInActiveDate=@acInAcDate
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE  ASMId = @ASMId

 END
