/*where ord.OrderCode='ODR-22021110002'*/
CREATE VIEW dbo.View_OrderCustomerInfo
AS
SELECT ord.OrderId, ord.OrderCode, com.ComUnitCode, com.ComUnitName, ord.ComUnitId, CM.CategoryId, pt.ProgramTypeName AS CustomerType, CM.CustomerMasterId, CM.CustomerCode, CM.CustomerName, CM.Address, CM.CellNo, 
                  CM.TermOfPayment, CM.CustomerCodeOld, CM.UploadDate, CM.ExcelUpload, CM.FixedCustomer, ct.CustomerType AS Type, CM.IsActive, CM.InActiveDate, CM.CustomerStation, CM.Division, CM.District, CM.Thana, CM.Upazila, 
                  CM.AITGLId, CM.CustomerTypeId, CM.DistrictId, CM.DivisionId, CM.ThanaId, CM.StationTypeId, CM.CreateBy, CM.CreateDate, CM.IsVatApplicable, CM.DistributionRouteId, CM.OwnerName, CM.VoterID, CM.TradeLicense, CM.DrugLicense, 
                  CM.PharmacyCouncilCertificate, CM.BCDS, CM.ProgramTypeId, CM.ApproveBy, CM.ApproveDate, CM.ActionStatus, CM.Email, CM.Reamrks, CM.Latitude, CM.Longitude, CM.LocationUpdateBy, CM.LocationUpdateTime, CM.StreetAddress, 
                  M.MarketId, M.MarketCode, M.MarketName, ST.SubTerritoryId, ST.SubTerritoryName, ST.SubTerritoryCode, ST.SubTerritoryShortName, T.TerritoryId, T.TerritoryName, T.TerritoryCode, T.TerShortName, T.Description, A.AreaCode, 
                  A.AreaName, A.AreaId, R.RegionId, R.RegionCode, R.RegionName, G.GroupId, G.GroupName, ord.MIOId, ord.ASMId, ord.RSMId, ord.NSMId, EMIO.EmpName AS MIOEmpName, EMIO.EmpMasterCode AS MIOEmpMastercode, 
                  EMIO.EmpInfoId AS MIOEmpInfoId, EASM.EmpName AS ASMEmpName, EASM.EmpMasterCode AS ASMEmpMasterCode, EASM.EmpInfoId AS ASMEmpInfoId, ERSM.EmpName AS RSMEmpName, 
                  ERSM.EmpMasterCode AS RSMEmpMasterCode, ERSM.EmpInfoId AS RSMEmpInfoId, ENSM.EmpName AS NSMEmpName, ENSM.EmpMasterCode AS NSMEmpMasterCode, ENSM.EmpInfoId AS NSMEmpInfoId
FROM     dbo.tblOrder AS ord INNER JOIN
                  dbo.tblCustMaster AS CM ON ord.CustomerMasterId = CM.CustomerMasterId INNER JOIN
                  dbo.tblMarket AS M ON M.MarketId = REPLACE(ord.MarketId, ' ', '') LEFT OUTER JOIN
                  dbo.tblSubTerritory AS ST ON ST.SubTerritoryId = ord.SubTerritoryId LEFT OUTER JOIN
                  dbo.tblTerritory AS T ON T.TerritoryId = ord.TerritoryId LEFT OUTER JOIN
                  dbo.tblArea AS A ON A.AreaId = REPLACE(ord.AreaId, ' ', '') LEFT OUTER JOIN
                  dbo.tblRegion AS R ON R.RegionId = REPLACE(ord.RegionId, ' ', '') LEFT OUTER JOIN
                  dbo.tbl_Group AS G ON G.GroupId = ord.GroupId LEFT OUTER JOIN
                  dbo.tblProgramType AS pt ON ord.ProgramTypeId = pt.ProgramTypeId LEFT OUTER JOIN
                  dbo.tblCustomerType AS ct ON ord.CustTypeId = ct.CustomerTypeId LEFT OUTER JOIN
                  dbo.tblEmpGeneralInfo AS EMIO ON ord.MIOId = EMIO.EmpInfoId LEFT OUTER JOIN
                  dbo.tblEmpGeneralInfo AS EASM ON EASM.EmpInfoId = ord.ASMId LEFT OUTER JOIN
                  dbo.tblEmpGeneralInfo AS ERSM ON ERSM.EmpInfoId = ord.RSMId LEFT OUTER JOIN
                  dbo.tblEmpGeneralInfo AS ENSM ON ENSM.EmpInfoId = ord.NSMId LEFT OUTER JOIN
                  dbo.tblCompanyUnit AS com ON com.ComUnitId = ord.ComUnitId
