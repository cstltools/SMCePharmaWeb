
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Leave_AppLog]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(maX)= NULL,
 
	@FromDt DATETIME ='',
	@ToDt DATETIME ='',
	@EmpId INT =NULL
AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)='  '


	 
		
	IF(@AppStatus IS NOT NULL)
	BEGIN
	   SET @params=@params+' and Employee_LeaveApplications.ApprovalStatus ='''+@AppStatus+''''
		 
		IF(@FromDt  <>'')
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,Employee_LeaveApplications.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
      
		IF(@FromDt  <>'' )
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,Employee_LeaveApplications.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END
 IF(@FromDt ='' )
		BEGIN

  SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,Employee_LeaveApplications.EntryDate),CONVERT(DATE,GETDATE())))<=7  '
  end
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND Employee_LeaveApplications.EmployeeId='+convert(nvarchar(max),@EmpId)+' '
	END

	--IF(@Role='DZSM')
	--BEGIN
	--    SET @params= @params + ' AND ( tblLeaveApprovalLog.ToRoleTypeId  is null or  tblLeaveApprovalLog.ToRoleTypeId=3)'
	--END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

		SELECT   C.LeaveConType LeaveTypeName ,(SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''LeaveMy'')+CAST(Employee_LeaveApplications.LeaveApplicationId as nvarchar(max))+''.jpg'' AS   ImageString, usr.RoleName, case when Employee_LeaveApplications.ApprovalStatus=''0'' then ''Pending''  when Employee_LeaveApplications.ApprovalStatus=''1'' then ''Verified'' when Employee_LeaveApplications.ApprovalStatus=''2'' then ''Approved'' when Employee_LeaveApplications.ApprovalStatus=''3'' then ''Rejected''  else Employee_LeaveApplications.ApprovalStatus end ApprovalStatusWeb, LeaveApplicationId,
       --Employee_LeaveApplications.MIOId,
       Employee_LeaveApplications.EmployeeId,
	   emp.EmpMasterCode,
       emp.EmpName   ,
     FORMAT(Employee_LeaveApplications.LeaveFromDate, ''MMMM dd, yyyy'') +'' To ''+FORMAT(Employee_LeaveApplications.LeaveToDate, ''MMMM dd, yyyy'')  LeaveFromDate,
       LeaveToDate,
	    
       FORMAT(Employee_LeaveApplications.EntryDate, ''MMMM dd, yyyy'') EntryDate,

       Days,
      
      Reason,
	    FORMAT(Employee_LeaveApplications.DateOfReturnsToDuty, ''MMMM dd, yyyy'')  DateOfReturnsToDuty,LeaveAddress,EmergencyContactNo,Employee_LeaveApplications.Remarks,
       Employee_LeaveApplications.ApprovalStatus,
       
       tblLeaveApprovalLog.LeaveApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblLeaveApprovalLog.TableId,
       tblLeaveApprovalLog.Status,
       tblLeaveApprovalLog.Comments,
      C.LeaveConType    Type,
       Step,
       tblLeaveApprovalLog.GroupId,
       tblLeaveApprovalLog.RegionId,
       tblLeaveApprovalLog.AreaId,
       tblLeaveApprovalLog.TerritoryId,
       
           tblLeaveApprovalLog.RoleTypeId,tblLeaveApprovalLog.ToRoleTypeId,
       
      
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 AreaName,
                                 RegionCode,
                                 RegionName,
                                 GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep
	   ,(SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''Leave'')AS ImagePreName 
	   
	   
	   FROM dbo.Employee_LeaveApplications

	     INNER JOIN dbo.Employee_YearlyLeaveBalance B ( NOLOCK ) ON B.LeaveBalanceId = Employee_LeaveApplications.LeaveBalanceId
		 INNER JOIN dbo.tblLeaveConType C ( NOLOCK ) ON C.LeaveConTypeId = B.LeaveTypeId
               
LEFT JOIN dbo.tblLeaveApprovalLog ON dbo.tblLeaveApprovalLog.TableId=dbo.Employee_LeaveApplications.LeaveApplicationId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblLeaveApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblLeaveApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = Employee_LeaveApplications.EmployeeId
 left JOIN dbo.tblUser us ON us.EmpInfoId = emp.EmpInfoId
 
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = us.UserRoleID
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = emp.EmpInfoId
left join (select TableId,RoleTypeId from tblLeaveApprovalLog  with (nolock) where Step=1) as tblrole on Employee_LeaveApplications.LeaveApplicationId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId

WHERE Employee_LeaveApplications.LeaveApplicationId is not null '+@params+'  AND  tblRoleType.RoleType<>'''+@Role+''' AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END





