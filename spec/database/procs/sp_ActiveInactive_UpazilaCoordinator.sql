


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_ActiveInactive_UpazilaCoordinator]
	-- Add the parameters for the stored procedure here
    @Id  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblUpazilaCoordinator where UpCoordinatorId =  @Id 

	IF @Flag = 1
        UPDATE  [dbo].[tblUpazilaCoordinator] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  UpCoordinatorId = @Id    
    ElSE
	    UPDATE  [dbo].[tblUpazilaCoordinator] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  UpCoordinatorId = @Id   
    END


