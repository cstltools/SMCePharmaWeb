

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_ActiveInactive_Holiday]
	-- Add the parameters for the stored procedure here
    @HolidayId INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from Employee_GovtHolidays where HolidayId =  @HolidayId

	IF @Flag = 1
        UPDATE  [dbo].[Employee_GovtHolidays] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  HolidayId = @HolidayId    
    ElSE
	    UPDATE  [dbo].[Employee_GovtHolidays] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  HolidayId = @HolidayId   
    END

