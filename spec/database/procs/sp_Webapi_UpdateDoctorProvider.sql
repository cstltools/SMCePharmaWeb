
create PROCEDURE [dbo].[sp_Webapi_UpdateDoctorProvider]
	-- Add the parameters for the stored procedure here
    @empId INT = NULL ,
    
    @ProgramTypeId int = NULL,
    @DoctorId  int = NULL
AS
    BEGIN




		DECLARE @FromProgramTypeId INT=0
	SELECT @FromProgramTypeId=ProgramTypeId FROM dbo.tblDoctorMaster   WHERE   DoctorId = @DoctorId

		DECLARE @MasterId INT=0
	SELECT @MasterId=UserId FROM dbo.tblUser WHERE EmpInfoId = @empId

	INSERT INTO [dbo].[tblDoctorUpdateProviderLog]
           ([FromProgramTypeId]
           ,[ToProgramTypeId]
           ,DoctorId
           ,[UpdateBy]
           ,[UpdateDate])
     VALUES
           (@FromProgramTypeId
           ,@ProgramTypeId
           ,@DoctorId
           ,@MasterId
           ,GETDATE())

        UPDATE  dbo.tblDoctorMaster
        SET    IsMarketUpdate2022=1,ProgramTypeId=@ProgramTypeId, UpdateBy=@MasterId, UpdateDate=GETDATE()
        WHERE   DoctorId = @DoctorId
                
					 

    END
