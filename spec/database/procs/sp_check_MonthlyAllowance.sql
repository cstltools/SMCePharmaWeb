
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_MonthlyAllowance]
	-- Add the parameters for the stored procedure here
	  @MonthlyAllowanceId INT = 0 ,
    @MonthlyAllowanceName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tbl_MonthlyAllowance WHERE MonthlyAllowanceName=@MonthlyAllowanceName AND    MonthlyAllowanceId NOT IN ( @MonthlyAllowanceId)

END


