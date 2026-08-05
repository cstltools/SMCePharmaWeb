
create PROCEDURE [dbo].[sp_Webapi_UpdateCustomerProvider]
	-- Add the parameters for the stored procedure here
    @empId INT = NULL ,
    
    @ProgramTypeId int = NULL,
    @CustomerMasterId int = NULL
AS
    BEGIN




		DECLARE @FromProgramTypeId INT=0
	SELECT @FromProgramTypeId=ProgramTypeId FROM dbo.tblCustMaster   WHERE   CustomerMasterId = @CustomerMasterId

		DECLARE @MasterId INT=0
	SELECT @MasterId=UserId FROM dbo.tblUser WHERE EmpInfoId = @empId

	INSERT INTO [dbo].[tblCustUpdateProviderLog]
           ([FromProgramTypeId]
           ,[ToProgramTypeId]
           ,[CustomerMasterId]
           ,[UpdateBy]
           ,[UpdateDate])
     VALUES
           (@FromProgramTypeId
           ,@ProgramTypeId
           ,@CustomerMasterId
           ,@MasterId
           ,GETDATE())

        UPDATE  dbo.tblCustMaster
        SET    IsMarketUpdate2022=1,ProgramTypeId=@ProgramTypeId, UpdateBy=@MasterId, UpdateDate=GETDATE()
        WHERE   CustomerMasterId = @CustomerMasterId
                
					 

    END
