

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_AttendanceInformation]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX) NULL,
	@Role NVARCHAR(MAX) NULL
AS
    BEGIN
	


	DECLARE @Q NVARCHAR(MAX)=''
	SET @Q='

	SELECT AttendanceId,
       tblMarketAttendance_Master_webapi.MIOId,
       tblMarketAttendance_Master_webapi.EmpInfoId,
       PunchInTime,
       PInLat,
       PInLog,
       PunchOutTime,
       POutLat,
       POutLong,
       tblMarketAttendance_Master_webapi.EntryDate,
       POutRemarks,
       AttendanceDate,
       PINCreatedDateTime,
       POUTCreatedDateTime,
       tblMarketAttendance_Master_webapi.Status,
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
       
       RoleTypeId,ToRoleTypeId,
       
       
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
	   ,(SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''PaymentCollectionLink'')AS ImageLinkshow 
	   
	   
	   FROM dbo.tblMarketAttendance_Master_webapi
LEFT JOIN dbo.tblApprovalLog ON dbo.tblApprovalLog.TableId=dbo.tblMarketAttendance_Master_webapi.AttendanceId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblMarketAttendance_Master_webapi.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId

WHERE tblApprovalLog.Status NOT IN (''Accepted'',''Reject'')  AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END



