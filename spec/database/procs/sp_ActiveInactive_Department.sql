CREATE PROCEDURE [dbo].[sp_ActiveInactive_Department]
	-- Add the parameters for the stored procedure here
    @DeptId  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblDepartment where DeptId =  @DeptId

	IF @Flag = 1
        UPDATE  [dbo].[tblDepartment] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  DeptId = @DeptId    
    ElSE
	    UPDATE  [dbo].[tblDepartment] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  DeptId = @DeptId   
    END


