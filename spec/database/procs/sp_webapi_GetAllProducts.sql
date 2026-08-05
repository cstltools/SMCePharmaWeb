
CREATE PROCEDURE [dbo].[sp_webapi_GetAllProducts]
	-- Add the parameters for the stored procedure here
	@empId int
AS
BEGIN
DECLARE @Id NVARCHAR(MAX)=0
 DECLARE @Q NVARCHAR(MAX)=''
	DECLARE @Param NVARCHAR(MAX)=''

 	DECLARE @Roletype NVARCHAR(MAX)=NULL
	SELECT @Roletype=RoleTypeId FROM dbo.tblUser   with (nolock)
	LEFT JOIN dbo.tbl_UserRoleInfo  with (nolock) ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	WHERE EmpInfoId=@empId


SET @Q='SELECT distinct c.ProductId,
		C.ProductCode,
		C.ProductName,
		C.Description,
		C.PackSize,
		D.UnitPrice,
		D.VATAmountPerUnit AS VATPercentage,
		D.VATAmountPerUnit,
		0 AS QuotedPrice,
		0 AS CustomerMasterId FROM dbo.tblProduct C
INNER JOIN dbo.tblUnitPrice D ON C.ProductId = D.ProductId
INNER JOIN dbo.tblProductDCDetails DC ON C.ProductId = DC.ProductId
INNER JOIN dbo.tblRouteInformationMaster RMas ON RMas.DCId = DC.ComUnitId
INNER JOIN dbo.tblRouteInformationMarketDetail RDtl ON RDtl.RouteInformationMasterId = RMas.RouteInformationMasterId
 INNER JOIN dbo.tblMarket AS MKT   with (nolock) ON RDtl.MarketId = MKT.MarketId
        INNER JOIN dbo.tblSubTerritory tr   with (nolock) ON tr.SubTerritoryId = MKT.SubTerritoryId
        INNER JOIN dbo.tblTerritory terry   with (nolock) ON terry.TerritoryId = tr.TerritoryId
        INNER JOIN dbo.tblArea ar   with (nolock) ON ar.AreaId = terry.AreaId
        INNER JOIN dbo.tblRegion rg    with (nolock)ON rg.RegionId = ar.RegionId
        INNER JOIN dbo.tbl_Group gp   with (nolock) ON gp.GroupId = rg.GroupId
WHERE C.ProductGroupId=1 AND C.IsActive=1 AND D.IsActive=1     AND MKT.IsActive=1  AND tr.IsActive=1  AND terry.IsActive=1  AND ar.IsActive=1    AND rg.IsActive=1    AND gp.IsActive=1'
 --and DC.ComUnitId=12

IF(@Roletype='1')
	BEGIN
	 
		SELECT   @Id=  STUFF( (SELECT CONCAT(',', mm.EmpTerrId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@empId   FOR XML PATH ('') ),1,1,'')  

	    SET @Param=@Param+' and terry.TerritoryId in ('+@Id+')'
	END
	IF(@Roletype='2')
	BEGIN
	 
SELECT   @Id=  STUFF( (SELECT CONCAT(',', mm.EmpAreaId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@empId   FOR XML PATH ('') ),1,1,'')  
	    SET @Param=@Param+' and ar.AreaId in ('+@Id+')'
 
	END
	IF(@Roletype='3')
	BEGIN
	    
		SELECT   @Id=  STUFF( (SELECT CONCAT(',', mm.EmpRegionId , '')   FROM View_Webapi_EmployeeFieldForceInfo mm (NOLOCK)   WHERE EmpInfoId=@empId   FOR XML PATH ('') ),1,1,'')  
	   

	    SET @Param=@Param+' and rg.RegionId in ('+@Id+')'
	END
	IF(@Roletype='4')
	BEGIN
	    SELECT @Id=EmpGroupId FROM dbo.View_Webapi_EmployeeFieldForceInfo   with (nolock)  WHERE EmpInfoId=@empId

	    SET @Param=@Param+' WHERE gp.GroupId='+@Id
	END

	SET @Q=@Q+@Param
	+' ORDER BY C.ProductName asc '

    EXEC sys.sp_executesql @Q
		
END