-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_LeaveRecords]
	-- Add the parameters for the stored procedure here
    @empId INT, @year INT, @Month INT
AS
    BEGIN
			declare @params nvarchar(max)=''
			 IF(@Month IS NOT NULL)
		BEGIN
		    SET @params=@params+  ' and   month(A.LeaveFromDate) = '''+convert(nvarchar(max),@Month)+''''
		END
		

        	DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT format(A.entrydate, ''dd MMM yyyy'') CreatedAt,  A.LeaveApplicationId ,
                 C.LeaveConType LeaveTypeName ,
                CONVERT(NVARCHAR(50), A.LeaveFromDate, 106) AS LeaveFromDate ,
                CONVERT(NVARCHAR(50), A.LeaveToDate, 106) AS LeaveToDate ,
                A.Days ,
                A.Reason,
				ApprovalStatus
        FROM    dbo.Employee_LeaveApplications A (NOLOCK)
                INNER JOIN dbo.Employee_YearlyLeaveBalance B  (NOLOCK) ON B.LeaveBalanceId = A.LeaveBalanceId
               LEFT JOIN dbo.tblLeaveConType C  (NOLOCK) ON C.LeaveConTypeId = B.LeaveBalanceId
        WHERE   A.EmployeeId ='''+ convert(nvarchar(max),@empId)+'''
                AND YEAR(A.LeaveFromDate) ='''+ convert(nvarchar(max),@year)+ '''' +@params 

EXEC sys.sp_executesql @Q


    END

