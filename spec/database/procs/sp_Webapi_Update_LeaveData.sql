-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_LeaveData]
	-- Add the parameters for the stored procedure here
    @id INT ,
    @approvalType NVARCHAR(MAX) ,
    @empId INT
AS
    BEGIN
	
       -- Approve 

	UPDATE Employee_LeaveApplications 
	SET ApprovalStatus = @approvalType , 
		ApproveBy = @empId,
		ApproveDate = GetDate()
	WHERE LeaveApplicationId = @id

	-- Insert into transcation table

	IF(@approvalType = 'Approved')
	BEGIN

		DECLARE @LeaveBalanceId INT
		DECLARE @Days INT
		        
		--------------------------------------------------------
		DECLARE @MyCursor CURSOR
		SET @MyCursor = CURSOR FAST_FORWARD
		FOR
		---------------
		
		SELECT LeaveBalanceId,Days FROM Employee_LeaveApplications 
		WHERE LeaveApplicationId = @id
			
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
				@id,
		        @Days*-1,
			    @LeaveBalanceId)
		
		
		FETCH NEXT FROM @MyCursor
		INTO @LeaveBalanceId,@Days
		
		END
		CLOSE @MyCursor
		DEALLOCATE @MyCursor
		
	END


    END

