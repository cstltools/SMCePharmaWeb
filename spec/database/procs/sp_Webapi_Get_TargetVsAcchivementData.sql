-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TargetVsAcchivementData]
 -- [sp_Webapi_Get_TargetVsAcchivementData] 7,8,2021
	-- Add the parameters for the stored procedure here
    @empId INT ,
    @month INT = NULL ,
    @year INT = NULL
AS
    BEGIN

		-- Note:Target Quantity, Sales Quantity , Achivement(%)

        --DECLARE @mioId INT ,
        --    @companyId INT

        --SELECT  @mioId = MIOId
        --FROM    dbo.tblMIOInfo
        --WHERE   EmployeeId = @empId

        --SELECT  @companyId = CompanyId
        --FROM    dbo.tblEmpGeneralInfo
        --WHERE   EmpInfoId = @empId
	

        --SELECT  PD.ProductCode ,
        --        PD.ProductName ,
        --        ISNULL(SL.Qty, 0) Qty ,
        --        ISNULL(SL.Value, 0) Value ,
        --        ISNULL(TGRT.TargetQty, 0) TargetQty ,
        --        CASE WHEN TGRT.TargetQty IS NOT NULL
        --             THEN CAST(( ISNULL(SL.Qty, 0) * 100 ) / NULLIF(TGRT.TargetQty,
        --                                                      0) AS DECIMAL(18,2))
        --             ELSE 0
        --        END AS Achivment
        --FROM    tblMIATargetProductWise AS TGRT
        --        LEFT JOIN tblCompanyInfo AS CI ON TGRT.CompanyId = CI.CompanyId
        --        LEFT JOIN tblProduct AS PD ON TGRT.ProductId = PD.ProductId
        --        LEFT JOIN dbo.tblMIOInfo ON dbo.tblMIOInfo.MIOId = TGRT.MiaId
        --        LEFT JOIN dbo.tblTerritory AS TTR ON TTR.TerritoryId = tblMIOInfo.TerritoryId
        --        LEFT JOIN dbo.tblArea AS ARA ON ARA.AreaId = TTR.AreaId
        --        LEFT JOIN dbo.tblEmpGeneralInfo ON dbo.tblMIOInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId
        --        LEFT JOIN ( SELECT  MIOId ,
        --                            UNT.ComUnitCode ,
        --                            UNT.ComUnitName ,
        --                            ProductCode ,
        --                            SUM(INVD.DeliveryNetAmount) AS Value ,
        --                            ISNULL(SUM(DeliveryTotalQuantity), 0) AS Qty
        --                    FROM    tblInvoice AS INV
        --                            INNER JOIN tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
        --                            INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
        --                    WHERE   DeliveryInvoiceStatus IN ( 'Full',
        --                                                      'Partial' )
        --                            AND YEAR(INV.InvoiceDate) = @year
        --                            AND MONTH(INV.InvoiceDate) = @month
        --                            AND UNT.CompanyId = @companyId
        --                            AND INV.MIOId = @mioId
        --                    GROUP BY UNT.ComUnitCode ,
        --                            UNT.ComUnitName ,
        --                            ProductCode ,
        --                            MIOId
        --                  ) AS SL ON SL.ProductCode = PD.ProductCode
        --                             AND TGRT.MiaId = SL.MIOId
        --WHERE   TGRT.Year = @year
        --        AND ( TGRT.Period = DATENAME(MONTH,
        --                                     DATEADD(MONTH, @month, 0) - 1) )
        --        AND CI.CompanyId = @companyId
        --        AND TGRT.MiaId = @mioId
        --UNION ALL
        --SELECT  INVD.ProductCode ,
        --        INVD.ProductName ,
        --        ISNULL(SUM(DeliveryTotalQuantity), 0) Qty ,
        --        SUM(INVD.DeliveryNetAmount) Value ,
        --        0 TargetQty ,
        --        0 AS Achivment
        --FROM    tblInvoice AS INV
        --        LEFT JOIN tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
        --        LEFT JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
        --        LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
        --        LEFT JOIN dbo.tblMIOInfo ON dbo.tblMIOInfo.MIOId = INV.MIOId
        --        LEFT JOIN dbo.tblEmpGeneralInfo ON tblMIOInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId
        --        LEFT JOIN dbo.tblTerritory AS TTR ON TTR.TerritoryId = tblMIOInfo.TerritoryId
        --        LEFT JOIN dbo.tblArea AS ARA ON ARA.AreaId = TTR.AreaId
        --WHERE   DeliveryInvoiceStatus IN ( 'Full', 'Partial' )
        --        AND YEAR(INV.InvoiceDate) = @year
        --        AND MONTH(INV.InvoiceDate) = @month
        --        AND UNT.CompanyId = @companyId
        --        AND INV.MIOId = @mioId
        --        AND INVD.ProductCode NOT IN (
        --        SELECT  PD.ProductCode
        --        FROM    tblMIATargetProductWise AS TGRT
        --                LEFT JOIN tblProduct AS PD ON TGRT.ProductId = PD.ProductId
        --        WHERE   Year = @year
        --                AND Period = DATENAME(MONTH,
        --                                      DATEADD(MONTH, @month, 0) - 1)
        --                AND CI.CompanyId = @companyId
        --                AND TGRT.MiaId = @mioId )
        --GROUP BY INVD.ProductCode ,
        --        INVD.ProductName 


		DECLARE @role NVARCHAR(MAX)
	SELECT @role=RoleType FROM dbo.tblUser
	LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tbl_UserRoleInfo.RoleTypeId WHERE EmpInfoId=@empId

	DECLARE @param NVARCHAR(MAX)=''
	IF(@role='MIO')
	BEGIN
	    SET @param=@param+' AND MIOEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
	END
	IF(@role='AM')
	BEGIN
	    SET @param=@param+' AND ASMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
	END
	IF(@role='RSM')
	BEGIN
	    SET @param=@param+' AND RSMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
	END
	IF(@role='DZSM')
	BEGIN
	    SET @param=@param+' AND RSMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
	END
	IF(@role='NSM')
	BEGIN
	    SET @param=@param+' AND NSMEmpInfoId='+CONVERT(NVARCHAR(MAX),@empId)
	END

	DECLARE @q NVARCHAR(MAX)='




		SELECT tblt.ProductCode,tblt.ProductName,SUM(tblt.TargetAmount)TargetAmount,SUM(tblt.AchievedAmount)AchievedAmount 
		FROM (SELECT ProductCode,ProductName,ISNULL(Amount,0) AS TargetAmount,''0''AchievedAmount FROM dbo.tblProductWiseSalesTarget
		INNER JOIN (SELECT DISTINCT
                   TerritoryId,
                   TerritoryName,
                   TerritoryCode,
                   TerShortName,
                   Description,
                   AreaCode,
                   AreaName,
                   AreaId,
                   RegionId,
                   RegionCode,
                   RegionName,
                   GroupId,
                   GroupName,
                   MIOId,
                   ASMId,
                   RSMId,
                   NSMId,
                   MIOEmpName,
                   MIOEmpMastercode,
                   MIOEmpInfoId,
                   ASMEmpName,
                   ASMEmpMasterCode,
                   ASMEmpInfoId,
                   RSMEmpName,
                   RSMEmpMasterCode,
                   RSMEmpInfoId,
                   NSMEmpName,
                   NSMEmpMasterCode,
                   NSMEmpInfoId FROM dbo.View_CustomerMaster) AS tblt ON tblt.TerritoryId = dbo.tblProductWiseSalesTarget.TerritoryId
				   LEFT JOIN dbo.tblProduct ON tblProduct.ProductId = tblProductWiseSalesTarget.ProductId
				   WHERE Month='+@month+' AND Year='+@year+' '+@param+'
				   UNION ALL

				   SELECT ProductCode,ProductName,''0''TargetAmount,ISNULL(DeliveryNetAmount,0)AchieveAmount FROM dbo.tblInvoice
				   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
				   LEFT JOIN dbo.View_CustomerMaster ON View_CustomerMaster.CustomerMasterId = tblInvoice.CustomerMasterId
				   WHERE MONTH(UpdateDate)='+@month+' AND YEAR(UpdateDate)='+@year+' '+@param+' ) AS tblt

				   GROUP BY tblt.ProductCode,tblt.ProductName
				   '



      

	  EXEC sys.sp_executesql @q

    END

