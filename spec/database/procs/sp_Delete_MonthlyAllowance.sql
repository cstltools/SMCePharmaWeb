-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_MonthlyAllowance]
	-- Add the parameters for the stored procedure here
    @MonthlyAllowanceId INT = 0 
   
AS
    BEGIN

	Delete From tbl_MonthlyAllowance where MonthlyAllowanceId = @MonthlyAllowanceId
            
    END
