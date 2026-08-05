
CREATE PROCEDURE [dbo].[sp_GET_ProductInfo]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN

	DECLARE @Query NVARCHAR(MAX)

	--SET @Query = 'SELECT DeptId,DeptCode,DeptName,EntryBy,EntryDate,UpdateBy,UpdateDate,
	--	 IsActive,CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus
	--	FROM tblDepartment AS DPT 
	--	LEFT JOIN (SELECT DISTINCT DepartmentId, COUNT(DepartmentId) NoOf FROM tblEmpGeneralInfo GROUP BY DepartmentId) AS C ON DPT.DeptId = C.DepartmentId
	--	WHERE DeptId IS NOT NULL' + @Parameter

		SET @Query = 'SELECT MT.ProductId,MT.CompanyId,MT.ProductName, MT.ProductCode,MT.Description, MT.PackSize,MT.ProductType,PC.ProductCategory,MF.ManufacName, UOM.StockUOMName, 
	PB.ProductBrandName, SC.ShippingCartonSizeName,GG.GenericGroupName,TG.TherapeuticGroupName,
	 CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,		
		convert(varchar,MT.EntryDate, 0) EntryDatee,			
	    convert(varchar,MT.UpdateDate, 0) UpdateDatee
		FROM tblProduct AS MT
		LEFT JOIN tblProductCategory PC ON PC.ProductCategoryId = MT.CategoryId
		LEFT JOIN tblManufacturer MF ON MF.ManufacId = MT.ManufacId
		LEFT JOIN tblStockUOM UOM ON UOM.StockUOMId = MT.StockUOMId
		LEFT JOIN tblProductBrand PB ON PB.ProductBrandId = MT.ProductBrandId
		LEFT JOIN tblShippingCartonSize SC ON SC.ShippingCartonSizeId = MT.ShippingCartonSizeId
		LEFT JOIN tblGenericGroup GG ON GG.GenericGroupId = MT.GenericGroupId 
		LEFT JOIN tblTherapeuticGroup TG ON TG.TherapeuticGroupId = MT.TherapueticGroupId
		LEFT JOIN tblUser us ON us.UserId = MT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = MT.UpdateBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		WHERE MT.ProductId IS NOT NULL ' + @Parameter
		
    END

	EXEC(@Query)






	


	



