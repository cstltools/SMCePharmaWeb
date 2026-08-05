-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_AllLeaveRecords]
	-- Add the parameters for the stored procedure here
  	@Parameter NVARCHAR(MAX)
AS
    BEGIN
	
	 DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT usr.RoleName, (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''LeaveMy'')+CAST(A.LeaveApplicationId as nvarchar(max))+''.jpg'' AS   ImageString,(SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''Leave'')+CAST(A.LeaveApplicationId AS NVARCHAR(max))+''.jpg''AS ImagePreName, A.Remarks, A.EmergencyContactNo, A.LeaveAddress, format( A.DateOfReturnsToDuty, ''dd-MMM-yyyy'') AS DateOfReturnsToDuty , A.LeaveApplicationId ,
                C.LeaveConType LeaveTypeName ,
                format(  A.LeaveFromDate, ''dd-MMM-yyyy'') AS LeaveFromDate ,
               format(  A.LeaveToDate, ''dd-MMM-yyyy'') AS LeaveToDate ,
                A.Days ,
                A.Reason ,
             case when A.ApprovalStatus=''0'' then ''Pending''  when A.ApprovalStatus=''1'' then ''Verified'' when A.ApprovalStatus=''2'' then ''Approved'' when A.ApprovalStatus=''3'' then ''Rejected''  else A.ApprovalStatus end     ApprovalStatus ,
                emp.EmpMasterCode ,  emp.EmpName   AS EmpName ,
                SUM(yt.LeaveDays) AS YearlyLeaveBalance
        FROM    dbo.Employee_LeaveApplications A ( NOLOCK )
                INNER JOIN dbo.Employee_YearlyLeaveBalance B ( NOLOCK ) ON B.LeaveBalanceId = A.LeaveBalanceId
                INNER JOIN dbo.tblLeaveConType C ( NOLOCK ) ON C.LeaveConTypeId = B.LeaveTypeId
                INNER JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = A.EmployeeId
				    left JOIN dbo.tblUser us ON us.EmpInfoId = A.EmployeeId
					
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = us.UserRoleID
                LEFT JOIN dbo.Employee_YearlyLeaveTranscations yt ON yt.LeaveBalanceId = A.LeaveBalanceId where A.LeaveApplicationId is not null 
       ' + @Parameter+' 
        GROUP BY usr.RoleName, A.Remarks, A.EmergencyContactNo, A.LeaveAddress, A.DateOfReturnsToDuty, A.LeaveApplicationId ,
                C.LeaveConType ,
                A.LeaveFromDate ,
                A.LeaveToDate ,
                A.Days ,
                A.Reason ,
                ApprovalStatus ,
                emp.EmpMasterCode ,  emp.EmpName
        ORDER BY A.LeaveApplicationId DESC '

 EXEC(@Query)

 
END

