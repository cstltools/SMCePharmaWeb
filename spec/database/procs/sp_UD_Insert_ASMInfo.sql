
create PROCEDURE [dbo].[sp_UD_Insert_ASMInfo]
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


	
	UPDATE tblASMInfo set
	  IsActive=0
           ,ActiveInActiveDate=@acInAcDate
           
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE  ASMId = @ASMId

	--UPDATE tblASMInfo
	--SET CompanyId=@CompanyId
 --          ,AreaId=@AreaId
 --          ,EmployeeId=@EmployeeId
 --          ,IsActive=@isActive
 --          ,ActiveInActiveDate=@acInAcDate
 --          ,UpdateBy=@entryBy
 --          ,UpdateDate=GETDATE()
     
	--WHERE  ASMId = @ASMId

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


 END
