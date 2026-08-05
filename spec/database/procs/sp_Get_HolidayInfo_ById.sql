


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_HolidayInfo_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

	Select * from Employee_GovtHolidays where HolidayId = @id
	
    END

