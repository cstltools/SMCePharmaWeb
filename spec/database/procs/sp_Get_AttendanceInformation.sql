
CREATE PROCEDURE [dbo].[sp_Get_AttendanceInformation]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(maX)= NULL,
	@AttType INT =NULL,
	@FromDt DATETIME =NULL,
	@ToDt DATETIME =NULL,
	@EmpId INT =NULL
AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)='   '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' and tblMarketAttendance_Master_webapi.ApprovalStatus ='''+@AppStatus+''''
	IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tblMarketAttendance_Master_webapi.AttendanceDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tblMarketAttendance_Master_webapi.AttendanceDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tblMarketAttendance_Master_webapi.AttendanceDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tblMarketAttendance_Master_webapi.AttendanceDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END
	IF(@AttType IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tblMarketAttendance_Master_webapi.AttType='+convert(nvarchar(max),@AttType)+' '
	END
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tblMarketAttendance_Master_webapi.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END



	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	SELECT  usr.RoleName, dgs.DesigName, RT.RoleType  WaitingForRole,   case when tblMarketAttendance_Master_webapi.ApprovalStatus=''0'' then ''Pending''  when tblMarketAttendance_Master_webapi.ApprovalStatus=''1'' then ''Verified''  when tblMarketAttendance_Master_webapi.ApprovalStatus=''2'' then ''Approved''  WHEN tblMarketAttendance_Master_webapi.ApprovalStatus=''3'' then ''Rejected''  else tblMarketAttendance_Master_webapi.ApprovalStatus end ApprovalStatusWeb,tblMarketAttendance_Master_webapi.AttAddress, AttendanceId,
       --tblMarketAttendance_Master_webapi.MIOId,
       tblMarketAttendance_Master_webapi.EmpInfoId,
       PunchInTime,
       PInLat+'',''+
       PInLog latlong,
       --PunchOutTime,
       --POutLat,
       --POutLong,
       --tblMarketAttendance_Master_webapi.EntryDate,
       POutRemarks,
       format(AttendanceDate, ''dd-MMM-yyyy'') AttendanceDate,
       PINCreatedDateTime,
       POUTCreatedDateTime,
       tblMarketAttendance_Master_webapi.ApprovalStatus,
       tblMarketAttendance_Master_webapi.ShiftId,
	   tblMarketAttendance_Master_webapi.AttType,
       
       tblApprovalLog.ApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblApprovalLog.TableId,
       tblApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblApprovalLog.GroupId,
       tblApprovalLog.RegionId,
       tblApprovalLog.AreaId,
       tblApprovalLog.TerritoryId,
       
       tblApprovalLog.RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName,
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
	   ,(SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''AttendanceMy'')+CAST(tblMarketAttendance_Master_webapi.AttendanceId as nvarchar(max))+''.jpg'' AS   ImageString 
	   
	   
	   FROM dbo.tblMarketAttendance_Master_webapi with (nolock)

	   
	
LEFT JOIN dbo.tblApprovalLog  with (nolock) ON dbo.tblApprovalLog.TableId=dbo.tblMarketAttendance_Master_webapi.AttendanceId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblApprovalLog  with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblMarketAttendance_Master_webapi.EmpInfoId


 LEFT JOIN dbo.tblUser us ON tblEmpGeneralInfo.EmpInfoId=us.EmpInfoId
		  left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
		  left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = tblEmpGeneralInfo.DesignationId
	
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join (select TableId,RoleTypeId from tblApprovalLog  with (nolock) where Step=1) as tblrole on tblMarketAttendance_Master_webapi.AttendanceId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
LEFT JOIN dbo.tblRoleType RT ON RT.RoleTypeId = tblApprovalLog.ToRoleTypeId
WHERE tblMarketAttendance_Master_webapi.AttendanceId is not null AND   tblRoleType.RoleType<>'''+@Role+'''  '+@params+'  AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END


