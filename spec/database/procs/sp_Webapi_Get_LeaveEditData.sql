-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_LeaveEditData]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
		
        SELECT  LeaveApplicationId ,
                EmployeeId ,
                LeaveBalanceId ,
                CONVERT(NVARCHAR(50), LeaveFromDate, 106) AS LeaveFromDate ,
                CONVERT(NVARCHAR(50), LeaveToDate, 106) AS LeaveToDate ,
                Days ,
                EntryBy ,
                EntryDate
        FROM    dbo.Employee_LeaveApplications
        WHERE   LeaveApplicationId = @id


    END

