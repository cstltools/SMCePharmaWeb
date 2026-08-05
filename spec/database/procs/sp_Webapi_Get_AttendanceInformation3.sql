
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_AttendanceInformation]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX) NULL,
	@Role NVARCHAR(max) NULL
AS
    BEGIN
	DECLARE @a NVARCHAR(MAX)=''
	DECLARE @b NVARCHAR(MAX)=''

	IF(@Role='1')
BEGIN
    SET @a=' 
	LEFT JOIN (SELECT M.TerritoryId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS MIOEmpId, M.MIOId
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON M.EmployeeId = EGI.EmpInfoId
                 WHERE (M.IsActive = 1)) AS MIO ON MIO.MIOEmpId=dbo.tblEmpGeneralInfo.EmpInfoId
LEFT JOIN dbo.tblTerritory ON tblTerritory.TerritoryId = MIO.TerritoryId
LEFT JOIN dbo.tblArea ARA ON ARA.AreaId = tblTerritory.AreaId
LEFT JOIN (SELECT AM.AreaId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS ASMEMPId
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON AM.EmployeeId = EGI.EmpInfoId
                 WHERE (AM.IsActive = 1)) AS ASM ON ARA.AreaId = ASM.AreaId
LEFT JOIN dbo.tblRegion RGN ON ARA.RegionId=RGN.RegionId

--LEFT JOIN dbo.tblRegion RGN ON RGN.RegionId=ARA.RegionId
LEFT JOIN (SELECT RM.RegionId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS RSMEMPId
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON RM.EmployeeId = EGI.EmpInfoId
                 WHERE (RM.IsActive = 1)) AS RSM ON RGN.RegionId = RSM.RegionId

