
CREATE VIEW [dbo].[View_CustomerMasterOld]
AS
SELECT     CM.CustomerMasterId, CM.CustomerCode, CM.CustomerName, CM.Address, CM.CellNo, CM.Addrees2, CM.City, CM.ConPerson, CM.ShippingCond, M.MarketId, M.MarketCode, M.MarketName, MI.MiaId, MI.MiaCode, MI.MiaName, A.AreaId, CM.AreaCode, A.AreaName, 
                  D.DistrictId, D.DistrictCode, D.DistrictName, C.ComUnitId, C.ComUnitCode, C.ComUnitName, R.RegionId, R.RegionCode, R.RegionName, CM.TermOfPayment, CC.CategoryId, CC.CategoryCode, CC.CategoryName, CM.DZSMName, CM.FEName, CM.FixedCustomer, 
                  CM.Type, CM.IsActive, CM.InActiveDate, CM.UpdateBy, CM.UpdateDate, CM.UploadDate, CM.CustomerType
FROM        dbo.tblCustMaster AS CM INNER JOIN
                  dbo.tblMarket AS M ON M.MarketCode = REPLACE(CM.MarketCode, ' ', '') INNER JOIN
                  dbo.tblArea AS A ON A.AreaCode = REPLACE(CM.AreaCode, ' ', '') INNER JOIN
                  dbo.tblMIAInfo AS MI ON MI.MiaCode = REPLACE(CM.MIACode, ' ', '') INNER JOIN
                  dbo.tblDistrict AS D ON D.DistrictCode = REPLACE(CM.DisCode, ' ', '') INNER JOIN
                  dbo.tblCompanyUnit AS C ON C.ComUnitCode = REPLACE(CM.ComUnitCode, ' ', '') INNER JOIN
                  dbo.tblRegion AS R ON R.RegionCode = REPLACE(CM.RegionCode, ' ', '') INNER JOIN
                  dbo.tblCustCategory AS CC ON CC.CategoryId = CM.CategoryId

