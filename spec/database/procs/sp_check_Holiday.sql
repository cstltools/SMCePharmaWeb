

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_Holiday]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @Name     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.Employee_GovtHolidays WHERE DayName=@Name AND  HolidayId NOT IN ( @id)

END