LEFT JOIN dbo.tbl_Group GP ON GP.GroupId=RGN.GroupId
LEFT JOIN (SELECT N.GroupId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS NSMEMPId
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON N.EmployeeId = EGI.EmpInfoId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.GroupId = GP.GroupId

	
	 '
	SET @b=' ,MIO.TerritoryId,
       MIO.EmpMasterCode AS  MIOEmpCode,
       MIO.EmpName AS MIOEmpName,
       MIO.MIOEmpId,
       TerritoryName,
       TerritoryCode,
       
       ARA.AreaCode,
       ARA.AreaName,
       ARA.AreaId,
       
       
       ASM.EmpMasterCode AS ASMEmpCode,
       ASM.EmpName AS ASMEmpName,
       ASM.ASMEMPId,
       RGN.RegionId,
       RGN.RegionCode,
       RGN.RegionName,
       
      RSM.EmpMasterCode AS RSMEmpCode,
       RSM.EmpName AS RSMEmpName,
       RSM.RSMEMPId,
       GP.GroupId,
       GP.GroupName,
       
       GP.GroupCode,
       
       NSM.EmpMasterCode AS NSMEmpCode,
       NSM.EmpName AS NSMEmpName,
       NSM.NSMEMPId '
END
IF(@Role='2')
BEGIN
SET @a=' 
LEFT JOIN (SELECT AM.AreaId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS ASMEMPId
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON AM.EmployeeId = EGI.EmpInfoId
                 WHERE (AM.IsActive = 1)) AS ASM ON ASM.ASMEMPId = dbo.tblEmpGeneralInfo.EmpInfoId
LEFT JOIN dbo.tblArea ARA ON ARA.AreaId = ASM.AreaId
LEFT JOIN dbo.tblRegion RGN ON ARA.RegionId=RGN.RegionId

--LEFT JOIN dbo.tblRegion RGN ON RGN.RegionId=ARA.RegionId
LEFT JOIN (SELECT RM.RegionId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS RSMEMPId
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON RM.EmployeeId = EGI.EmpInfoId
                 WHERE (RM.IsActive = 1)) AS RSM ON RGN.RegionId = RSM.RegionId

LEFT JOIN dbo.tbl_Group GP ON GP.GroupId=RGN.GroupId
LEFT JOIN (SELECT N.GroupId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS NSMEMPId
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON N.EmployeeId = EGI.EmpInfoId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.GroupId = GP.GroupId


 '
SET @b=' ,
       ''0'' as TerritoryId,
       ''0'' AS  MIOEmpCode,
       ''0'' AS MIOEmpName,
       ''0'' as MIOEmpId,
       ''0'' TerritoryName,
       ''0'' TerritoryCode,


       ARA.AreaCode,
       ARA.AreaName,
       ARA.AreaId,
       
       
       ASM.EmpMasterCode AS ASMEmpCode,
       ASM.EmpName AS ASMEmpName,
       ASM.ASMEMPId,
       RGN.RegionId,
       RGN.RegionCode,
       RGN.RegionName,
       
      RSM.EmpMasterCode AS RSMEmpCode,
       RSM.EmpName AS RSMEmpName,
       RSM.RSMEMPId,
       GP.GroupId,
       GP.GroupName,
       
       GP.GroupCode,
       
       NSM.EmpMasterCode AS NSMEmpCode,
       NSM.EmpName AS NSMEmpName,
       NSM.NSMEMPId '
END
IF(@Role='3')
BEGIN
 SET @a=' LEFT JOIN (SELECT RM.RegionId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS RSMEMPId
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON RM.EmployeeId = EGI.EmpInfoId
                 WHERE (RM.IsActive = 1)) AS RSM ON dbo.tblEmpGeneralInfo.EmpInfoId = RSM.RSMEMPId
LEFT JOIN dbo.tblRegion RGN ON RSM.RegionId=RGN.RegionId
LEFT JOIN dbo.tbl_Group GP ON GP.GroupId=RGN.GroupId
LEFT JOIN (SELECT N.GroupId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS NSMEMPId
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON N.EmployeeId = EGI.EmpInfoId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.GroupId = GP.GroupId
 '
 SET @b=' ,

 ''0'' as TerritoryId,
       ''0'' AS  MIOEmpCode,
       ''0'' AS MIOEmpName,
       ''0'' as MIOEmpId,
       ''0'' TerritoryName,
       ''0'' TerritoryCode,


       ''0'' AreaCode,
       ''0''AreaName,
       ''0''AreaId,
       
       
       ''0'' AS ASMEmpCode,
       ''0'' AS ASMEmpName,
       ''0'' ASMEMPId,

       RGN.RegionId,
       RGN.RegionCode,
       RGN.RegionName,
       
      RSM.EmpMasterCode AS RSMEmpCode,
       RSM.EmpName AS RSMEmpName,
       RSM.RSMEMPId,
       GP.GroupId,
       GP.GroupName,
       
       GP.GroupCode,
       
       NSM.EmpMasterCode AS NSMEmpCode,
       NSM.EmpName AS NSMEmpName,
       NSM.NSMEMPId '
END
IF(@Role='4')
BEGIN
    SET @a=' LEFT JOIN (SELECT N.GroupId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS NSMEMPId
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON N.EmployeeId = EGI.EmpInfoId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.NSMEMPId = dbo.tblEmpGeneralInfo.EmpInfoId
LEFT JOIN dbo.tbl_Group GP ON GP.GroupId=NSM.GroupId
 '
	SET @b= '  ,
	''0'' as TerritoryId,
       ''0'' AS  MIOEmpCode,
       ''0'' AS MIOEmpName,
       ''0'' as MIOEmpId,
       ''0'' TerritoryName,
       ''0'' TerritoryCode,


       ''0'' AreaCode,
       ''0''AreaName,
       ''0''AreaId,
       
       
       ''0'' AS ASMEmpCode,
       ''0'' AS ASMEmpName,
       ''0'' ASMEMPId,

       ''0'' RegionId,
       ''0'' RegionCode,
       ''0'' RegionName,
	
	GP.GroupId,
       GP.GroupName,
       
       GP.GroupCode,
       
       NSM.EmpMasterCode AS NSMEmpCode,
       NSM.EmpName AS NSMEmpName,
       NSM.NSMEMPId '
END


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
       
       tblApprovalLog.ApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       TableId,
       tblApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblApprovalLog.GroupId,
       tblApprovalLog.RegionId,
       tblApprovalLog.AreaId,
       tblApprovalLog.TerritoryId,
       
       RoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName
	   ,(SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''Attendance'')AS ImagePreName 
	   '+@b+'
	   
	   FROM dbo.tblMarketAttendance_Master_webapi
LEFT JOIN dbo.tblApprovalLog ON dbo.tblApprovalLog.TableId=dbo.tblMarketAttendance_Master_webapi.AttendanceId
LEFT JOIN (SELECT ApprovalId,MAX(Step)MaxStep FROM dbo.tblApprovalLog WHERE Status NOT IN (''Accepted'',''Reject'') GROUP BY ApprovalId) AS LogMax ON LogMax.ApprovalId=dbo.tblApprovalLog.ApprovalId
LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblMarketAttendance_Master_webapi.EmpInfoId
'+@a+'

WHERE tblApprovalLog.Status NOT IN (''Accepted'',''Reject'')  AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END


