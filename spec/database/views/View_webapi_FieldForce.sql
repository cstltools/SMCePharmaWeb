CREATE VIEW dbo.View_webapi_FieldForce
AS
SELECT GP.GroupId, GP.GroupCode, GP.GroupName, NSM.EmpName AS NSMName, NSM.EmpMasterCode AS NSMCode, RGN.RegionId, RGN.RegionCode, RGN.RegionName, RSM.EmpName AS RSMName, RSM.EmpMasterCode AS RSMCode, ARA.AreaId, ARA.AreaCode, ARA.AreaName, 
             ASM.EmpName AS ASMName, ASM.EmpMasterCode AS ASM, TTR.TerritoryId, TTR.TerritoryCode, TTR.TerritoryName, MIO.EmpName AS MIOName, MIO.EmpMasterCode AS MIOCode, STTR.SubTerritoryId, STTR.SubTerritoryCode, STTR.SubTerritoryName, MKT.MarketId, 
             MKT.MarketCode, MKT.MarketName, ASM.ASMEMPId, RSM.RSMEMPId, NSM.NSMEMPId, MIO.MIOEmpId, MIO.MIOId
FROM   dbo.tbl_Group AS GP LEFT OUTER JOIN
             dbo.tblRegion AS RGN ON GP.GroupId = RGN.GroupId LEFT OUTER JOIN
             dbo.tblArea AS ARA ON RGN.RegionId = ARA.RegionId LEFT OUTER JOIN
             dbo.tblTerritory AS TTR ON ARA.AreaId = TTR.AreaId LEFT OUTER JOIN
             dbo.tblSubTerritory AS STTR ON TTR.TerritoryId = STTR.TerritoryId LEFT OUTER JOIN
             dbo.tblMarket AS MKT ON STTR.SubTerritoryId = MKT.SubTerritoryId LEFT OUTER JOIN
                 (SELECT RM.RegionId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS RSMEMPId
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON RM.EmployeeId = EGI.EmpInfoId
                 WHERE (RM.IsActive = 1)) AS RSM ON RGN.RegionId = RSM.RegionId LEFT OUTER JOIN
                 (SELECT AM.AreaId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS ASMEMPId
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON AM.EmployeeId = EGI.EmpInfoId
                 WHERE (AM.IsActive = 1)) AS ASM ON ARA.AreaId = ASM.AreaId LEFT OUTER JOIN
                 (SELECT M.TerritoryId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS MIOEmpId, M.MIOId
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON M.EmployeeId = EGI.EmpInfoId
                 WHERE (M.IsActive = 1)) AS MIO ON TTR.TerritoryId = MIO.TerritoryId LEFT OUTER JOIN
                 (SELECT N.GroupId, EGI.EmpMasterCode, EGI.EmpName, EGI.EmpInfoId AS NSMEMPId
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tblEmpGeneralInfo AS EGI ON N.EmployeeId = EGI.EmpInfoId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.GroupId = GP.GroupId
WHERE (GP.IsActive = 1) AND (RGN.IsActive = 1) AND (ARA.IsActive = 1) AND (TTR.IsActive = 1) AND (STTR.IsActive = 1) AND (MKT.IsActive = 1)
