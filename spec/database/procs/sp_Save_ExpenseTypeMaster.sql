
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ExpenseTypeMaster]
	-- Add the parameters for the stored procedure here
	@ExpenseTypeId INT,
	@RoleType_xp INT,
    @ExpenseTypeName NVARCHAR(500) =Null ,
    @RoleTypeMult NVARCHAR(max) =Null ,
    @EmpNameMult NVARCHAR(max) =Null ,
	 @ExpenseAmount decimal(18,2),
	@ImageRequired BIT =null,
		@isFixed BIT,
	@IsActive BIT =null,
    @EntryBy NVARCHAR(50) =null
AS
    BEGIN
	--if not exists (select ExpenseTypeName from [tbl_ExpenseTypeMaster] where  ExpenseTypeName=@ExpenseTypeName)

	declare @CountData int
SELECT @CountData=COUNT(*) from [tbl_ExpenseTypeMaster] where  ExpenseTypeName=@ExpenseTypeName

print @CountData
 IF(@CountData=0)
begin 
        INSERT  INTO [dbo].[tbl_ExpenseTypeMaster]
                ( ExpenseTypeName ,                
                  ImageRequired ,
                  IsActive ,
                  EntryBy ,
                  EntryDate , 	isFixed,ExpenseAmount, RoleType_xp, RoleTypeMult, EmpNameMult
	            )
        VALUES  ( @ExpenseTypeName ,              
                  @ImageRequired ,
                  @IsActive,
                  @EntryBy ,
                  GETDATE() 	, 	@isFixed,@ExpenseAmount,@RoleType_xp, @RoleTypeMult, @EmpNameMult
	            )

  SELECT SCOPE_IDENTITY()
End
else  Return 0
	
 
		
END

