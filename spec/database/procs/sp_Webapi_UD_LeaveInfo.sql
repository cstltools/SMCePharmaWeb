
create PROCEDURE [dbo].[sp_Webapi_UD_LeaveInfo]
	-- Add the parameters for the stored procedure here
      @leaveAppId INT  ,
    @typeId INT = NULL ,
    @startDate DATETIME = NULL ,
    @endDate DATETIME = NULL ,
    @reason NVARCHAR(MAX) = NULL ,
    @empId INT = NULL,
    @DateOfReturnsToDuty DATETIME = NULL ,
    @LeaveAddress NVARCHAR(MAX) = NULL ,
    @EmergencyContactNo NVARCHAR(MAX) = NULL ,
    @Comments NVARCHAR(MAX) = NULL  
AS
    BEGIN

	  DECLARE @totalDays INT ,
            @userId INT ,
            @appStatus NVARCHAR(50)

			   SELECT  @userId = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId
	   SELECT  @totalDays = ( DATEDIFF(DAY, @startDate, @endDate) + 1 )
	  UPDATE  dbo.Employee_LeaveApplications
                SET     LeaveBalanceId = @typeId ,
                        LeaveFromDate = @startDate ,
                        LeaveToDate = @endDate ,
                        Days = @totalDays ,
                        UpdateBy = @userId ,
                        UpdateDate = GETDATE(),
						Reason = @reason,DateOfReturnsToDuty=@DateOfReturnsToDuty,LeaveAddress=@LeaveAddress,  EmergencyContactNo=@EmergencyContactNo, Comments=@Comments
                WHERE   LeaveApplicationId = @leaveAppId

 END
