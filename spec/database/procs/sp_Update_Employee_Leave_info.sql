


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Update_Employee_Leave_info]
	-- Add the parameters for the stored procedure here
@LeaveTypeId INT,
    @LeaveTypeName NVARCHAR(500) =null,
	@LeaveDays INT =null,
	@IsActive BIT = null,
	@UpdateBy INT

AS
    BEGIN
        UPDATE  [dbo].[Employe_LeaveTypeInfos]
        SET     LeaveTypeName= @LeaveTypeName,
		        LeaveDays = @LeaveDays,
				IsActive = @IsActive,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE()
                     
        WHERE   LeaveTypeId = @LeaveTypeId   

    END



