


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_ActiveInactive_DistrictCoordinator]
	-- Add the parameters for the stored procedure here
    @Id  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblDistrictCoordinator where DistCoordinatorId =  @Id 

	IF @Flag = 1
        UPDATE  [dbo].[tblDistrictCoordinator] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  DistCoordinatorId = @Id    
    ElSE
	    UPDATE  [dbo].[tblDistrictCoordinator] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  DistCoordinatorId = @Id   
    END


