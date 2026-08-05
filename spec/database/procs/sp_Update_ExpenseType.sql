
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_ExpenseType]
	-- Add the parameters for the stored procedure here
    @ExpenseTypeId  INT,
 
   
    @ExpenseTypeName NVARCHAR(MAX),
    @ExpenseAmount decimal(18,2),
    @ImageRequired NVARCHAR(MAX),    @RoleTypeMult NVARCHAR(max) =Null ,
    @EmpNameMult NVARCHAR(max) =Null ,
	@IsActive BIT,
	@isFixed BIT,
		@RoleType_xp INT,
	@UpdateBy NVARCHAR(50)  

AS
    BEGIN
        UPDATE  dbo.tbl_ExpenseTypeMaster
        SET     
		        ExpenseTypeName = @ExpenseTypeName,
				ImageRequired = @ImageRequired,
				IsActive = @IsActive,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE()   , ExpenseAmount  =@ExpenseAmount , isFixed    =@isFixed    , RoleTypeMult=@RoleTypeMult, EmpNameMult  =@EmpNameMult            
        WHERE   ExpenseTypeId = @ExpenseTypeId

	 
		 Delete from tbl_ExpenseTypeDetails where        ExpenseTypeId = @ExpenseTypeId
		 
    END


