
CREATE VIEW [dbo].[View_FieldForceNsm]
AS
SELECT        NSM.NSMId, NSM.GroupId, NSM.EmpMasterCode, NSM.EmpName, NSM.EmpMasterCode AS NSMCode, RSM.EmpMasterCode AS RSMCode, ASM.EmpMasterCode AS ASMCode, MIO.EmpMasterCode AS MIOCode, 
                         NSM.EmpInfoId AS NSMEmpId, RSM.EmpInfoId AS RSMEmpId, ASM.EmpInfoId AS ASMEmpId, MIO.EmpInfoId AS MIOEmpId
FROM            dbo.tbl_Group AS GP LEFT OUTER JOIN
                         dbo.tblRegion AS RGN ON GP.GroupId = RGN.GroupId LEFT OUTER JOIN
                         dbo.tblArea AS ARA ON RGN.RegionId = ARA.RegionId LEFT OUTER JOIN
                         dbo.tblTerritory AS TTR ON ARA.AreaId = TTR.AreaId LEFT OUTER JOIN
                         dbo.tblSubTerritory AS STTR ON TTR.TerritoryId = STTR.TerritoryId LEFT OUTER JOIN
                         dbo.tblMarket AS MKT ON STTR.SubTerritoryId = MKT.SubTerritoryId LEFT OUTER JOIN
                             ( SELECT        N.NSMId, N.GroupId, EGI.EmpMasterCode, EGI.EmpName, urR.RoleName EmpRole, EGI.EmpInfoId
                               FROM            dbo.tblNSMInfo AS N 
							   LEFT OUTER JOIN  dbo.tblEmpGeneralInfo AS EGI ON N.EmployeeId = EGI.EmpInfoId
							    LEFT   JOIN  dbo.tblUser AS ur ON ur.EmpInfoId = EGI.EmpInfoId
							    LEFT   JOIN dbo.tbl_UserRoleInfo AS urR ON urR.UserRoleID = ur.UserRoleID 
                               WHERE        (N.IsActive = 1)) AS NSM ON NSM.GroupId = GP.GroupId LEFT OUTER JOIN
                             (
							   SELECT        RM.RSMId, RM.RegionId, EGI.EmpMasterCode, EGI.EmpName, urR.RoleName EmpRole, EGI.EmpInfoId
                               FROM            dbo.tblRSMInfo AS RM 
							   LEFT OUTER JOIN   dbo.tblEmpGeneralInfo AS EGI ON RM.EmployeeId = EGI.EmpInfoId
							      LEFT   JOIN  dbo.tblUser AS ur ON ur.EmpInfoId = EGI.EmpInfoId
							    LEFT   JOIN dbo.tbl_UserRoleInfo AS urR ON urR.UserRoleID = ur.UserRoleID 
                               WHERE        (RM.IsActive = 1)) AS RSM ON RGN.RegionId = RSM.RegionId LEFT OUTER JOIN
                             (  SELECT        AM.ASMId, AM.AreaId, EGI.EmpMasterCode, EGI.EmpName,  urR.RoleName EmpRole, EGI.EmpInfoId
                               FROM            dbo.tblASMInfo AS AM
							    LEFT OUTER JOIN dbo.tblEmpGeneralInfo AS EGI ON AM.EmployeeId = EGI.EmpInfoId
								 LEFT   JOIN  dbo.tblUser AS ur ON ur.EmpInfoId = EGI.EmpInfoId
							    LEFT   JOIN dbo.tbl_UserRoleInfo AS urR ON urR.UserRoleID = ur.UserRoleID 
                               WHERE        (AM.IsActive = 1)) AS ASM ON ARA.AreaId = ASM.AreaId LEFT OUTER JOIN
                             (
							   SELECT        M.MIOId, M.TerritoryId, EGI.EmpMasterCode, EGI.EmpName, urR.RoleName EmpRole, EGI.EmpInfoId
                               FROM            dbo.tblMIOInfo AS M 
							   LEFT OUTER JOIN  dbo.tblEmpGeneralInfo AS EGI ON M.EmployeeId = EGI.EmpInfoId
						  LEFT   JOIN  dbo.tblUser AS ur ON ur.EmpInfoId = EGI.EmpInfoId
							    LEFT   JOIN dbo.tbl_UserRoleInfo AS urR ON urR.UserRoleID = ur.UserRoleID 
                               WHERE        (M.IsActive = 1)) AS MIO ON TTR.TerritoryId = MIO.TerritoryId
WHERE        (GP.IsActive = 1)

