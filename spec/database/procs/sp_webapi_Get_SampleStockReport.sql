CREATE PROCEDURE [dbo].[sp_webapi_Get_SampleStockReport]
	-- Add the parameters for the stored procedure here
    @empId INT
AS
    BEGIN

--	DECLARE @role NVARCHAR(MAX)
--	SELECT @role=RoleType FROM dbo.tblUser
--	LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
--	LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tbl_UserRoleInfo.RoleTypeId WHERE EmpInfoId=@empId

--	DECLARE @param NVARCHAR(MAX)=''
--	IF(@role='MIO')
--	BEGIN
--	    SET @param=@param+' AND MIOEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
--	END
--	IF(@role='AM')
--	BEGIN
--	    SET @param=@param+' AND ASMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
--	END
--	IF(@role='RSM')
--	BEGIN
--	    SET @param=@param+' AND RSMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
--	END
--	IF(@role='DZSM')
--	BEGIN
--	    SET @param=@param+' AND RSMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
--	END
--	IF(@role='NSM')
--	BEGIN
--	    SET @param=@param+' AND NSMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
--	END
		
--        --SELECT  A.ProductCode ,
--        --        A.ProductName ,
--        --        SUM(A.TotalQty) AS StockQty
--        --FROM    dbo.View_DCStoreCurrentStock A
--        --        INNER JOIN dbo.tblCompanyUnit B ON B.ComUnitId = A.ComUnitId
--        --        INNER JOIN dbo.tblCompanyInfo C ON C.CompanyId = B.CompanyId
--        --        INNER JOIN dbo.tblEmpGeneralInfo D ON C.CompanyId = D.CompanyId
--        --WHERE   D.EmpInfoId = @empId
--        --        AND A.TotalQty > 0
--        --GROUP BY A.ProductCode ,
--        --        A.ProductName
--        --ORDER BY A.ProductName
--		DECLARE @q NVARCHAR(MAX)='

--		SELECT  A.ProductCode ,
--                A.ProductName ,
--                SUM(A.TotalQty) AS StockQty
--        FROM    dbo.View_SampleCurrentStock A
                


--INNER JOIN (SELECT DISTINCT
--                   TerritoryId,
--                   TerritoryName,
--                   TerritoryCode,
--                   TerShortName,
--                   Description,
--                   AreaCode,
--                   AreaName,
--                   AreaId,
--                   RegionId,
--                   RegionCode,
--                   RegionName,
--                   GroupId,
--                   GroupName,
--                   MIOId,
--                   ASMId,
--                   RSMId,
--                   NSMId,
--                   MIOEmpName,
--                   MIOEmpMastercode,
--                   MIOEmpInfoId,
--                   ASMEmpName,
--                   ASMEmpMasterCode,
--                   ASMEmpInfoId,
--                   RSMEmpName,
--                   RSMEmpMasterCode,
--                   RSMEmpInfoId,
--                   NSMEmpName,
--                   NSMEmpMasterCode,
--                   NSMEmpInfoId FROM dbo.View_CustomerMaster) AS tblt ON tblt.TerritoryId = dcDtl.TerritoryId
--        WHERE   A.TotalQty > 0 '+@param+' 
--        GROUP BY A.ProductCode ,
--                A.ProductName
--        ORDER BY A.ProductName'

--		EXEC sys.sp_executesql @q


select *,TotalQty as StockQty from View_SampleCurrentStock where EmpInfoId=@empId and TotalQty>0


    END
