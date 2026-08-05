

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_MonthlyTarget]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @Year     NVARCHAR(MAX) ,
      @Month     NVARCHAR(MAX) 

AS
BEGIN
		 
	SELECT * FROM dbo.tblMonthlyTarget WHERE Year=@Year AND Month=@Month AND  MTargetId NOT IN ( @id)

END



