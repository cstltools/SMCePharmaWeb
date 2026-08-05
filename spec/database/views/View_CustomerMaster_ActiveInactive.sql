




create VIEW [dbo].[View_CustomerMaster_ActiveInactive]
AS
SELECT CM.CategoryId, pt.ProgramTypeName AS CustomerType, CM.ComUnitId, CM.ComUnitCode, CM.ComUnitName, CM.CustomerMasterId, CM.CustomerCode, CM.CustomerName, CM.Address, CM.CellNo, CM.TermOfPayment, CM.CustomerCodeOld, CM.UploadDate, CM.ExcelUpload, 
             CM.FixedCustomer, ct.CustomerType AS Type, CM.IsActive, CM.InActiveDate, CM.CustomerStation, CM.Division, CM.District, CM.Thana, CM.Upazila, CM.AITGLId, CM.CustomerTypeId, CM.DistrictId, CM.DivisionId, CM.ThanaId, CM.StationTypeId, CM.CreateBy, CM.CreateDate, 
             CM.IsVatApplicable, CM.DistributionRouteId, CM.OwnerName, CM.VoterID, CM.TradeLicense, CM.DrugLicense, CM.PharmacyCouncilCertificate, CM.BCDS, CM.ProgramTypeId, CM.ApproveBy, CM.ApproveDate, CM.ActionStatus, CM.Email, CM.Reamrks, CM.Latitude, CM.Longitude, 
             CM.LocationUpdateBy, CM.LocationUpdateTime, CM.StreetAddress, M.MarketId, M.MarketCode, M.MarketName, ST.SubTerritoryId, ST.SubTerritoryName, ST.SubTerritoryCode, ST.SubTerritoryShortName, T.TerritoryId, T.TerritoryName, T.TerritoryCode, T.TerShortName, 
             T.Description, A.AreaCode, A.AreaName, A.AreaId, R.RegionId, R.RegionCode, R.RegionName, G.GroupId, G.GroupName, MIO.MIOId, ASM.ASMId, RSM.RSMId, NSM.NSMId, EMIO.EmpName AS MIOEmpName, EMIO.EmpMasterCode AS MIOEmpMastercode, 
             EMIO.EmpInfoId AS MIOEmpInfoId, EASM.EmpName AS ASMEmpName, EASM.EmpMasterCode AS ASMEmpMasterCode, EASM.EmpInfoId AS ASMEmpInfoId, ERSM.EmpName AS RSMEmpName, ERSM.EmpMasterCode AS RSMEmpMasterCode, ERSM.EmpInfoId AS RSMEmpInfoId, 
             ENSM.EmpName AS NSMEmpName, ENSM.EmpMasterCode AS NSMEmpMasterCode, ENSM.EmpInfoId AS NSMEmpInfoId
FROM   dbo.tblCustMaster AS CM INNER JOIN
             dbo.tblMarket AS M ON M.MarketId = REPLACE(CM.MarketId, ' ', '') AND M.IsActive = 1 INNER JOIN
             dbo.tblSubTerritory AS ST ON ST.SubTerritoryId = M.SubTerritoryId AND ST.IsActive = 1 INNER JOIN
             dbo.tblTerritory AS T ON T.TerritoryId = ST.TerritoryId AND T.IsActive = 1 INNER JOIN
             dbo.tblArea AS A ON A.AreaId = REPLACE(T.AreaId, ' ', '') AND A.IsActive = 1 INNER JOIN
             dbo.tblRegion AS R ON R.RegionId = REPLACE(A.RegionId, ' ', '') AND R.IsActive = 1 INNER JOIN
             dbo.tbl_Group AS G ON G.GroupId = R.GroupId AND G.IsActive = 1 LEFT OUTER JOIN
             dbo.tblProgramType AS pt ON CM.ProgramTypeId = pt.ProgramTypeId LEFT OUTER JOIN
             dbo.tblCustomerType AS ct ON CM.CustomerTypeId = ct.CustomerTypeId LEFT OUTER JOIN
             dbo.tblMIOInfo AS MIO ON MIO.TerritoryId = T.TerritoryId AND MIO.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EMIO ON MIO.EmployeeId = EMIO.EmpInfoId LEFT OUTER JOIN
             dbo.tblASMInfo AS ASM ON ASM.AreaId = A.AreaId AND ASM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EASM ON EASM.EmpInfoId = ASM.EmployeeId LEFT OUTER JOIN
             dbo.tblRSMInfo AS RSM ON RSM.RegionId = R.RegionId AND RSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ERSM ON ERSM.EmpInfoId = RSM.EmployeeId LEFT OUTER JOIN
             dbo.tblNSMInfo AS NSM ON NSM.GroupId = G.GroupId AND NSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ENSM ON ENSM.EmpInfoId = NSM.EmployeeId
WHERE (CM.CustomerMasterId IS NOT NULL )





