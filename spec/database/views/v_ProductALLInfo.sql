create view v_ProductALLInfo
as
SELECT pro.ProductCode, pro.ProductName,  pro.Description, STUFF( (SELECT CONCAT(',', com.ComUnitCode + ' : ' +com.ComUnitName , '') FROM dbo.tblProductDCDetails brn(NOLOCK)
left join tblCompanyUnit com on com.ComUnitId=brn.ComUnitId
  WHERE brn.ProductId=pro.ProductId ORDER BY brn.ComUnitId FOR XML PATH ('') ),1,1,'') AS Distribution_Center, gg.GenericGroupName, ttg.TherapeuticGroupName,  pg.GroupName [Product Group], ppl.LineName [Product Line], cat.CategoryName Category, mf.ManufacName, pro.PackSize,   um.StockUOMName, ppt.ProTypeName,  ppb.ProductSqName, pCar.PcsPerCase, case when  pro.IsActive=1 then 'Active' else 'Inactive' end StatusInfo FROM tblProduct pro with (nolock)
LEFT JOIN dbo.tblProCategory  cat  with (nolock) ON pro.CategoryId = cat.CategoryId
 LEFT JOIN dbo.tblPackSize ps with (nolock) ON pro.PackSizeId=ps.PackSizeId
 LEFT JOIN dbo.tblProductCase  pCase  with (nolock) ON pCase.ProductCode=pro.ProductCode

 LEFT JOIN dbo.tblGenericGroup gg with (nolock) ON pro.GenericGroupId=gg.GenericGroupId
 LEFT JOIN dbo.tblProductGroup pg with (nolock) ON pro.ProductGroupId=pg.GroupId
 LEFT JOIN dbo.tblTherapeuticGroup ttg with (nolock) ON pro.TherapueticGroupId=ttg.TherapeuticGroupId
 LEFT JOIN dbo.tblProductLine ppl with (nolock) ON pro.ProductLineID=ppl.ProductLineID
 LEFT JOIN dbo.tblManufacturer mf with (nolock) ON pro.ManufacId=mf.ManufacId
 LEFT JOIN dbo.tblProType ppt with (nolock) ON pro.ProTypeId=ppt.ProTypeId
 LEFT JOIN dbo.tblProductSQ ppb with (nolock) ON pro.ProductBrandId=ppb.ProductBrandId
 LEFT JOIN dbo.tblProductCase pCar with (nolock) ON pro.CaseId=pCar.CaseId
 LEFT JOIN dbo.tblStockUOM um with (nolock) ON pro.StockUOMId=um.StockUOMId   