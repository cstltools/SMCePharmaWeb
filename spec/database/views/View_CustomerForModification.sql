CREATE VIEW dbo.View_CustomerForModification
AS
SELECT     CM.CustomerMasterId, CM.CustomerCode, CM.CustomerName, CM.Address, CM.CellNo, CM.Addrees2, CM.City, CM.ConPerson, CM.ShippingCond, M.MarketId, M.MarketCode, M.MarketName, MI.MiaId, MI.MiaCode, MI.MiaName, A.AreaId, CM.AreaCode, A.AreaName, 
                  D.DistrictId, D.DistrictCode, D.DistrictName, C.ComUnitId, C.ComUnitCode, C.ComUnitName, R.RegionId, R.RegionCode, R.RegionName, CM.TermOfPayment, CC.CategoryId, CC.CategoryCode, CC.CategoryName, CM.DZSMName, CM.FEName, CM.FixedCustomer, 
                  CM.Type, CM.IsActive, CM.InActiveDate, CM.UpdateBy, CM.UpdateDate, CM.UploadDate
FROM        dbo.tblCustMaster AS CM LEFT OUTER JOIN
                  dbo.tblMarket AS M ON M.MarketCode = REPLACE(CM.MarketCode, ' ', '') LEFT OUTER JOIN
                  dbo.tblArea AS A ON A.AreaCode = REPLACE(CM.AreaCode, ' ', '') LEFT OUTER JOIN
                  dbo.tblMIAInfo AS MI ON MI.MiaCode = REPLACE(CM.MIACode, ' ', '') LEFT OUTER JOIN
                  dbo.tblDistrict AS D ON D.DistrictCode = REPLACE(CM.DisCode, ' ', '') LEFT OUTER JOIN
                  dbo.tblCompanyUnit AS C ON C.ComUnitCode = REPLACE(CM.ComUnitCode, ' ', '') LEFT OUTER JOIN
                  dbo.tblRegion AS R ON R.RegionCode = REPLACE(CM.RegionCode, ' ', '') LEFT OUTER JOIN
                  dbo.tblCustCategory AS CC ON CC.CategoryId = CM.CategoryId
