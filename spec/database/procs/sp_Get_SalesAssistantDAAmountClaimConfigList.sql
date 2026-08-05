
--------------------------------------------------
-- PROCEDURE: sp_Get_SalesAssistantDAAmountClaimConfigList
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_SalesAssistantDAAmountClaimConfigList
    @RoleName NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #TourType
    (
        TourTypeId INT NOT NULL,
        TourTypeName NVARCHAR(200) NULL
    );

    IF OBJECT_ID('dbo.tblTourType', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #TourType (TourTypeId, TourTypeName)
        EXEC sp_executesql N'SELECT TourTypeId, TourTypeName FROM dbo.tblTourType WITH (NOLOCK);';
    END
    ELSE IF OBJECT_ID('dbo.tbl_TourPlanType', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #TourType (TourTypeId, TourTypeName)
        EXEC sp_executesql N'SELECT TourTypeId, TourTypeName FROM dbo.tbl_TourPlanType WITH (NOLOCK);';
    END
    ELSE IF OBJECT_ID('dbo.tblTourPlanType', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #TourType (TourTypeId, TourTypeName)
        EXEC sp_executesql N'SELECT TourTypeId, TourTypeName FROM dbo.tblTourPlanType WITH (NOLOCK);';
    END;

    SELECT cfg.SalesAssistantDAAmountClaimConfigId,
           cfg.RoleName,
           cfg.TourTypeId,
           ISNULL(tp.TourTypeName, CONVERT(NVARCHAR(20), cfg.TourTypeId)) AS TourTypeName,
           cfg.DAAmount,
           cfg.IsActive,
           CASE WHEN cfg.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS ActiveStatus,
           CONVERT(VARCHAR(11), cfg.EntryDate, 106) AS EntryDateText
    FROM dbo.tblSalesAssistantDAAmountClaimConfig cfg WITH (NOLOCK)
    LEFT JOIN #TourType tp
           ON tp.TourTypeId = cfg.TourTypeId
    WHERE (@RoleName IS NULL OR cfg.RoleName = @RoleName)
    ORDER BY cfg.SalesAssistantDAAmountClaimConfigId DESC;
END

