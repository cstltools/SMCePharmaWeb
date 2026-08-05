

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_ActiveInactive_Stationtype]
	-- Add the parameters for the stored procedure here
    @DeptId  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblStationType where StationTypeId =  @DeptId

	IF @Flag = 1
        UPDATE  [dbo].[tblStationType] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  StationTypeId = @DeptId    
    ElSE
	    UPDATE  [dbo].[tblStationType] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  StationTypeId = @DeptId   
    END


