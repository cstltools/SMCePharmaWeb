
CREATE VIEW [dbo].[View_DoctorMaster]
 
AS
SELECT DISTINCT CM.ProgramTypeId, CM.DoctorTypeId, CM.SMCTypeId, smct.SMCType, CM.DoctorId ,
                CM.DoctorCode ,
                (CM.DoctorCode + ' : '+CM.DoctorName)AS DoctorName, 
				 
								(
				SELECT TOP 1 Contact FROM dbo.tblDoctorContactDetail WHERE  DoctorId = CM.DoctorId
				) AS DocContact ,dt.DoctorTypeName, pt.ProgramTypeName,  STUFF( (SELECT CONCAT('; ', mm.Name  , '') FROM dbo.tblDoctorChemberDetail mm with (NOLOCK)  WHERE mm.DoctorId=CM.DoctorId ORDER BY mm.ChemberId FOR XML PATH ('') ),1,1,'') AS ChemberName, M.MarketId, M.MarketCode, M.MarketName, ST.SubTerritoryId, ST.SubTerritoryName, ST.SubTerritoryCode, ST.SubTerritoryShortName, T.TerritoryId, T.TerritoryName, T.TerritoryCode, T.TerShortName, 
             T.Description, A.AreaCode, A.AreaName, A.AreaId, R.RegionId, R.RegionCode, R.RegionName, G.GroupId, G.GroupName, MIO.MIOId, ASM.ASMId, RSM.RSMId, NSM.NSMId, EMIO.EmpName AS MIOEmpName, EMIO.EmpMasterCode AS MIOEmpMastercode, 
             EMIO.EmpInfoId AS MIOEmpInfoId, EASM.EmpName AS ASMEmpName, EASM.EmpMasterCode AS ASMEmpMasterCode, EASM.EmpInfoId AS ASMEmpInfoId, ERSM.EmpName AS RSMEmpName, ERSM.EmpMasterCode AS RSMEmpMasterCode, ERSM.EmpInfoId AS RSMEmpInfoId, 
             ENSM.EmpName AS NSMEmpName, ENSM.EmpMasterCode AS NSMEmpMasterCode, ENSM.EmpInfoId AS NSMEmpInfoId
FROM   dbo.tblDoctorMaster AS CM with (NOLOCK) 
LEFT JOIN dbo.tblDoctorType dt with (NOLOCK)  ON CM.DoctorTypeId=dt.DoctorTypeId
LEFT JOIN dbo.tblSMCType smct with (NOLOCK)  ON CM.SMCTypeId=smct.SMCTypeId


						LEFT JOIN dbo.tblProgramType pt with (NOLOCK)  ON CM.ProgramTypeId=pt.ProgramTypeId
 INNER JOIN
             dbo.tblMarket AS M with (NOLOCK) ON M.MarketId = REPLACE(CM.MarketId, ' ', '') AND M.IsActive = 1 INNER JOIN
             dbo.tblSubTerritory AS ST with (NOLOCK)  ON ST.SubTerritoryId = M.SubTerritoryId AND ST.IsActive = 1 INNER JOIN
             dbo.tblTerritory AS T with (NOLOCK)  ON T.TerritoryId = ST.TerritoryId AND T.IsActive = 1 INNER JOIN
             dbo.tblArea AS A with (NOLOCK)  ON A.AreaId = REPLACE(T.AreaId, ' ', '') AND A.IsActive = 1 INNER JOIN
             dbo.tblRegion AS R with (NOLOCK)  ON R.RegionId = REPLACE(A.RegionId, ' ', '') AND R.IsActive = 1 INNER JOIN
             dbo.tbl_Group AS G with (NOLOCK) ON G.GroupId = R.GroupId AND G.IsActive = 1  
			  LEFT OUTER JOIN
             dbo.tblMIOInfo AS MIO with (NOLOCK)  ON MIO.TerritoryId = T.TerritoryId AND MIO.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EMIO with (NOLOCK)  ON MIO.EmployeeId = EMIO.EmpInfoId LEFT OUTER JOIN
             dbo.tblASMInfo AS ASM with (NOLOCK)  ON ASM.AreaId = A.AreaId AND ASM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EASM with (NOLOCK)  ON EASM.EmpInfoId = ASM.EmployeeId LEFT OUTER JOIN
             dbo.tblRSMInfo AS RSM with (NOLOCK)  ON RSM.RegionId = R.RegionId AND RSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ERSM with (NOLOCK)  ON ERSM.EmpInfoId = RSM.EmployeeId LEFT OUTER JOIN
             dbo.tblNSMInfo AS NSM with (NOLOCK)  ON NSM.GroupId = G.GroupId AND NSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ENSM with (NOLOCK)  ON ENSM.EmpInfoId = NSM.EmployeeId
WHERE (CM.IsActive = '1') AND CM.ApprovalStatus='2'  







