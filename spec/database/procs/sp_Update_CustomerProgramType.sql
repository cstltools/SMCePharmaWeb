

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_CustomerProgramType]
    
	@CustomerMasterId int,
	@ProgramTypeId int =null ,
	@ProgramTypeCode nvarchar(max) =null ,
    @UpdateBy INT =null,
	@UpdateDate DATETIME = NULL

AS
BEGIN


declare @FromProgramTypeId int=null, @FromProgramTypeCode nvarchar(max) =null 

select @FromProgramTypeCode =  ProgramTypeCode,  @FromProgramTypeId =  ProgramTypeId from tblCustMaster WHERE  CustomerMasterId = @CustomerMasterId


INSERT INTO [dbo].[tblCustProgramTypeChange]
           ([CustomerMasterId]
           ,[FromProgramTypeId]
           ,[ToProgramTypeId]
           ,[FromProgramTypeCode]
           ,[ToProgramTypeCode]
           ,[UpdateBy]
           ,[UpdateDate])
     VALUES
           (@CustomerMasterId
           ,@FromProgramTypeId
           ,@ProgramTypeId
           ,@FromProgramTypeCode
           ,@ProgramTypeCode
           ,@UpdateBy
           ,@UpdateDate)



UPDATE tblCustMaster
   SET  ProgramTypeCode = @ProgramTypeCode,  ProgramTypeId = @ProgramTypeId
       
      ,UpdateBy = @UpdateBy
      ,UpdateDate = @UpdateDate
 WHERE  CustomerMasterId = @CustomerMasterId

	

END



