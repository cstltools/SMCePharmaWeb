-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_EmployeeLeaveApplication]
	-- Add the parameters for the stored procedure here

			@EmployeeId INT
           ,@LeaveBalanceId INT
           ,@LeaveFromDate DATETIME
           ,@LeaveToDate DATETIME
           ,@Days INT
           ,@EntryBy INT
           ,@EntryDate DATETIME          

AS
BEGIN
	
	 

	INSERT INTO Employee_LeaveApplications
           (EmployeeId
           ,LeaveBalanceId
           ,LeaveFromDate
           ,LeaveToDate
           ,Days
           ,EntryBy
           ,EntryDate
           ,IsApproved)
     VALUES
           (@EmployeeId
           ,@LeaveBalanceId
           ,@LeaveFromDate
           ,@LeaveToDate
           ,@Days
           ,@EntryBy
           ,@EntryDate
           ,0)

	  SELECT SCOPE_IDENTITY()

END

