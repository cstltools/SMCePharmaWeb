-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Approve_EmployeeLeaveApplication]
	-- Add the parameters for the stored procedure here
	
			@LeaveApplicationId INT,
			@ApprovalStatus NVARCHAR(MAX),
            @ApproveBy NVARCHAR(MAX)
           ,@ApproveDate DATETIME          

AS
BEGIN
	
	 
	-- Approve 

	UPDATE Employee_LeaveApplications 
	SET ApprovalStatus = @ApprovalStatus , 
		ApproveBy = @ApproveBy,
		ApproveDate = @ApproveDate
	WHERE LeaveApplicationId = @LeaveApplicationId

	-- Insert into transcation table

	IF(@ApprovalStatus = 'Approved')
	BEGIN

		DECLARE @LeaveBalanceId INT
		DECLARE @Days INT
		        
		--------------------------------------------------------
		DECLARE @MyCursor CURSOR
		SET @MyCursor = CURSOR FAST_FORWARD
		FOR
		---------------
		
		SELECT LeaveBalanceId,Days FROM Employee_LeaveApplications 
		WHERE LeaveApplicationId = @LeaveApplicationId
			
		----------
		OPEN @MyCursor
		FETCH NEXT FROM @MyCursor
		INTO @LeaveBalanceId,@Days
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		
			INSERT INTO Employee_YearlyLeaveTranscations
		       (TranscationDate
		       ,LeaveApplicationId
		       ,LeaveDays
			   ,LeaveBalanceId)
			VALUES
		       (GETDATE(),
				@LeaveApplicationId,
		        @Days*-1,
			    @LeaveBalanceId)
		
		
		FETCH NEXT FROM @MyCursor
		INTO @LeaveBalanceId,@Days
		
		END
		CLOSE @MyCursor
		DEALLOCATE @MyCursor
		
	END
     

END

