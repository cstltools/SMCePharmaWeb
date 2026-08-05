







CREATE VIEW [dbo].[View_Webapi_EmployeeFieldForceInfo_Top1]
AS
SELECT   dbo.tblEmpGeneralInfo.EmpInfoId, dbo.tblEmpGeneralInfo.EmpMasterCode, dbo.tblEmpGeneralInfo.EmpName AS EmpRole, dbo.tblMIOInfo.TerritoryId, dbo.tblASMInfo.AreaId, dbo.tblRSMInfo.RegionId, dbo.tblNSMInfo.GroupId, dbo.tblTerritory.TerritoryId AS EmpTerrId, 
             dbo.tblTerritory.TerritoryName, dbo.tblTerritory.TerritoryCode, dbo.tblArea.AreaCode, dbo.tblArea.AreaName, dbo.tblArea.AreaId AS EmpAreaId, dbo.tblRegion.RegionId AS EmpRegionId, dbo.tblRegion.RegionCode, dbo.tblRegion.RegionName, 
             dbo.tbl_Group.GroupId AS EmpGroupId, dbo.tbl_Group.GroupName, tbl_Group.GroupCode, MIO.MIOEmpId, ASM.ASMEMPId, RSM.RSMEMPId, NSM.NSMEMPId
FROM   dbo.tblEmpGeneralInfo   with (nolock)  LEFT OUTER JOIN
             dbo.tblMIOInfo   with (nolock)  ON  dbo.tblMIOInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId  
			-- and tblMIOInfo.isactive=1 
			    LEFT OUTER JOIN
             dbo.tblASMInfo   with (nolock)  ON dbo.tblASMInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId   and tblASMInfo.IsBaseAM=1  LEFT OUTER JOIN
             dbo.tblRSMInfo   with (nolock)  ON dbo.tblRSMInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId   and tblRSMInfo.IsBase=1  LEFT OUTER JOIN
             dbo.tblNSMInfo   with (nolock)  ON dbo.tblNSMInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId AND dbo.tblNSMInfo.IsActive = 1 LEFT OUTER JOIN
             dbo.tblTerritory   with (nolock)  ON dbo.tblTerritory.TerritoryId = dbo.tblMIOInfo.TerritoryId and tblTerritory.IsActive=1  LEFT OUTER JOIN
             dbo.tblArea   with (nolock)  ON dbo.tblArea.AreaId = dbo.tblASMInfo.AreaId OR dbo.tblArea.AreaId = dbo.tblTerritory.AreaId  and tblArea.IsActive=1   LEFT OUTER JOIN
             dbo.tblRegion   with (nolock)  ON dbo.tblRegion.RegionId = dbo.tblArea.RegionId    and tblArea.IsActive=1   LEFT OUTER JOIN
             dbo.tbl_Group   with (nolock)  ON dbo.tbl_Group.GroupId = dbo.tblNSMInfo.GroupId OR dbo.tbl_Group.GroupId = dbo.tblRegion.GroupId LEFT OUTER JOIN
                 (SELECT M.TerritoryId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS MIOEmpId, M.MIOId
                 FROM    dbo.tblMIOInfo AS M   with (nolock)  LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI   with (nolock)  ON M.EmployeeId = EGI.EmpInfoId
                 WHERE (M.IsActive = 1)) AS MIO ON MIO.MIOId = dbo.tblMIOInfo.MIOId LEFT OUTER JOIN
                 (SELECT AM.AreaId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS ASMEMPId
                 FROM    dbo.tblASMInfo AS AM   with (nolock)  LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI   with (nolock)  ON AM.EmployeeId = EGI.EmpInfoId
                 WHERE  AM.IsBaseAM=1) AS ASM ON ASM.AreaId = dbo.tblArea.AreaId LEFT OUTER JOIN
                 (SELECT RM.RegionId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS RSMEMPId
                 FROM    dbo.tblRSMInfo AS RM   with (nolock)  LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI   with (nolock)  ON RM.EmployeeId = EGI.EmpInfoId
                 WHERE  RM.IsBase=1) AS RSM ON RSM.RegionId = dbo.tblRegion.RegionId LEFT OUTER JOIN
                 (SELECT N.GroupId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS NSMEMPId
                 FROM    dbo.tblNSMInfo AS N    with (nolock) LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI   with (nolock)  ON N.EmployeeId = EGI.EmpInfoId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.GroupId = dbo.tbl_Group.GroupId
				  
				 





