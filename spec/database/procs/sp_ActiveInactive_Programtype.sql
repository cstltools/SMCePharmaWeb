

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_ActiveInactive_Programtype]
	-- Add the parameters for the stored procedure here
    @DeptId  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblProgramType where ProgramTypeId =  @DeptId

	IF @Flag = 1
        UPDATE  [dbo].[tblProgramType] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  ProgramTypeId = @DeptId    
    ElSE
	    UPDATE  [dbo].[tblProgramType] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  ProgramTypeId = @DeptId   
    END


