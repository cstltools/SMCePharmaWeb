
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorPendingReject]
	-- Add the parameters for the stored procedure here
    @empid INT ,
    @ApprovalStatus nvarchar(max) 

    
AS
    BEGIN
	


	SELECT distinct FORMAT(tblDoctorMaster.EntryDate, 'MMM dd, yyyy hh:mm tt') createdAt, tblDoctorMaster.DoctorName as DoctorCode,M.MarketName,(CASE WHEN ApprovalStatus='0' THEN 'Pending'  WHEN ApprovalStatus='1' THEN 'Verified' WHEN ApprovalStatus='2' THEN 'Approved' WHEN ApprovalStatus='3' THEN 'Rejected' ELSE ApprovalStatus END)AS ActionStatus,ISNULL(RoleType,'-') AS WaitingRole,'_' AS WatingEmployee FROM dbo.tblDoctorMaster with (nolock)
	LEFT JOIN dbo.tblUser  with (nolock) ON dbo.tblUser.UserId=dbo.tblDoctorMaster.EntryBy
	---LEFT JOIN dbo.tblMarket  with (nolock) ON dbo.tblDoctorMaster.MarketId=dbo.tblMarket.MarketId
	LEFT JOIN dbo.tblDoctorApprovalLog_New  with (nolock) ON dbo.tblDoctorApprovalLog_New.TableId=dbo.tblDoctorMaster.DoctorId
	LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDoctorApprovalLog_New  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDoctorMaster.DoctorId
	LEFT JOIN dbo.tblRoleType  with (nolock) ON tblRoleType.RoleTypeId = tblDoctorApprovalLog_New.ToRoleTypeId
	---LEFT JOIN dbo.View_DoctorMaster CV  with (nolock) ON CV.DoctorId=dbo.tblDoctorMaster.DoctorId
	LEFT JOIN dbo.tblMarket AS M    with (nolock)  ON M.MarketId = REPLACE(tblDoctorMaster.MarketId, ' ', '') AND M.IsActive = 1 INNER JOIN
             dbo.tblSubTerritory AS ST    with (nolock)  ON ST.SubTerritoryId = M.SubTerritoryId AND ST.IsActive = 1 INNER JOIN
             dbo.tblTerritory AS T    with (nolock)  ON T .TerritoryId = ST.TerritoryId AND T .IsActive = 1 INNER JOIN
             dbo.tblArea AS A    with (nolock)  ON A.AreaId = REPLACE(T .AreaId, ' ', '') AND A.IsActive = 1 INNER JOIN
             dbo.tblRegion AS R    with (nolock)  ON R.RegionId = REPLACE(A.RegionId, ' ', '') AND R.IsActive = 1 INNER JOIN
             dbo.tbl_Group AS G    with (nolock)  ON G.GroupId = R.GroupId AND G.IsActive = 1 LEFT OUTER JOIN
             dbo.tblMIOInfo AS MIO    with (nolock)  ON MIO.TerritoryId = T .TerritoryId AND MIO.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EMIO    with (nolock)  ON MIO.EmployeeId = EMIO.EmpInfoId LEFT OUTER JOIN
             dbo.tblASMInfo AS ASM    with (nolock)  ON ASM.AreaId = A.AreaId AND ASM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EASM    with (nolock)  ON EASM.EmpInfoId = ASM.EmployeeId LEFT OUTER JOIN
             dbo.tblRSMInfo AS RSM    with (nolock)  ON RSM.RegionId = R.RegionId AND RSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ERSM    with (nolock)  ON ERSM.EmpInfoId = RSM.EmployeeId LEFT OUTER JOIN
             dbo.tblNSMInfo AS NSM    with (nolock)  ON NSM.GroupId = G.GroupId AND NSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo  AS ENSM    with (nolock)  ON ENSM.EmpInfoId = NSM.EmployeeId



	WHERE dbo.tblDoctorMaster.ApprovalStatus=@ApprovalStatus  AND Step=LogMax.MaxStep
	AND (NSM.EmployeeId=@empid OR RSM.EmployeeId=@empid OR ASM.EmployeeId=@empid OR MIO.EmployeeId=@empid)

	union all 

	SELECT  FORMAT(tblDoctorMaster.EntryDate, 'MMM dd, yyyy hh:mm tt') createdAt, tblDoctorMaster.DoctorName as DoctorCode,M.MarketName,(CASE WHEN ApprovalStatus='0' THEN 'Pending'  WHEN ApprovalStatus='1' THEN 'Verified' WHEN ApprovalStatus='2' THEN 'Approved' WHEN ApprovalStatus='3' THEN 'Rejected' ELSE ApprovalStatus END)AS ActionStatus,'_' AS WaitingRole,'_' AS WatingEmployee FROM dbo.tblDoctorMaster  with (nolock)
	LEFT JOIN dbo.tblUser  with (nolock) ON dbo.tblUser.UserId=dbo.tblDoctorMaster.EntryBy
	---LEFT JOIN dbo.tblMarket  with (nolock) ON dbo.tblDoctorMaster.MarketId=dbo.tblMarket.MarketId
	LEFT JOIN dbo.tblMarket AS M    with (nolock)  ON M.MarketId = REPLACE(tblDoctorMaster.MarketId, ' ', '') AND M.IsActive = 1 INNER JOIN
             dbo.tblSubTerritory AS ST    with (nolock)  ON ST.SubTerritoryId = M.SubTerritoryId AND ST.IsActive = 1 INNER JOIN
             dbo.tblTerritory AS T    with (nolock)  ON T .TerritoryId = ST.TerritoryId AND T .IsActive = 1 INNER JOIN
             dbo.tblArea AS A    with (nolock)  ON A.AreaId = REPLACE(T .AreaId, ' ', '') AND A.IsActive = 1 INNER JOIN
             dbo.tblRegion AS R    with (nolock)  ON R.RegionId = REPLACE(A.RegionId, ' ', '') AND R.IsActive = 1 INNER JOIN
             dbo.tbl_Group AS G    with (nolock)  ON G.GroupId = R.GroupId AND G.IsActive = 1 LEFT OUTER JOIN
             dbo.tblMIOInfo AS MIO    with (nolock)  ON MIO.TerritoryId = T .TerritoryId AND MIO.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EMIO    with (nolock)  ON MIO.EmployeeId = EMIO.EmpInfoId LEFT OUTER JOIN
             dbo.tblASMInfo AS ASM    with (nolock)  ON ASM.AreaId = A.AreaId AND ASM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EASM    with (nolock)  ON EASM.EmpInfoId = ASM.EmployeeId LEFT OUTER JOIN
             dbo.tblRSMInfo AS RSM    with (nolock)  ON RSM.RegionId = R.RegionId AND RSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ERSM    with (nolock) ON ERSM.EmpInfoId = RSM.EmployeeId LEFT OUTER JOIN
             dbo.tblNSMInfo AS NSM   with (nolock)  ON NSM.GroupId = G.GroupId AND NSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ENSM    with (nolock)  ON ENSM.EmpInfoId = NSM.EmployeeId
	--LEFT JOIN dbo.tblDoctorApprovalLog_New ON dbo.tblDoctorApprovalLog_New.TableId=dbo.tblDoctorMaster.DoctorId
	--LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDoctorApprovalLog_New  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDoctorMaster.DoctorId
	--LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tblDoctorApprovalLog_New.ToRoleTypeId
	--LEFT JOIN dbo.View_DoctorMaster CV  with (nolock) ON CV.DoctorId=dbo.tblDoctorMaster.DoctorId
	WHERE dbo.tblDoctorMaster.ApprovalStatus=@ApprovalStatus  
	AND (NSM.EmployeeId=@empid OR RSM.EmployeeId=@empid OR ASM.EmployeeId=@empid OR MIO.EmployeeId=@empid)



    END

