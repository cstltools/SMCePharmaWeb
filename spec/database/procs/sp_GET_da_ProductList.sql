
--------------------------------------------------
-- PROCEDURE: sp_GET_da_ProductList
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_GET_da_ProductList]
    @ProductCode NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @ProductCode = NULLIF(LTRIM(RTRIM(@ProductCode)), N'');

    SELECT DISTINCT
        pro.ProductId,
        pro.ProductCode,
        pro.ProductName,
        ISNULL(pro.SAP_Code, '') AS ProductSAP_Code,
        ISNULL(ps.PackSizeName, '') AS PackSizeName,
        CASE WHEN pro.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS StatusInfo
    INTO #ProductList
    FROM dbo.tblProduct pro WITH (NOLOCK)
    INNER JOIN dbo.tblUnitPrice D ON pro.ProductId = D.ProductId
    LEFT JOIN dbo.tblProCategory cat WITH (NOLOCK)
        ON pro.CategoryId = cat.CategoryId
    LEFT JOIN dbo.tblPackSize ps WITH (NOLOCK)
        ON pro.PackSizeId = ps.PackSizeId
    LEFT JOIN dbo.tblProductCase pCase WITH (NOLOCK)
        ON pCase.ProductCode = pro.ProductCode
    LEFT JOIN dbo.tblGenericGroup gg WITH (NOLOCK)
        ON pro.GenericGroupId = gg.GenericGroupId
    LEFT JOIN dbo.tblProductGroup pg WITH (NOLOCK)
        ON pro.ProductGroupId = pg.GroupId
    LEFT JOIN dbo.tblStockUOM um WITH (NOLOCK)
        ON pro.StockUOMId = um.StockUOMId
    WHERE (@ProductCode IS NULL
       OR pro.ProductCode = @ProductCode)  and pro.ProductGroupId=1 AND pro.IsActive=1 and D.IsActive=1 --and isnull(D.UnitPrice,0)>0
     select
        ProductId,
        ProductCode,
        ProductName,
        ProductSAP_Code,
        PackSizeName,
        StatusInfo
    FROM #ProductList
    ORDER BY ProductCode ASC;

    SELECT  distinct 
    MAX(dcs.DCStoreId) AS DCStoreId,
    dcs.ProductCode,
    ISNULL(dcs.BatchNo, '') AS BatchNo 
FROM dbo.tblDCStore dcs WITH (NOLOCK)
INNER JOIN #ProductList pro
    ON pro.ProductCode = dcs.ProductCode
WHERE ISNULL(dcs.ProductCode, '') <> ''
  AND ISNULL(dcs.BatchNo, '') <> ''
GROUP BY dcs.ProductCode, ISNULL(dcs.BatchNo, '')
ORDER BY dcs.ProductCode ASC, BatchNo ASC;
END


 