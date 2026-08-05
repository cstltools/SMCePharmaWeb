

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_EmployeeAllowance]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @Name    NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tbl_MonthlyAllowance WHERE MonthlyAllowanceName=@Name AND    MonthlyAllowanceId NOT IN ( @id)

END



