
create PROCEDURE [dbo].[sp_UD_Insert_MIOInfo]
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



	UPDATE tblMIOInfo set
	  IsActive=0
           ,ActiveInActiveDate=@acInAcDate
           
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE()
     
	WHERE MIOId = @MIOId



	 INSERT INTO tblMIOInfo
           (CompanyId
           ,TerritoryId
           ,EmployeeId
           ,IsActive
           ,ActiveInActiveDate
           ,EntryBy
           ,EntryDate)
     VALUES
           (@CompanyId,
		   @TerritoryId,
		   @EmployeeId,
		   @isActive,
		   @acInAcDate,
		   @entryBy,
		   GETDATE())



	

 END
