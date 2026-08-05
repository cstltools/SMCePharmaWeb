
CREATE PROCEDURE [dbo].[sp_SInventory_DynamicMISReport]

    @GroupName        NVARCHAR(100) = NULL,

    @ZoneName         NVARCHAR(100) = NULL,

    @AreaName         NVARCHAR(100) = NULL,

    @TerritoryName    NVARCHAR(100) = NULL,

    @FilterType       NVARCHAR(50)  = NULL,

    @CalculationType  NVARCHAR(50)  = NULL,

    @fromDate             date           = NULL,

    @toDate           date           = NULL,

    @CampaignCodes    NVARCHAR(MAX) = NULL,

    @PharmaPlatforms  NVARCHAR(MAX) = NULL,

    @CustomerTypes    NVARCHAR(MAX) = NULL,

    @ProviderTypes    NVARCHAR(MAX) = NULL,

    @reportLevel      NVARCHAR(MAX) = NULL,   -- 'territory'/'area'/'Zone'/'group'

    @MetricGroup      NVARCHAR(MAX) = NULL

AS

BEGIN

    SET NOCOUNT ON;
    DECLARE @NormalizedReportLevel NVARCHAR(20) = LOWER(LTRIM(RTRIM(ISNULL(@reportLevel, 'territory'))));
    IF (@NormalizedReportLevel = 'region')
        SET @NormalizedReportLevel = 'zone';
    IF (@NormalizedReportLevel NOT IN ('group', 'zone', 'area', 'territory'))
        SET @NormalizedReportLevel = 'territory';

    -- MetricGroup: achievement shortcut

    IF (LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))) = 'achievement')

    BEGIN

        DECLARE @AchFromMonth INT = MONTH(@fromDate);

        DECLARE @AchFromYear  INT = YEAR(@fromDate);

        DECLARE @AchievementLevel NVARCHAR(20) = @NormalizedReportLevel;

        ;WITH achievement_territory AS
        (
            SELECT
                tr.TerritoryId,
                ara.AreaId,
                rgn.RegionId,
                grp.GroupId,
                grp.GroupName,
                rgn.RegionName,
                ara.AreaName,
                tr.TerritoryName,
                ISNULL(tm.TargetAmt, 0) AS Target,
                ISNULL(tblInvAchiv.InvoiceAMT, 0) AS InvoiceAchievement,
                ISNULL(tblCollection.CollectionAMT, 0) AS AchievementCollection
            FROM dbo.tblTerritory tr WITH (NOLOCK)
            INNER JOIN dbo.tblArea ara WITH (NOLOCK)
                ON ara.AreaId = tr.AreaId
               AND ara.IsActive = 1
            INNER JOIN dbo.tblRegion rgn WITH (NOLOCK)
                ON ara.RegionId = rgn.RegionId
               AND rgn.IsActive = 1
            INNER JOIN dbo.tbl_Group grp WITH (NOLOCK)
                ON grp.GroupId = rgn.GroupId
               AND grp.IsActive = 1
            LEFT JOIN
            (
                SELECT
                    tr2.TerritoryId,
                    ISNULL(SUM(CAST(tm2.Value AS DECIMAL(18,2))), 0) AS TargetAmt
                FROM dbo.tblTerritoryDataMigration tm2
                INNER JOIN dbo.tblTerritory tr2 WITH (NOLOCK)
                    ON tr2.TerritoryId = tm2.TerritoryId
                   AND tr2.IsActive = 1
               CROSS APPLY
                (
                    SELECT DATEFROMPARTS(
                        CAST(tm2.YearValue AS int),
                        CAST(tm2.MonthName AS int),
                        1
                    ) AS MonthStartDate
                ) d
                WHERE d.MonthStartDate <= @ToDate
                  AND DATEADD(MONTH, 1, d.MonthStartDate) > @FromDate
                GROUP BY tr2.TerritoryId
            ) tm ON tm.TerritoryId = tr.TerritoryId
            LEFT JOIN
            (
                SELECT
                    ord.TerritoryId,
                    CONVERT(DECIMAL(18,2), ISNULL(SUM(ID.DeliveryNetAmount), 0)) AS InvoiceAMT
                FROM dbo.tblInvoice A WITH (NOLOCK)
                INNER JOIN dbo.tblInvoiceDetail ID
                    ON A.InvoiceId = ID.InvoiceId
                INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
                    ON ord.OrderId = A.OrderId
                WHERE A.UpdateDate >= @FromDate
                  AND A.UpdateDate < DATEADD(DAY, 1, @ToDate)
                  AND A.DelivaryInvoiceNo IS NOT NULL
                GROUP BY ord.TerritoryId
            ) tblInvAchiv ON tblInvAchiv.TerritoryId = tr.TerritoryId
            LEFT JOIN
            (
                SELECT
                    ord.TerritoryId,
                    ISNULL(SUM(cstp.TPAmount + cstp.VATAmount), 0) AS CollectionAMT
                FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
                INNER JOIN dbo.tblInvoice A
                    ON A.InvoiceId = cstp.InvoiceId
                INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
                    ON ord.OrderId = A.OrderId
                WHERE cstp.custPaymentDate >= @FromDate
                  AND cstp.custPaymentDate < DATEADD(DAY, 1, @ToDate)
                GROUP BY ord.TerritoryId
            ) tblCollection ON tblCollection.TerritoryId = tr.TerritoryId
            WHERE rgn.IsActive = 1
              AND (ISNULL(@GroupName, '') = '' OR grp.GroupId = TRY_CONVERT(INT, @GroupName))
              AND (ISNULL(@ZoneName, '') = '' OR rgn.RegionId = TRY_CONVERT(INT, @ZoneName))
              AND (ISNULL(@AreaName, '') = '' OR ara.AreaId = TRY_CONVERT(INT, @AreaName))
              AND (ISNULL(@TerritoryName, '') = '' OR tr.TerritoryId = TRY_CONVERT(INT, @TerritoryName))
        )
        SELECT
            MIN(
                CASE
                    WHEN @AchievementLevel = 'group' THEN GroupId
                    WHEN @AchievementLevel = 'zone' THEN RegionId
                    WHEN @AchievementLevel = 'area' THEN AreaId
                    ELSE TerritoryId
                END
            ) AS TerritoryId,
            CASE
                WHEN @AchievementLevel = 'group' THEN GroupName
                WHEN @AchievementLevel = 'zone' THEN GroupName + '|' + RegionName
                WHEN @AchievementLevel = 'area' THEN GroupName + '|' + RegionName + '|' + AreaName
                ELSE GroupName + '|' + RegionName + '|' + AreaName + '|' + TerritoryName
            END AS RowKey,
            GroupName,
            RegionName,
            CASE WHEN @AchievementLevel IN ('area', 'territory') THEN AreaName ELSE '' END AS AreaName,
            CASE WHEN @AchievementLevel = 'territory' THEN TerritoryName ELSE '' END AS TerritoryName,
            UPPER(LEFT(@AchievementLevel, 1)) + SUBSTRING(@AchievementLevel, 2, LEN(@AchievementLevel)) AS reportLevel,
            'NetTP' AS CalculationType,
            @AchFromYear AS FiscalYear,
            @AchFromMonth AS FiscalMonth,
            'general' AS PharmaPlatform,
            'green-star' AS ProviderType,
            SUM(Target) AS Target,
            SUM(InvoiceAchievement) AS InvoiceAchievement,
            SUM(AchievementCollection) AS AchievementCollection
        FROM achievement_territory
        GROUP BY
            CASE
                WHEN @AchievementLevel = 'group' THEN GroupName
                WHEN @AchievementLevel = 'zone' THEN GroupName + '|' + RegionName
                WHEN @AchievementLevel = 'area' THEN GroupName + '|' + RegionName + '|' + AreaName
                ELSE GroupName + '|' + RegionName + '|' + AreaName + '|' + TerritoryName
            END,
            GroupName,
            RegionName,
            CASE WHEN @AchievementLevel IN ('area', 'territory') THEN AreaName ELSE '' END,
            CASE WHEN @AchievementLevel = 'territory' THEN TerritoryName ELSE '' END;



        RETURN;

    END


    -- MetricGroup: pharma shortcut
    IF (CHARINDEX(',pharma,', ',' + REPLACE(LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))), ' ', '') + ',') > 0)
    BEGIN
        DECLARE @PharmaLevel NVARCHAR(20) = @NormalizedReportLevel;
        DECLARE @PharmaGroupIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@GroupName)), ''));
        DECLARE @PharmaZoneIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@ZoneName)), ''));
        DECLARE @PharmaAreaIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@AreaName)), ''));
        DECLARE @PharmaTerritoryIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@TerritoryName)), ''));
        DECLARE @HasSelectedPharmaEarly BIT = 0;

        CREATE TABLE #SelectedPharmaEarly
        (
            SlotNo INT NOT NULL PRIMARY KEY,
            PharmaPlatform NVARCHAR(100) NOT NULL
        );

        CREATE UNIQUE NONCLUSTERED INDEX IX_SelectedPharmaEarly_PharmaPlatform
            ON #SelectedPharmaEarly(PharmaPlatform);

        IF (NULLIF(LTRIM(RTRIM(@PharmaPlatforms)), '') IS NOT NULL)
        BEGIN
            DECLARE @SafePharmaEarly NVARCHAR(MAX);
            DECLARE @SplitXmlPharmaEarly XML;
            DECLARE @PharmaInputEarly TABLE
            (
                SlotNo INT IDENTITY(1,1) PRIMARY KEY,
                PharmaPlatform NVARCHAR(100)
            );

            SET @SafePharmaEarly = (SELECT @PharmaPlatforms FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');
            SET @SafePharmaEarly = REPLACE(@SafePharmaEarly, ',', '</i><i>');
            SET @SplitXmlPharmaEarly = TRY_CAST('<i>' + @SafePharmaEarly + '</i>' AS XML);

            IF (@SplitXmlPharmaEarly IS NOT NULL)
            BEGIN
                INSERT INTO @PharmaInputEarly(PharmaPlatform)
                SELECT LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(100)')))
                FROM @SplitXmlPharmaEarly.nodes('/i') AS t(c)
                WHERE LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(100)'))) <> '';

                INSERT INTO #SelectedPharmaEarly(SlotNo, PharmaPlatform)
                SELECT SlotNo, PharmaPlatform
                FROM @PharmaInputEarly
                WHERE SlotNo <= 4;
            END
        END

        IF EXISTS (SELECT 1 FROM #SelectedPharmaEarly)
            SET @HasSelectedPharmaEarly = 1;

        CREATE TABLE #PharmaGeo
        (
            TerritoryId INT NOT NULL PRIMARY KEY,
            AreaId INT NOT NULL,
            RegionId INT NOT NULL,
            GroupId INT NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            TerritoryName NVARCHAR(150) NOT NULL,
            RowId INT NOT NULL,
            RowKey NVARCHAR(500) NOT NULL
        );

        CREATE NONCLUSTERED INDEX IX_PharmaGeo_RowId
            ON #PharmaGeo(RowId);

        INSERT INTO #PharmaGeo
        (
            TerritoryId,
            AreaId,
            RegionId,
            GroupId,
            GroupName,
            ZoneName,
            AreaName,
            TerritoryName,
            RowId,
            RowKey
        )
        SELECT
            tr.TerritoryId,
            ara.AreaId,
            rgn.RegionId,
            grp.GroupId,
            grp.GroupName,
            rgn.RegionName AS ZoneName,
            ara.AreaName,
            tr.TerritoryName,
            CASE
                WHEN @PharmaLevel = 'group' THEN grp.GroupId
                WHEN @PharmaLevel = 'zone' THEN rgn.RegionId
                WHEN @PharmaLevel = 'area' THEN ara.AreaId
                ELSE tr.TerritoryId
            END AS RowId,
            CASE
                WHEN @PharmaLevel = 'group' THEN grp.GroupName
                WHEN @PharmaLevel = 'zone' THEN grp.GroupName + '|' + rgn.RegionName
                WHEN @PharmaLevel = 'area' THEN grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName
                ELSE grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName + '|' + tr.TerritoryName
            END AS RowKey
        FROM dbo.tblTerritory tr WITH (NOLOCK)
        INNER JOIN dbo.tblArea ara WITH (NOLOCK)
            ON ara.AreaId = tr.AreaId
           AND ara.IsActive = 1
        INNER JOIN dbo.tblRegion rgn WITH (NOLOCK)
            ON rgn.RegionId = ara.RegionId
           AND rgn.IsActive = 1
        INNER JOIN dbo.tbl_Group grp WITH (NOLOCK)
            ON grp.GroupId = rgn.GroupId
           AND grp.IsActive = 1
        WHERE (@PharmaGroupIdFilter IS NULL OR grp.GroupId = @PharmaGroupIdFilter)
          AND (@PharmaZoneIdFilter IS NULL OR rgn.RegionId = @PharmaZoneIdFilter)
          AND (@PharmaAreaIdFilter IS NULL OR ara.AreaId = @PharmaAreaIdFilter)
          AND (@PharmaTerritoryIdFilter IS NULL OR tr.TerritoryId = @PharmaTerritoryIdFilter)
        OPTION (RECOMPILE);

        CREATE TABLE #PharmaReportRows
        (
            RowId INT NOT NULL PRIMARY KEY,
            RowKey NVARCHAR(500) NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            Territory NVARCHAR(150) NOT NULL
        );

        INSERT INTO #PharmaReportRows(RowId, RowKey, GroupName, ZoneName, AreaName, Territory)
        SELECT
            pg.RowId,
            MIN(pg.RowKey) AS RowKey,
            MIN(pg.GroupName) AS GroupName,
            CASE WHEN @PharmaLevel IN ('zone', 'area', 'territory') THEN MIN(pg.ZoneName) ELSE '' END AS ZoneName,
            CASE WHEN @PharmaLevel IN ('area', 'territory') THEN MIN(pg.AreaName) ELSE '' END AS AreaName,
            CASE WHEN @PharmaLevel = 'territory' THEN MIN(pg.TerritoryName) ELSE '' END AS Territory
        FROM #PharmaGeo pg
        GROUP BY pg.RowId;

        CREATE TABLE #PharmaInvoice
        (
            RowId INT NOT NULL,
            PharmaPlatform NVARCHAR(100) NOT NULL,
            InvoiceCount INT NOT NULL,
            InvoiceValue DECIMAL(18,2) NOT NULL,
            PRIMARY KEY CLUSTERED (RowId, PharmaPlatform)
        );

        CREATE NONCLUSTERED INDEX IX_PharmaInvoice_PharmaPlatform
            ON #PharmaInvoice(PharmaPlatform)
            INCLUDE (RowId, InvoiceCount, InvoiceValue);

        INSERT INTO #PharmaInvoice(RowId, PharmaPlatform, InvoiceCount, InvoiceValue)
        SELECT
            pg.RowId,
            ord.SMCType_Ord AS PharmaPlatform,
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2), ISNULL(SUM(ID.DeliveryNetAmount), 0)) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId
        INNER JOIN #PharmaGeo pg
            ON pg.TerritoryId = ord.TerritoryId
        INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
            ON ID.InvoiceId = A.InvoiceId
        WHERE A.UpdateDate >= @FromDate
          AND A.UpdateDate < DATEADD(DAY, 1, @ToDate)
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(ord.SMCType_Ord)), '') IS NOT NULL
          AND
          (
              @HasSelectedPharmaEarly = 0
              OR EXISTS
                 (
                     SELECT 1
                     FROM #SelectedPharmaEarly sp
                     WHERE sp.PharmaPlatform = ord.SMCType_Ord
                 )
          )
        GROUP BY
            pg.RowId,
            ord.SMCType_Ord
        OPTION (RECOMPILE);

        CREATE TABLE #PharmaCollection
        (
            RowId INT NOT NULL,
            PharmaPlatform NVARCHAR(100) NOT NULL,
            InvoiceCollection DECIMAL(18,2) NOT NULL,
            PRIMARY KEY CLUSTERED (RowId, PharmaPlatform)
        );

        INSERT INTO #PharmaCollection(RowId, PharmaPlatform, InvoiceCollection)
        SELECT
            pg.RowId,
            ord2.SMCType_Ord AS PharmaPlatform,
            CONVERT(DECIMAL(18,2), ISNULL(SUM(cstp.TPAmount + cstp.VATAmount), 0)) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN dbo.tblInvoice A2 WITH (NOLOCK)
            ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN dbo.tblOrder ord2 WITH (NOLOCK)
            ON ord2.OrderId = A2.OrderId
        INNER JOIN #PharmaGeo pg
            ON pg.TerritoryId = ord2.TerritoryId
        WHERE cstp.custPaymentDate >= @FromDate
          AND cstp.custPaymentDate < DATEADD(DAY, 1, @ToDate)
          AND NULLIF(LTRIM(RTRIM(ord2.SMCType_Ord)), '') IS NOT NULL
          AND
          (
              @HasSelectedPharmaEarly = 0
              OR EXISTS
                 (
                     SELECT 1
                     FROM #SelectedPharmaEarly sp
                     WHERE sp.PharmaPlatform = ord2.SMCType_Ord
                 )
          )
        GROUP BY
            pg.RowId,
            ord2.SMCType_Ord
        OPTION (RECOMPILE);

        IF NOT EXISTS (SELECT 1 FROM #SelectedPharmaEarly)
        BEGIN
            ;WITH ranked AS
            (
                SELECT PharmaPlatform, ROW_NUMBER() OVER (ORDER BY PharmaPlatform) AS rn
                FROM
                (
                    SELECT DISTINCT PharmaPlatform
                    FROM #PharmaInvoice
                ) p
            )
            INSERT INTO #SelectedPharmaEarly(SlotNo, PharmaPlatform)
            SELECT rn, PharmaPlatform
            FROM ranked
            WHERE rn <= 4;
        END

        CREATE TABLE #PharmaSlots
        (
            RowId INT NOT NULL PRIMARY KEY,
            PharmaPlatformWiseCollection DECIMAL(18,2) NOT NULL,
            PharmaPlatformWiseTotalChemistCoverage INT NOT NULL,
            PharmaPlatformWiseTotalInvoiceAmount DECIMAL(18,2) NOT NULL,
            PharmaPlatformWiseTotalCollection DECIMAL(18,2) NOT NULL,
            PharmaPlatform1_Name NVARCHAR(100) NOT NULL,
            PharmaPlatform1_InvoiceAmount DECIMAL(18,2) NOT NULL,
            PharmaPlatform1_ChemistCoverage INT NOT NULL,
            PharmaPlatform1_InvoiceCollection DECIMAL(18,2) NOT NULL,
            PharmaPlatform2_Name NVARCHAR(100) NOT NULL,
            PharmaPlatform2_InvoiceAmount DECIMAL(18,2) NOT NULL,
            PharmaPlatform2_ChemistCoverage INT NOT NULL,
            PharmaPlatform2_InvoiceCollection DECIMAL(18,2) NOT NULL,
            PharmaPlatform3_Name NVARCHAR(100) NOT NULL,
            PharmaPlatform3_InvoiceAmount DECIMAL(18,2) NOT NULL,
            PharmaPlatform3_ChemistCoverage INT NOT NULL,
            PharmaPlatform3_InvoiceCollection DECIMAL(18,2) NOT NULL,
            PharmaPlatform4_Name NVARCHAR(100) NOT NULL,
            PharmaPlatform4_InvoiceAmount DECIMAL(18,2) NOT NULL,
            PharmaPlatform4_ChemistCoverage INT NOT NULL,
            PharmaPlatform4_InvoiceCollection DECIMAL(18,2) NOT NULL
        );

        INSERT INTO #PharmaSlots
        (
            RowId,
            PharmaPlatformWiseCollection,
            PharmaPlatformWiseTotalChemistCoverage,
            PharmaPlatformWiseTotalInvoiceAmount,
            PharmaPlatformWiseTotalCollection,
            PharmaPlatform1_Name,
            PharmaPlatform1_InvoiceAmount,
            PharmaPlatform1_ChemistCoverage,
            PharmaPlatform1_InvoiceCollection,
            PharmaPlatform2_Name,
            PharmaPlatform2_InvoiceAmount,
            PharmaPlatform2_ChemistCoverage,
            PharmaPlatform2_InvoiceCollection,
            PharmaPlatform3_Name,
            PharmaPlatform3_InvoiceAmount,
            PharmaPlatform3_ChemistCoverage,
            PharmaPlatform3_InvoiceCollection,
            PharmaPlatform4_Name,
            PharmaPlatform4_InvoiceAmount,
            PharmaPlatform4_ChemistCoverage,
            PharmaPlatform4_InvoiceCollection
        )
        SELECT
            rr.RowId,
            ISNULL(SUM(ISNULL(pc.InvoiceCollection, 0)), 0) AS PharmaPlatformWiseCollection,
            ISNULL(SUM(ISNULL(pi.InvoiceCount, 0)), 0) AS PharmaPlatformWiseTotalChemistCoverage,
            ISNULL(SUM(ISNULL(pi.InvoiceValue, 0)), 0) AS PharmaPlatformWiseTotalInvoiceAmount,
            ISNULL(SUM(ISNULL(pc.InvoiceCollection, 0)), 0) AS PharmaPlatformWiseTotalCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 1 THEN sp.PharmaPlatform END), '') AS PharmaPlatform1_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 1 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS PharmaPlatform1_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 1 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS PharmaPlatform1_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 1 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS PharmaPlatform1_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 2 THEN sp.PharmaPlatform END), '') AS PharmaPlatform2_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 2 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS PharmaPlatform2_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 2 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS PharmaPlatform2_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 2 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS PharmaPlatform2_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 3 THEN sp.PharmaPlatform END), '') AS PharmaPlatform3_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 3 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS PharmaPlatform3_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 3 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS PharmaPlatform3_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 3 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS PharmaPlatform3_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 4 THEN sp.PharmaPlatform END), '') AS PharmaPlatform4_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 4 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS PharmaPlatform4_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 4 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS PharmaPlatform4_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 4 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS PharmaPlatform4_InvoiceCollection
        FROM #PharmaReportRows rr
        CROSS JOIN #SelectedPharmaEarly sp
        LEFT JOIN #PharmaInvoice pi
            ON pi.RowId = rr.RowId
           AND pi.PharmaPlatform = sp.PharmaPlatform
        LEFT JOIN #PharmaCollection pc
            ON pc.RowId = rr.RowId
           AND pc.PharmaPlatform = sp.PharmaPlatform
        GROUP BY rr.RowId;

        SELECT
            rr.RowId AS TrrId_,
            rr.RowKey,
            rr.GroupName,
            rr.ZoneName,
            rr.AreaName,
            rr.Territory,
            ISNULL(ps.PharmaPlatformWiseCollection, 0) AS PharmaPlatformWiseCollection,
            ISNULL(ps.PharmaPlatformWiseTotalChemistCoverage, 0) AS PharmaPlatformWiseTotalChemistCoverage,
            ISNULL(ps.PharmaPlatformWiseTotalInvoiceAmount, 0) AS PharmaPlatformWiseTotalInvoiceAmount,
            ISNULL(ps.PharmaPlatformWiseTotalCollection, 0) AS PharmaPlatformWiseTotalCollection,
            ISNULL(ps.PharmaPlatform1_Name, '') AS PharmaPlatform1_Name,
            ISNULL(ps.PharmaPlatform1_InvoiceAmount, 0) AS PharmaPlatform1_InvoiceAmount,
            ISNULL(ps.PharmaPlatform1_ChemistCoverage, 0) AS PharmaPlatform1_ChemistCoverage,
            ISNULL(ps.PharmaPlatform1_InvoiceCollection, 0) AS PharmaPlatform1_InvoiceCollection,
            ISNULL(ps.PharmaPlatform2_Name, '') AS PharmaPlatform2_Name,
            ISNULL(ps.PharmaPlatform2_InvoiceAmount, 0) AS PharmaPlatform2_InvoiceAmount,
            ISNULL(ps.PharmaPlatform2_ChemistCoverage, 0) AS PharmaPlatform2_ChemistCoverage,
            ISNULL(ps.PharmaPlatform2_InvoiceCollection, 0) AS PharmaPlatform2_InvoiceCollection,
            ISNULL(ps.PharmaPlatform3_Name, '') AS PharmaPlatform3_Name,
            ISNULL(ps.PharmaPlatform3_InvoiceAmount, 0) AS PharmaPlatform3_InvoiceAmount,
            ISNULL(ps.PharmaPlatform3_ChemistCoverage, 0) AS PharmaPlatform3_ChemistCoverage,
            ISNULL(ps.PharmaPlatform3_InvoiceCollection, 0) AS PharmaPlatform3_InvoiceCollection,
            ISNULL(ps.PharmaPlatform4_Name, '') AS PharmaPlatform4_Name,
            ISNULL(ps.PharmaPlatform4_InvoiceAmount, 0) AS PharmaPlatform4_InvoiceAmount,
            ISNULL(ps.PharmaPlatform4_ChemistCoverage, 0) AS PharmaPlatform4_ChemistCoverage,
            ISNULL(ps.PharmaPlatform4_InvoiceCollection, 0) AS PharmaPlatform4_InvoiceCollection
        FROM #PharmaReportRows rr
        LEFT JOIN #PharmaSlots ps ON ps.RowId = rr.RowId;

        RETURN;
    END


    -- MetricGroup: customer early shortcut
    IF (LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))) = 'customer')
    BEGIN
        DECLARE @CustomerLevel NVARCHAR(20) = @NormalizedReportLevel;
        DECLARE @GroupIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@GroupName)), ''));
        DECLARE @ZoneIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@ZoneName)), ''));
        DECLARE @AreaIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@AreaName)), ''));
        DECLARE @TerritoryIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@TerritoryName)), ''));

        CREATE TABLE #SelectedCustomerEarly
        (
            SlotNo INT NOT NULL PRIMARY KEY,
            CustomerType NVARCHAR(100) NOT NULL
        );

        CREATE UNIQUE NONCLUSTERED INDEX IX_SelectedCustomerEarly_CustomerType
            ON #SelectedCustomerEarly(CustomerType);

        IF (NULLIF(LTRIM(RTRIM(@CustomerTypes)), '') IS NOT NULL)
        BEGIN
            DECLARE @SafeCustomerEarly NVARCHAR(MAX);
            DECLARE @SplitXmlCustomerEarly XML;
            DECLARE @CustomerInputEarly TABLE
            (
                SlotNo INT IDENTITY(1,1) PRIMARY KEY,
                CustomerType NVARCHAR(100)
            );

            SET @SafeCustomerEarly = (SELECT @CustomerTypes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');
            SET @SafeCustomerEarly = REPLACE(@SafeCustomerEarly, ',', '</i><i>');
            SET @SplitXmlCustomerEarly = TRY_CAST('<i>' + @SafeCustomerEarly + '</i>' AS XML);

            IF (@SplitXmlCustomerEarly IS NOT NULL)
            BEGIN
                INSERT INTO @CustomerInputEarly(CustomerType)
                SELECT LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(100)')))
                FROM @SplitXmlCustomerEarly.nodes('/i') AS t(c)
                WHERE LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(100)'))) <> '';

                INSERT INTO #SelectedCustomerEarly(SlotNo, CustomerType)
                SELECT SlotNo, CustomerType
                FROM @CustomerInputEarly
                WHERE SlotNo <= 6;
            END
        END

        CREATE TABLE #CustomerGeo
        (
            TerritoryId INT NOT NULL PRIMARY KEY,
            AreaId INT NOT NULL,
            RegionId INT NOT NULL,
            GroupId INT NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            TerritoryName NVARCHAR(150) NOT NULL,
            RowId INT NOT NULL,
            RowKey NVARCHAR(500) NOT NULL
        );

        CREATE NONCLUSTERED INDEX IX_CustomerGeo_RowId
            ON #CustomerGeo(RowId);

        INSERT INTO #CustomerGeo
        (
            TerritoryId,
            AreaId,
            RegionId,
            GroupId,
            GroupName,
            ZoneName,
            AreaName,
            TerritoryName,
            RowId,
            RowKey
        )
        SELECT
            tr.TerritoryId,
            ara.AreaId,
            rgn.RegionId,
            grp.GroupId,
            grp.GroupName,
            rgn.RegionName AS ZoneName,
            ara.AreaName,
            tr.TerritoryName,
            CASE
                WHEN @CustomerLevel = 'group' THEN grp.GroupId
                WHEN @CustomerLevel = 'zone' THEN rgn.RegionId
                WHEN @CustomerLevel = 'area' THEN ara.AreaId
                ELSE tr.TerritoryId
            END AS RowId,
            CASE
                WHEN @CustomerLevel = 'group' THEN grp.GroupName
                WHEN @CustomerLevel = 'zone' THEN grp.GroupName + '|' + rgn.RegionName
                WHEN @CustomerLevel = 'area' THEN grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName
                ELSE grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName + '|' + tr.TerritoryName
            END AS RowKey
        FROM dbo.tblTerritory tr WITH (NOLOCK)
        INNER JOIN dbo.tblArea ara WITH (NOLOCK)
            ON ara.AreaId = tr.AreaId
           AND ara.IsActive = 1
        INNER JOIN dbo.tblRegion rgn WITH (NOLOCK)
            ON rgn.RegionId = ara.RegionId
           AND rgn.IsActive = 1
        INNER JOIN dbo.tbl_Group grp WITH (NOLOCK)
            ON grp.GroupId = rgn.GroupId
           AND grp.IsActive = 1
        WHERE (@GroupIdFilter IS NULL OR grp.GroupId = @GroupIdFilter)
          AND (@ZoneIdFilter IS NULL OR rgn.RegionId = @ZoneIdFilter)
          AND (@AreaIdFilter IS NULL OR ara.AreaId = @AreaIdFilter)
          AND (@TerritoryIdFilter IS NULL OR tr.TerritoryId = @TerritoryIdFilter)
        OPTION (RECOMPILE);

        CREATE TABLE #CustomerReportRows
        (
            RowId INT NOT NULL PRIMARY KEY,
            RowKey NVARCHAR(500) NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            Territory NVARCHAR(150) NOT NULL
        );

        INSERT INTO #CustomerReportRows(RowId, RowKey, GroupName, ZoneName, AreaName, Territory)
        SELECT
            cg.RowId,
            MIN(cg.RowKey) AS RowKey,
            MIN(cg.GroupName) AS GroupName,
            CASE WHEN @CustomerLevel IN ('zone', 'area', 'territory') THEN MIN(cg.ZoneName) ELSE '' END AS ZoneName,
            CASE WHEN @CustomerLevel IN ('area', 'territory') THEN MIN(cg.AreaName) ELSE '' END AS AreaName,
            CASE WHEN @CustomerLevel = 'territory' THEN MIN(cg.TerritoryName) ELSE '' END AS Territory
        FROM #CustomerGeo cg
        GROUP BY cg.RowId;

        CREATE TABLE #CustomerInvoice
        (
            RowId INT NOT NULL,
            InvoiceId INT NOT NULL,
            CustomerMasterId INT NULL,
            CustomerType NVARCHAR(100) NOT NULL,
            InvoiceAmount DECIMAL(18,2) NOT NULL
        );

        CREATE CLUSTERED INDEX IX_CustomerInvoice_RowId_InvoiceId
            ON #CustomerInvoice(RowId, InvoiceId);

        CREATE NONCLUSTERED INDEX IX_CustomerInvoice_CustomerType_RowId
            ON #CustomerInvoice(CustomerType, RowId)
            INCLUDE (InvoiceAmount, CustomerMasterId);

        INSERT INTO #CustomerInvoice(RowId, InvoiceId, CustomerMasterId, CustomerType, InvoiceAmount)
        SELECT
            cg.RowId,
            A.InvoiceId,
            ord.CustomerMasterId,
            ISNULL(CustT.CustomerType, '') AS CustomerType,
            CONVERT(DECIMAL(18,2), SUM(ID.DeliveryNetAmount)) AS InvoiceAmount
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId
        INNER JOIN #CustomerGeo cg
            ON cg.TerritoryId = ord.TerritoryId
        INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
            ON ID.InvoiceId = A.InvoiceId
        LEFT JOIN dbo.tblCustomerType CustT WITH (NOLOCK)
            ON CustT.CustomerTypeId = ord.CustTypeId
        WHERE A.UpdateDate >= @FromDate
          AND A.UpdateDate < DATEADD(DAY, 1, @ToDate)
          AND A.DelivaryInvoiceNo IS NOT NULL
        GROUP BY
            cg.RowId,
            A.InvoiceId,
            ord.CustomerMasterId,
            ISNULL(CustT.CustomerType, '')
        OPTION (RECOMPILE);

        CREATE TABLE #CustomerCollection
        (
            RowId INT NOT NULL,
            CustomerType NVARCHAR(100) NOT NULL,
            InvoiceCollection DECIMAL(18,2) NOT NULL
        );

        CREATE CLUSTERED INDEX IX_CustomerCollection_RowId_CustomerType
            ON #CustomerCollection(RowId, CustomerType);

        INSERT INTO #CustomerCollection(RowId, CustomerType, InvoiceCollection)
        SELECT
            cg.RowId,
            ISNULL(CustT.CustomerType, '') AS CustomerType,
            CONVERT(DECIMAL(18,2), SUM(cstp.TPAmount + cstp.VATAmount)) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN dbo.tblInvoice A2 WITH (NOLOCK)
            ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN dbo.tblOrder ord2 WITH (NOLOCK)
            ON ord2.OrderId = A2.OrderId
        INNER JOIN #CustomerGeo cg
            ON cg.TerritoryId = ord2.TerritoryId
        LEFT JOIN dbo.tblCustomerType CustT WITH (NOLOCK)
            ON CustT.CustomerTypeId = ord2.CustTypeId
        WHERE cstp.custPaymentDate >= @FromDate
          AND cstp.custPaymentDate < DATEADD(DAY, 1, @ToDate)
        GROUP BY
            cg.RowId,
            ISNULL(CustT.CustomerType, '')
        OPTION (RECOMPILE);

        IF NOT EXISTS (SELECT 1 FROM #SelectedCustomerEarly)
        BEGIN
            ;WITH ranked AS
            (
                SELECT
                    ci.CustomerType,
                    ROW_NUMBER() OVER (ORDER BY ci.CustomerType) AS rn
                FROM
                (
                    SELECT DISTINCT CustomerType
                    FROM #CustomerInvoice
                    WHERE NULLIF(LTRIM(RTRIM(CustomerType)), '') IS NOT NULL
                ) ci
            )
            INSERT INTO #SelectedCustomerEarly(SlotNo, CustomerType)
            SELECT rn, CustomerType
            FROM ranked
            WHERE rn <= 6;
        END

        CREATE TABLE #InvoiceTotals
        (
            RowId INT NOT NULL PRIMARY KEY,
            InvoiceCount INT NOT NULL,
            InvoiceValue DECIMAL(18,2) NOT NULL,
            TotalCustomer INT NOT NULL
        );

        INSERT INTO #InvoiceTotals(RowId, InvoiceCount, InvoiceValue, TotalCustomer)
        SELECT
            ci.RowId,
            COUNT(*) AS InvoiceCount,
            CONVERT(DECIMAL(18,2), SUM(ci.InvoiceAmount)) AS InvoiceValue,
            COUNT(DISTINCT ci.CustomerMasterId) AS TotalCustomer
        FROM #CustomerInvoice ci
        GROUP BY ci.RowId;

        CREATE TABLE #CollectionTotals
        (
            RowId INT NOT NULL PRIMARY KEY,
            InvoiceCollection DECIMAL(18,2) NOT NULL
        );

        INSERT INTO #CollectionTotals(RowId, InvoiceCollection)
        SELECT
            cc.RowId,
            CONVERT(DECIMAL(18,2), SUM(cc.InvoiceCollection)) AS InvoiceCollection
        FROM #CustomerCollection cc
        GROUP BY cc.RowId;

        CREATE TABLE #InvoiceByType
        (
            RowId INT NOT NULL,
            CustomerType NVARCHAR(100) NOT NULL,
            InvoiceCount INT NOT NULL,
            InvoiceValue DECIMAL(18,2) NOT NULL
        );

        CREATE CLUSTERED INDEX IX_InvoiceByType_RowId_CustomerType
            ON #InvoiceByType(RowId, CustomerType);

        INSERT INTO #InvoiceByType(RowId, CustomerType, InvoiceCount, InvoiceValue)
        SELECT
            ci.RowId,
            ci.CustomerType,
            COUNT(*) AS InvoiceCount,
            CONVERT(DECIMAL(18,2), SUM(ci.InvoiceAmount)) AS InvoiceValue
        FROM #CustomerInvoice ci
        INNER JOIN #SelectedCustomerEarly sc
            ON sc.CustomerType = ci.CustomerType
        GROUP BY
            ci.RowId,
            ci.CustomerType;

        CREATE TABLE #CollectionByType
        (
            RowId INT NOT NULL,
            CustomerType NVARCHAR(100) NOT NULL,
            InvoiceCollection DECIMAL(18,2) NOT NULL
        );

        CREATE CLUSTERED INDEX IX_CollectionByType_RowId_CustomerType
            ON #CollectionByType(RowId, CustomerType);

        INSERT INTO #CollectionByType(RowId, CustomerType, InvoiceCollection)
        SELECT
            cc.RowId,
            cc.CustomerType,
            CONVERT(DECIMAL(18,2), SUM(cc.InvoiceCollection)) AS InvoiceCollection
        FROM #CustomerCollection cc
        INNER JOIN #SelectedCustomerEarly sc
            ON sc.CustomerType = cc.CustomerType
        GROUP BY
            cc.RowId,
            cc.CustomerType;

        CREATE TABLE #CustomerSlots
        (
            RowId INT NOT NULL PRIMARY KEY,
            Customer1_Name NVARCHAR(100) NOT NULL,
            Customer1_InvoiceCount INT NOT NULL,
            Customer1_InvoiceValue DECIMAL(18,2) NOT NULL,
            Customer1_InvoiceCollection DECIMAL(18,2) NOT NULL,
            Customer2_Name NVARCHAR(100) NOT NULL,
            Customer2_InvoiceCount INT NOT NULL,
            Customer2_InvoiceValue DECIMAL(18,2) NOT NULL,
            Customer2_InvoiceCollection DECIMAL(18,2) NOT NULL,
            Customer3_Name NVARCHAR(100) NOT NULL,
            Customer3_InvoiceCount INT NOT NULL,
            Customer3_InvoiceValue DECIMAL(18,2) NOT NULL,
            Customer3_InvoiceCollection DECIMAL(18,2) NOT NULL,
            Customer4_Name NVARCHAR(100) NOT NULL,
            Customer4_InvoiceCount INT NOT NULL,
            Customer4_InvoiceValue DECIMAL(18,2) NOT NULL,
            Customer4_InvoiceCollection DECIMAL(18,2) NOT NULL,
            Customer5_Name NVARCHAR(100) NOT NULL,
            Customer5_InvoiceCount INT NOT NULL,
            Customer5_InvoiceValue DECIMAL(18,2) NOT NULL,
            Customer5_InvoiceCollection DECIMAL(18,2) NOT NULL,
            Customer6_Name NVARCHAR(100) NOT NULL,
            Customer6_InvoiceCount INT NOT NULL,
            Customer6_InvoiceValue DECIMAL(18,2) NOT NULL,
            Customer6_InvoiceCollection DECIMAL(18,2) NOT NULL
        );

        INSERT INTO #CustomerSlots
        (
            RowId,
            Customer1_Name,
            Customer1_InvoiceCount,
            Customer1_InvoiceValue,
            Customer1_InvoiceCollection,
            Customer2_Name,
            Customer2_InvoiceCount,
            Customer2_InvoiceValue,
            Customer2_InvoiceCollection,
            Customer3_Name,
            Customer3_InvoiceCount,
            Customer3_InvoiceValue,
            Customer3_InvoiceCollection,
            Customer4_Name,
            Customer4_InvoiceCount,
            Customer4_InvoiceValue,
            Customer4_InvoiceCollection,
            Customer5_Name,
            Customer5_InvoiceCount,
            Customer5_InvoiceValue,
            Customer5_InvoiceCollection,
            Customer6_Name,
            Customer6_InvoiceCount,
            Customer6_InvoiceValue,
            Customer6_InvoiceCollection
        )
        SELECT
            rr.RowId,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 1 THEN sc.CustomerType END), '') AS Customer1_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 1 THEN ISNULL(ibt.InvoiceCount, 0) ELSE 0 END), 0) AS Customer1_InvoiceCount,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 1 THEN ISNULL(ibt.InvoiceValue, 0) ELSE 0 END), 0) AS Customer1_InvoiceValue,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 1 THEN ISNULL(cbt.InvoiceCollection, 0) ELSE 0 END), 0) AS Customer1_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 2 THEN sc.CustomerType END), '') AS Customer2_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 2 THEN ISNULL(ibt.InvoiceCount, 0) ELSE 0 END), 0) AS Customer2_InvoiceCount,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 2 THEN ISNULL(ibt.InvoiceValue, 0) ELSE 0 END), 0) AS Customer2_InvoiceValue,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 2 THEN ISNULL(cbt.InvoiceCollection, 0) ELSE 0 END), 0) AS Customer2_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 3 THEN sc.CustomerType END), '') AS Customer3_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 3 THEN ISNULL(ibt.InvoiceCount, 0) ELSE 0 END), 0) AS Customer3_InvoiceCount,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 3 THEN ISNULL(ibt.InvoiceValue, 0) ELSE 0 END), 0) AS Customer3_InvoiceValue,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 3 THEN ISNULL(cbt.InvoiceCollection, 0) ELSE 0 END), 0) AS Customer3_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 4 THEN sc.CustomerType END), '') AS Customer4_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 4 THEN ISNULL(ibt.InvoiceCount, 0) ELSE 0 END), 0) AS Customer4_InvoiceCount,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 4 THEN ISNULL(ibt.InvoiceValue, 0) ELSE 0 END), 0) AS Customer4_InvoiceValue,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 4 THEN ISNULL(cbt.InvoiceCollection, 0) ELSE 0 END), 0) AS Customer4_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 5 THEN sc.CustomerType END), '') AS Customer5_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 5 THEN ISNULL(ibt.InvoiceCount, 0) ELSE 0 END), 0) AS Customer5_InvoiceCount,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 5 THEN ISNULL(ibt.InvoiceValue, 0) ELSE 0 END), 0) AS Customer5_InvoiceValue,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 5 THEN ISNULL(cbt.InvoiceCollection, 0) ELSE 0 END), 0) AS Customer5_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 6 THEN sc.CustomerType END), '') AS Customer6_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 6 THEN ISNULL(ibt.InvoiceCount, 0) ELSE 0 END), 0) AS Customer6_InvoiceCount,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 6 THEN ISNULL(ibt.InvoiceValue, 0) ELSE 0 END), 0) AS Customer6_InvoiceValue,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 6 THEN ISNULL(cbt.InvoiceCollection, 0) ELSE 0 END), 0) AS Customer6_InvoiceCollection
        FROM #CustomerReportRows rr
        CROSS JOIN #SelectedCustomerEarly sc
        LEFT JOIN #InvoiceByType ibt
            ON ibt.RowId = rr.RowId
           AND ibt.CustomerType = sc.CustomerType
        LEFT JOIN #CollectionByType cbt
            ON cbt.RowId = rr.RowId
           AND cbt.CustomerType = sc.CustomerType
        GROUP BY rr.RowId;

        SELECT
            rr.RowId AS TrrId_,
            rr.RowKey,
            rr.GroupName,
            rr.ZoneName,
            rr.AreaName,
            rr.Territory,
            ISNULL(it.InvoiceCount, 0) AS InvoiceCount,
            ISNULL(it.InvoiceValue, 0) AS InvoiceValue,
            ISNULL(ct.InvoiceCollection, 0) AS InvoiceCollection,
            ISNULL(cs.Customer1_Name, '') AS Customer1_Name,
            ISNULL(cs.Customer1_InvoiceCount, 0) AS Customer1_InvoiceCount,
            ISNULL(cs.Customer1_InvoiceValue, 0) AS Customer1_InvoiceValue,
            ISNULL(cs.Customer1_InvoiceCollection, 0) AS Customer1_InvoiceCollection,
            ISNULL(cs.Customer2_Name, '') AS Customer2_Name,
            ISNULL(cs.Customer2_InvoiceCount, 0) AS Customer2_InvoiceCount,
            ISNULL(cs.Customer2_InvoiceValue, 0) AS Customer2_InvoiceValue,
            ISNULL(cs.Customer2_InvoiceCollection, 0) AS Customer2_InvoiceCollection,
            ISNULL(cs.Customer3_Name, '') AS Customer3_Name,
            ISNULL(cs.Customer3_InvoiceCount, 0) AS Customer3_InvoiceCount,
            ISNULL(cs.Customer3_InvoiceValue, 0) AS Customer3_InvoiceValue,
            ISNULL(cs.Customer3_InvoiceCollection, 0) AS Customer3_InvoiceCollection,
            ISNULL(cs.Customer4_Name, '') AS Customer4_Name,
            ISNULL(cs.Customer4_InvoiceCount, 0) AS Customer4_InvoiceCount,
            ISNULL(cs.Customer4_InvoiceValue, 0) AS Customer4_InvoiceValue,
            ISNULL(cs.Customer4_InvoiceCollection, 0) AS Customer4_InvoiceCollection,
            ISNULL(cs.Customer5_Name, '') AS Customer5_Name,
            ISNULL(cs.Customer5_InvoiceCount, 0) AS Customer5_InvoiceCount,
            ISNULL(cs.Customer5_InvoiceValue, 0) AS Customer5_InvoiceValue,
            ISNULL(cs.Customer5_InvoiceCollection, 0) AS Customer5_InvoiceCollection,
            ISNULL(cs.Customer6_Name, '') AS Customer6_Name,
            ISNULL(cs.Customer6_InvoiceCount, 0) AS Customer6_InvoiceCount,
            ISNULL(cs.Customer6_InvoiceValue, 0) AS Customer6_InvoiceValue,
            ISNULL(cs.Customer6_InvoiceCollection, 0) AS Customer6_InvoiceCollection,
            ISNULL(it.TotalCustomer, 0) AS TotalCustomer
        FROM #CustomerReportRows rr
        LEFT JOIN #InvoiceTotals it
            ON it.RowId = rr.RowId
        LEFT JOIN #CollectionTotals ct
            ON ct.RowId = rr.RowId
        LEFT JOIN #CustomerSlots cs
            ON cs.RowId = rr.RowId;

        RETURN;
    END
    -- MetricGroup: provider early shortcut

    IF (LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))) = 'provider')

    BEGIN

        DECLARE @ProviderLevel NVARCHAR(20) = @NormalizedReportLevel;
        DECLARE @ProviderGroupIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@GroupName)), ''));
        DECLARE @ProviderZoneIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@ZoneName)), ''));
        DECLARE @ProviderAreaIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@AreaName)), ''));
        DECLARE @ProviderTerritoryIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@TerritoryName)), ''));
        DECLARE @HasSelectedProviderEarly BIT = 0;

        CREATE TABLE #SelectedProviderEarly

        (

            SlotNo INT NOT NULL PRIMARY KEY,

            ProviderType NVARCHAR(100) NOT NULL

        );

        CREATE UNIQUE NONCLUSTERED INDEX IX_SelectedProviderEarly_ProviderType
            ON #SelectedProviderEarly(ProviderType);



        IF (NULLIF(LTRIM(RTRIM(@ProviderTypes)), '') IS NOT NULL)

        BEGIN

            DECLARE @SafeProviderEarly NVARCHAR(MAX);

            DECLARE @SplitXmlProviderEarly XML;

            DECLARE @ProviderInputEarly TABLE

            (

                SlotNo INT IDENTITY(1,1) PRIMARY KEY,

                ProviderType NVARCHAR(100)

            );



            SET @SafeProviderEarly = (SELECT @ProviderTypes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

            SET @SafeProviderEarly = REPLACE(@SafeProviderEarly, ',', '</i><i>');

            SET @SplitXmlProviderEarly = TRY_CAST('<i>' + @SafeProviderEarly + '</i>' AS XML);



            IF (@SplitXmlProviderEarly IS NOT NULL)

            BEGIN

                INSERT INTO @ProviderInputEarly(ProviderType)

                SELECT LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(100)')))

                FROM @SplitXmlProviderEarly.nodes('/i') AS t(c)

                WHERE LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(100)'))) <> '';



                INSERT INTO #SelectedProviderEarly(SlotNo, ProviderType)

                SELECT SlotNo, ProviderType

                FROM @ProviderInputEarly

                WHERE SlotNo <= 4;

            END

        END



        IF EXISTS (SELECT 1 FROM #SelectedProviderEarly)
            SET @HasSelectedProviderEarly = 1;

        CREATE TABLE #ProviderGeo
        (
            TerritoryId INT NOT NULL PRIMARY KEY,
            AreaId INT NOT NULL,
            RegionId INT NOT NULL,
            GroupId INT NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            TerritoryName NVARCHAR(150) NOT NULL,
            RowId INT NOT NULL,
            RowKey NVARCHAR(500) NOT NULL
        );

        CREATE NONCLUSTERED INDEX IX_ProviderGeo_RowId
            ON #ProviderGeo(RowId);

        INSERT INTO #ProviderGeo
        (
            TerritoryId,
            AreaId,
            RegionId,
            GroupId,
            GroupName,
            ZoneName,
            AreaName,
            TerritoryName,
            RowId,
            RowKey
        )
        SELECT
            tr.TerritoryId,
            ara.AreaId,
            rgn.RegionId,
            grp.GroupId,
            grp.GroupName,
            rgn.RegionName AS ZoneName,
            ara.AreaName,
            tr.TerritoryName,
            CASE
                WHEN @ProviderLevel = 'group' THEN grp.GroupId
                WHEN @ProviderLevel = 'zone' THEN rgn.RegionId
                WHEN @ProviderLevel = 'area' THEN ara.AreaId
                ELSE tr.TerritoryId
            END AS RowId,
            CASE
                WHEN @ProviderLevel = 'group' THEN grp.GroupName
                WHEN @ProviderLevel = 'zone' THEN grp.GroupName + '|' + rgn.RegionName
                WHEN @ProviderLevel = 'area' THEN grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName
                ELSE grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName + '|' + tr.TerritoryName
            END AS RowKey
        FROM dbo.tblTerritory tr WITH (NOLOCK)
        INNER JOIN dbo.tblArea ara WITH (NOLOCK)
            ON ara.AreaId = tr.AreaId
           AND ara.IsActive = 1
        INNER JOIN dbo.tblRegion rgn WITH (NOLOCK)
            ON rgn.RegionId = ara.RegionId
           AND rgn.IsActive = 1
        INNER JOIN dbo.tbl_Group grp WITH (NOLOCK)
            ON grp.GroupId = rgn.GroupId
           AND grp.IsActive = 1
        WHERE (@ProviderGroupIdFilter IS NULL OR grp.GroupId = @ProviderGroupIdFilter)
          AND (@ProviderZoneIdFilter IS NULL OR rgn.RegionId = @ProviderZoneIdFilter)
          AND (@ProviderAreaIdFilter IS NULL OR ara.AreaId = @ProviderAreaIdFilter)
          AND (@ProviderTerritoryIdFilter IS NULL OR tr.TerritoryId = @ProviderTerritoryIdFilter)
        OPTION (RECOMPILE);

        CREATE TABLE #ProviderReportRows
        (
            RowId INT NOT NULL PRIMARY KEY,
            RowKey NVARCHAR(500) NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            Territory NVARCHAR(150) NOT NULL
        );

        INSERT INTO #ProviderReportRows(RowId, RowKey, GroupName, ZoneName, AreaName, Territory)
        SELECT
            pg.RowId,
            MIN(pg.RowKey) AS RowKey,
            MIN(pg.GroupName) AS GroupName,
            CASE WHEN @ProviderLevel IN ('zone', 'area', 'territory') THEN MIN(pg.ZoneName) ELSE '' END AS ZoneName,
            CASE WHEN @ProviderLevel IN ('area', 'territory') THEN MIN(pg.AreaName) ELSE '' END AS AreaName,
            CASE WHEN @ProviderLevel = 'territory' THEN MIN(pg.TerritoryName) ELSE '' END AS Territory
        FROM #ProviderGeo pg
        GROUP BY pg.RowId;

        CREATE TABLE #ProviderInvoice
        (
            RowId INT NOT NULL,
            ProviderType NVARCHAR(100) NOT NULL,
            InvoiceCount INT NOT NULL,
            InvoiceValue DECIMAL(18,2) NOT NULL,
            PRIMARY KEY CLUSTERED (RowId, ProviderType)
        );

        CREATE NONCLUSTERED INDEX IX_ProviderInvoice_ProviderType
            ON #ProviderInvoice(ProviderType)
            INCLUDE (RowId, InvoiceCount, InvoiceValue);

        INSERT INTO #ProviderInvoice(RowId, ProviderType, InvoiceCount, InvoiceValue)
        SELECT
            pg.RowId,
            ppt.ProgramTypeName AS ProviderType,
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2), ISNULL(SUM(ID.DeliveryNetAmount), 0)) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
            ON A.InvoiceId = ID.InvoiceId
        INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId
        INNER JOIN dbo.tblProgramType ppt WITH (NOLOCK)
            ON ppt.ProgramTypeId = ord.ProgramTypeId
        INNER JOIN #ProviderGeo pg
            ON pg.TerritoryId = ord.TerritoryId
        WHERE A.UpdateDate >= @FromDate
          AND A.UpdateDate < DATEADD(DAY, 1, @ToDate)
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(ppt.ProgramTypeName)), '') IS NOT NULL
          AND
          (
              @HasSelectedProviderEarly = 0
              OR EXISTS
                 (
                     SELECT 1
                     FROM #SelectedProviderEarly sp
                     WHERE sp.ProviderType = ppt.ProgramTypeName
                 )
          )
        GROUP BY
            pg.RowId,
            ppt.ProgramTypeName
        OPTION (RECOMPILE);

        CREATE TABLE #ProviderCollection
        (
            RowId INT NOT NULL,
            ProviderType NVARCHAR(100) NOT NULL,
            InvoiceCollection DECIMAL(18,2) NOT NULL,
            PRIMARY KEY CLUSTERED (RowId, ProviderType)
        );

        INSERT INTO #ProviderCollection(RowId, ProviderType, InvoiceCollection)
        SELECT
            pg.RowId,
            ppt.ProgramTypeName AS ProviderType,
            CONVERT(DECIMAL(18,2), ISNULL(SUM(cstp.TPAmount + cstp.VATAmount), 0)) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN dbo.tblInvoice A2 WITH (NOLOCK)
            ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN dbo.tblOrder ord2 WITH (NOLOCK)
            ON ord2.OrderId = A2.OrderId
        INNER JOIN dbo.tblProgramType ppt WITH (NOLOCK)
            ON ppt.ProgramTypeId = ord2.ProgramTypeId
        INNER JOIN #ProviderGeo pg
            ON pg.TerritoryId = ord2.TerritoryId
        WHERE cstp.custPaymentDate >= @FromDate
          AND cstp.custPaymentDate < DATEADD(DAY, 1, @ToDate)
          AND NULLIF(LTRIM(RTRIM(ppt.ProgramTypeName)), '') IS NOT NULL
          AND
          (
              @HasSelectedProviderEarly = 0
              OR EXISTS
                 (
                     SELECT 1
                     FROM #SelectedProviderEarly sp
                     WHERE sp.ProviderType = ppt.ProgramTypeName
                 )
          )
        GROUP BY
            pg.RowId,
            ppt.ProgramTypeName
        OPTION (RECOMPILE);

        IF NOT EXISTS (SELECT 1 FROM #SelectedProviderEarly)

        BEGIN

            ;WITH ranked AS

            (

                SELECT ProviderType, ROW_NUMBER() OVER (ORDER BY ProviderType) AS rn

                FROM
                (
                    SELECT DISTINCT ProviderType
                    FROM #ProviderInvoice
                ) p

            )

            INSERT INTO #SelectedProviderEarly(SlotNo, ProviderType)

            SELECT rn, ProviderType

            FROM ranked

            WHERE rn <= 4;

        END

        CREATE TABLE #ProviderSlots
        (
            RowId INT NOT NULL PRIMARY KEY,
            ProviderTypeWiseChemistCoverage INT NOT NULL,
            ProviderTypeWiseInvoiceAmount DECIMAL(18,2) NOT NULL,
            ProviderTypeWiseCollection DECIMAL(18,2) NOT NULL,
            ProviderType1_Name NVARCHAR(100) NOT NULL,
            ProviderType1_InvoiceAmount DECIMAL(18,2) NOT NULL,
            ProviderType1_ChemistCoverage INT NOT NULL,
            ProviderType1_InvoiceCollection DECIMAL(18,2) NOT NULL,
            ProviderType2_Name NVARCHAR(100) NOT NULL,
            ProviderType2_InvoiceAmount DECIMAL(18,2) NOT NULL,
            ProviderType2_ChemistCoverage INT NOT NULL,
            ProviderType2_InvoiceCollection DECIMAL(18,2) NOT NULL,
            ProviderType3_Name NVARCHAR(100) NOT NULL,
            ProviderType3_InvoiceAmount DECIMAL(18,2) NOT NULL,
            ProviderType3_ChemistCoverage INT NOT NULL,
            ProviderType3_InvoiceCollection DECIMAL(18,2) NOT NULL,
            ProviderType4_Name NVARCHAR(100) NOT NULL,
            ProviderType4_InvoiceAmount DECIMAL(18,2) NOT NULL,
            ProviderType4_ChemistCoverage INT NOT NULL,
            ProviderType4_InvoiceCollection DECIMAL(18,2) NOT NULL
        );

        INSERT INTO #ProviderSlots
        (
            RowId,
            ProviderTypeWiseChemistCoverage,
            ProviderTypeWiseInvoiceAmount,
            ProviderTypeWiseCollection,
            ProviderType1_Name,
            ProviderType1_InvoiceAmount,
            ProviderType1_ChemistCoverage,
            ProviderType1_InvoiceCollection,
            ProviderType2_Name,
            ProviderType2_InvoiceAmount,
            ProviderType2_ChemistCoverage,
            ProviderType2_InvoiceCollection,
            ProviderType3_Name,
            ProviderType3_InvoiceAmount,
            ProviderType3_ChemistCoverage,
            ProviderType3_InvoiceCollection,
            ProviderType4_Name,
            ProviderType4_InvoiceAmount,
            ProviderType4_ChemistCoverage,
            ProviderType4_InvoiceCollection
        )
        SELECT
            rr.RowId,
            ISNULL(SUM(ISNULL(pi.InvoiceCount, 0)), 0) AS ProviderTypeWiseChemistCoverage,
            ISNULL(SUM(ISNULL(pi.InvoiceValue, 0)), 0) AS ProviderTypeWiseInvoiceAmount,
            ISNULL(SUM(ISNULL(pc.InvoiceCollection, 0)), 0) AS ProviderTypeWiseCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 1 THEN sp.ProviderType END), '') AS ProviderType1_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 1 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS ProviderType1_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 1 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS ProviderType1_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 1 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS ProviderType1_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 2 THEN sp.ProviderType END), '') AS ProviderType2_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 2 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS ProviderType2_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 2 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS ProviderType2_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 2 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS ProviderType2_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 3 THEN sp.ProviderType END), '') AS ProviderType3_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 3 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS ProviderType3_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 3 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS ProviderType3_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 3 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS ProviderType3_InvoiceCollection,
            ISNULL(MAX(CASE WHEN sp.SlotNo = 4 THEN sp.ProviderType END), '') AS ProviderType4_Name,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 4 THEN ISNULL(pi.InvoiceValue, 0) ELSE 0 END), 0) AS ProviderType4_InvoiceAmount,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 4 THEN ISNULL(pi.InvoiceCount, 0) ELSE 0 END), 0) AS ProviderType4_ChemistCoverage,
            ISNULL(SUM(CASE WHEN sp.SlotNo = 4 THEN ISNULL(pc.InvoiceCollection, 0) ELSE 0 END), 0) AS ProviderType4_InvoiceCollection
        FROM #ProviderReportRows rr
        CROSS JOIN #SelectedProviderEarly sp
        LEFT JOIN #ProviderInvoice pi
            ON pi.RowId = rr.RowId
           AND pi.ProviderType = sp.ProviderType
        LEFT JOIN #ProviderCollection pc
            ON pc.RowId = rr.RowId
           AND pc.ProviderType = sp.ProviderType
        GROUP BY rr.RowId;

        SELECT

            rr.RowId AS TrrId_,

            rr.RowKey,

            rr.GroupName,

            rr.ZoneName,

            rr.AreaName,

            rr.Territory,

            ISNULL(ps.ProviderTypeWiseChemistCoverage, 0) AS ProviderTypeWiseChemistCoverage,

            ISNULL(ps.ProviderTypeWiseInvoiceAmount, 0) AS ProviderTypeWiseInvoiceAmount,

            ISNULL(ps.ProviderTypeWiseCollection, 0) AS ProviderTypeWiseCollection,

            ISNULL(ps.ProviderType1_Name, '') AS ProviderType1_Name,

            ISNULL(ps.ProviderType1_InvoiceAmount, 0) AS ProviderType1_InvoiceAmount,

            ISNULL(ps.ProviderType1_ChemistCoverage, 0) AS ProviderType1_ChemistCoverage,

            ISNULL(ps.ProviderType1_InvoiceCollection, 0) AS ProviderType1_InvoiceCollection,

            ISNULL(ps.ProviderType2_Name, '') AS ProviderType2_Name,

            ISNULL(ps.ProviderType2_InvoiceAmount, 0) AS ProviderType2_InvoiceAmount,

            ISNULL(ps.ProviderType2_ChemistCoverage, 0) AS ProviderType2_ChemistCoverage,

            ISNULL(ps.ProviderType2_InvoiceCollection, 0) AS ProviderType2_InvoiceCollection,

            ISNULL(ps.ProviderType3_Name, '') AS ProviderType3_Name,

            ISNULL(ps.ProviderType3_InvoiceAmount, 0) AS ProviderType3_InvoiceAmount,

            ISNULL(ps.ProviderType3_ChemistCoverage, 0) AS ProviderType3_ChemistCoverage,

            ISNULL(ps.ProviderType3_InvoiceCollection, 0) AS ProviderType3_InvoiceCollection,

            ISNULL(ps.ProviderType4_Name, '') AS ProviderType4_Name,

            ISNULL(ps.ProviderType4_InvoiceAmount, 0) AS ProviderType4_InvoiceAmount,

            ISNULL(ps.ProviderType4_ChemistCoverage, 0) AS ProviderType4_ChemistCoverage,

            ISNULL(ps.ProviderType4_InvoiceCollection, 0) AS ProviderType4_InvoiceCollection

        FROM #ProviderReportRows rr

        LEFT JOIN #ProviderSlots ps ON ps.RowId = rr.RowId;



        RETURN;

    END

    -- MetricGroup: campaign early shortcut

    IF (LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))) = 'campaign')

    BEGIN

        DECLARE @CampaignLevel NVARCHAR(20) = @NormalizedReportLevel;
        DECLARE @CampaignGroupIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@GroupName)), ''));
        DECLARE @CampaignZoneIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@ZoneName)), ''));
        DECLARE @CampaignAreaIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@AreaName)), ''));
        DECLARE @CampaignTerritoryIdFilter INT = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@TerritoryName)), ''));
        DECLARE @HasSelectedCampaignEarly BIT = 0;

        CREATE TABLE #SelectedCampaignEarly

        (

            SlotNo INT NOT NULL PRIMARY KEY,

            CampaignCode NVARCHAR(200) NOT NULL

        );

        CREATE UNIQUE NONCLUSTERED INDEX IX_SelectedCampaignEarly_CampaignCode
            ON #SelectedCampaignEarly(CampaignCode);



        IF (NULLIF(LTRIM(RTRIM(@CampaignCodes)), '') IS NOT NULL)

        BEGIN

            DECLARE @SafeCampaignEarly NVARCHAR(MAX);

            DECLARE @SplitXmlCampaignEarly XML;

            DECLARE @CampaignInputEarly TABLE

            (

                SlotNo INT IDENTITY(1,1) PRIMARY KEY,

                CampaignCode NVARCHAR(200)

            );



            SET @SafeCampaignEarly = (SELECT @CampaignCodes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

            SET @SafeCampaignEarly = REPLACE(@SafeCampaignEarly, ',', '</i><i>');

            SET @SplitXmlCampaignEarly = TRY_CAST('<i>' + @SafeCampaignEarly + '</i>' AS XML);



            IF (@SplitXmlCampaignEarly IS NOT NULL)

            BEGIN

                INSERT INTO @CampaignInputEarly(CampaignCode)

                SELECT LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(200)')))

                FROM @SplitXmlCampaignEarly.nodes('/i') AS t(c)

                WHERE LTRIM(RTRIM(t.c.value('.', 'NVARCHAR(200)'))) <> '';



                INSERT INTO #SelectedCampaignEarly(SlotNo, CampaignCode)

                SELECT SlotNo, CampaignCode

                FROM @CampaignInputEarly

                WHERE SlotNo <= 4;

            END

        END



        IF EXISTS (SELECT 1 FROM #SelectedCampaignEarly)
            SET @HasSelectedCampaignEarly = 1;

        CREATE TABLE #CampaignGeo
        (
            TerritoryId INT NOT NULL PRIMARY KEY,
            AreaId INT NOT NULL,
            RegionId INT NOT NULL,
            GroupId INT NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            TerritoryName NVARCHAR(150) NOT NULL,
            RowId INT NOT NULL,
            RowKey NVARCHAR(500) NOT NULL
        );

        CREATE NONCLUSTERED INDEX IX_CampaignGeo_RowId
            ON #CampaignGeo(RowId);

        INSERT INTO #CampaignGeo
        (
            TerritoryId,
            AreaId,
            RegionId,
            GroupId,
            GroupName,
            ZoneName,
            AreaName,
            TerritoryName,
            RowId,
            RowKey
        )
        SELECT
            tr.TerritoryId,
            ara.AreaId,
            rgn.RegionId,
            grp.GroupId,
            grp.GroupName,
            rgn.RegionName AS ZoneName,
            ara.AreaName,
            tr.TerritoryName,
            CASE
                WHEN @CampaignLevel = 'group' THEN grp.GroupId
                WHEN @CampaignLevel = 'zone' THEN rgn.RegionId
                WHEN @CampaignLevel = 'area' THEN ara.AreaId
                ELSE tr.TerritoryId
            END AS RowId,
            CASE
                WHEN @CampaignLevel = 'group' THEN grp.GroupName
                WHEN @CampaignLevel = 'zone' THEN grp.GroupName + '|' + rgn.RegionName
                WHEN @CampaignLevel = 'area' THEN grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName
                ELSE grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName + '|' + tr.TerritoryName
            END AS RowKey
        FROM dbo.tblTerritory tr WITH (NOLOCK)
        INNER JOIN dbo.tblArea ara WITH (NOLOCK)
            ON ara.AreaId = tr.AreaId
           AND ara.IsActive = 1
        INNER JOIN dbo.tblRegion rgn WITH (NOLOCK)
            ON rgn.RegionId = ara.RegionId
           AND rgn.IsActive = 1
        INNER JOIN dbo.tbl_Group grp WITH (NOLOCK)
            ON grp.GroupId = rgn.GroupId
           AND grp.IsActive = 1
        WHERE (@CampaignGroupIdFilter IS NULL OR grp.GroupId = @CampaignGroupIdFilter)
          AND (@CampaignZoneIdFilter IS NULL OR rgn.RegionId = @CampaignZoneIdFilter)
          AND (@CampaignAreaIdFilter IS NULL OR ara.AreaId = @CampaignAreaIdFilter)
          AND (@CampaignTerritoryIdFilter IS NULL OR tr.TerritoryId = @CampaignTerritoryIdFilter)
        OPTION (RECOMPILE);

        CREATE TABLE #CampaignReportRows
        (
            RowId INT NOT NULL PRIMARY KEY,
            RowKey NVARCHAR(500) NOT NULL,
            GroupName NVARCHAR(150) NOT NULL,
            ZoneName NVARCHAR(150) NOT NULL,
            AreaName NVARCHAR(150) NOT NULL,
            Territory NVARCHAR(150) NOT NULL
        );

        INSERT INTO #CampaignReportRows(RowId, RowKey, GroupName, ZoneName, AreaName, Territory)
        SELECT
            cg.RowId,
            MIN(cg.RowKey) AS RowKey,
            MIN(cg.GroupName) AS GroupName,
            CASE WHEN @CampaignLevel IN ('zone', 'area', 'territory') THEN MIN(cg.ZoneName) ELSE '' END AS ZoneName,
            CASE WHEN @CampaignLevel IN ('area', 'territory') THEN MIN(cg.AreaName) ELSE '' END AS AreaName,
            CASE WHEN @CampaignLevel = 'territory' THEN MIN(cg.TerritoryName) ELSE '' END AS Territory
        FROM #CampaignGeo cg
        GROUP BY cg.RowId;

        CREATE TABLE #CampaignInvoice
        (
            RowId INT NOT NULL,
            CampaignCode NVARCHAR(200) NOT NULL,
            CampaignInvoiceValue DECIMAL(18,2) NOT NULL,
            PRIMARY KEY CLUSTERED (RowId, CampaignCode)
        );

        CREATE NONCLUSTERED INDEX IX_CampaignInvoice_CampaignCode
            ON #CampaignInvoice(CampaignCode)
            INCLUDE (RowId, CampaignInvoiceValue);

        INSERT INTO #CampaignInvoice(RowId, CampaignCode, CampaignInvoiceValue)
        SELECT
            cg.RowId,
            ordD.CampaignName AS CampaignCode,
            CONVERT(DECIMAL(18,2), ISNULL(SUM(ID.DeliveryNetAmount), 0)) AS CampaignInvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
            ON A.InvoiceId = ID.InvoiceId
        INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId
        INNER JOIN dbo.tblOrderDetail ordD WITH (NOLOCK)
            ON ordD.OrderDetailId = ID.OrderDetailsId
        INNER JOIN #CampaignGeo cg
            ON cg.TerritoryId = ord.TerritoryId
        WHERE A.UpdateDate >= @FromDate
          AND A.UpdateDate < DATEADD(DAY, 1, @ToDate)
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(ordD.CampaignName)), '') IS NOT NULL
          AND
          (
              @HasSelectedCampaignEarly = 0
              OR EXISTS
                 (
                     SELECT 1
                     FROM #SelectedCampaignEarly sc
                     WHERE sc.CampaignCode = ordD.CampaignName
                 )
          )
        GROUP BY
            cg.RowId,
            ordD.CampaignName
        OPTION (RECOMPILE);

        IF NOT EXISTS (SELECT 1 FROM #SelectedCampaignEarly)

        BEGIN

            ;WITH ranked AS

            (

                SELECT CampaignCode, ROW_NUMBER() OVER (ORDER BY CampaignCode) AS rn

                FROM
                (
                    SELECT DISTINCT CampaignCode
                    FROM #CampaignInvoice
                ) c

            )

            INSERT INTO #SelectedCampaignEarly(SlotNo, CampaignCode)

            SELECT rn, CampaignCode

            FROM ranked

            WHERE rn <= 4;

        END

        CREATE TABLE #CampaignSlots
        (
            RowId INT NOT NULL PRIMARY KEY,
            CampaignInvoiceValue DECIMAL(18,2) NOT NULL,
            CampaignCollection DECIMAL(18,2) NOT NULL,
            Campaign1_Name NVARCHAR(200) NOT NULL,
            Campaign1_Invoice DECIMAL(18,2) NOT NULL,
            Campaign1_Collection DECIMAL(18,2) NOT NULL,
            Campaign2_Name NVARCHAR(200) NOT NULL,
            Campaign2_Invoice DECIMAL(18,2) NOT NULL,
            Campaign2_Collection DECIMAL(18,2) NOT NULL,
            Campaign3_Name NVARCHAR(200) NOT NULL,
            Campaign3_Invoice DECIMAL(18,2) NOT NULL,
            Campaign3_Collection DECIMAL(18,2) NOT NULL,
            Campaign4_Name NVARCHAR(200) NOT NULL,
            Campaign4_Invoice DECIMAL(18,2) NOT NULL,
            Campaign4_Collection DECIMAL(18,2) NOT NULL
        );

        INSERT INTO #CampaignSlots
        (
            RowId,
            CampaignInvoiceValue,
            CampaignCollection,
            Campaign1_Name,
            Campaign1_Invoice,
            Campaign1_Collection,
            Campaign2_Name,
            Campaign2_Invoice,
            Campaign2_Collection,
            Campaign3_Name,
            Campaign3_Invoice,
            Campaign3_Collection,
            Campaign4_Name,
            Campaign4_Invoice,
            Campaign4_Collection
        )
        SELECT
            rr.RowId,
            ISNULL(SUM(ISNULL(ic.CampaignInvoiceValue, 0)), 0) AS CampaignInvoiceValue,
            CONVERT(DECIMAL(18,2), 0) AS CampaignCollection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 1 THEN sc.CampaignCode END), '') AS Campaign1_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 1 THEN ISNULL(ic.CampaignInvoiceValue, 0) ELSE 0 END), 0) AS Campaign1_Invoice,
            CONVERT(DECIMAL(18,2), 0) AS Campaign1_Collection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 2 THEN sc.CampaignCode END), '') AS Campaign2_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 2 THEN ISNULL(ic.CampaignInvoiceValue, 0) ELSE 0 END), 0) AS Campaign2_Invoice,
            CONVERT(DECIMAL(18,2), 0) AS Campaign2_Collection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 3 THEN sc.CampaignCode END), '') AS Campaign3_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 3 THEN ISNULL(ic.CampaignInvoiceValue, 0) ELSE 0 END), 0) AS Campaign3_Invoice,
            CONVERT(DECIMAL(18,2), 0) AS Campaign3_Collection,
            ISNULL(MAX(CASE WHEN sc.SlotNo = 4 THEN sc.CampaignCode END), '') AS Campaign4_Name,
            ISNULL(SUM(CASE WHEN sc.SlotNo = 4 THEN ISNULL(ic.CampaignInvoiceValue, 0) ELSE 0 END), 0) AS Campaign4_Invoice,
            CONVERT(DECIMAL(18,2), 0) AS Campaign4_Collection
        FROM #CampaignReportRows rr
        CROSS JOIN #SelectedCampaignEarly sc
        LEFT JOIN #CampaignInvoice ic
            ON ic.RowId = rr.RowId
           AND ic.CampaignCode = sc.CampaignCode
        GROUP BY rr.RowId;

        SELECT
            rr.RowId AS TrrId_,
            rr.RowKey,
            rr.GroupName,
            rr.ZoneName,
            rr.AreaName,
            rr.Territory,
            ISNULL(cs.CampaignInvoiceValue, 0) AS CampaignInvoiceValue,
            ISNULL(cs.CampaignCollection, 0) AS CampaignCollection,
            ISNULL(cs.Campaign1_Name, '') AS Campaign1_Name,
            ISNULL(cs.Campaign1_Invoice, 0) AS Campaign1_Invoice,
            ISNULL(cs.Campaign1_Collection, 0) AS Campaign1_Collection,
            ISNULL(cs.Campaign2_Name, '') AS Campaign2_Name,
            ISNULL(cs.Campaign2_Invoice, 0) AS Campaign2_Invoice,
            ISNULL(cs.Campaign2_Collection, 0) AS Campaign2_Collection,
            ISNULL(cs.Campaign3_Name, '') AS Campaign3_Name,
            ISNULL(cs.Campaign3_Invoice, 0) AS Campaign3_Invoice,
            ISNULL(cs.Campaign3_Collection, 0) AS Campaign3_Collection,
            ISNULL(cs.Campaign4_Name, '') AS Campaign4_Name,
            ISNULL(cs.Campaign4_Invoice, 0) AS Campaign4_Invoice,
            ISNULL(cs.Campaign4_Collection, 0) AS Campaign4_Collection
        FROM #CampaignReportRows rr
        LEFT JOIN #CampaignSlots cs
            ON cs.RowId = rr.RowId;



        RETURN;

    END

-- MetricGroup: doctorDcr early shortcut
    DECLARE @DoctorDcrMetricGroup NVARCHAR(100) =
        REPLACE(REPLACE(REPLACE(REPLACE(LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))), ' ', ''), '&', ''), '-', ''), '_', '');

    IF (@DoctorDcrMetricGroup IN ('doctordcr', 'dcr'))

    BEGIN

        DECLARE @DoctorDcrLevel NVARCHAR(20) = @NormalizedReportLevel;

        ;WITH geo_territory AS
        (
            SELECT
                tr.TerritoryId,
                ara.AreaId,
                rgn.RegionId,
                grp.GroupId,
                grp.GroupName,
                rgn.RegionName AS ZoneName,
                ara.AreaName,
                tr.TerritoryName
            FROM dbo.tblTerritory tr WITH (NOLOCK)
            INNER JOIN dbo.tblArea ara WITH (NOLOCK) ON ara.AreaId = tr.AreaId AND ara.IsActive = 1
            INNER JOIN dbo.tblRegion rgn WITH (NOLOCK) ON rgn.RegionId = ara.RegionId AND rgn.IsActive = 1
            INNER JOIN dbo.tbl_Group grp WITH (NOLOCK) ON grp.GroupId = rgn.GroupId AND grp.IsActive = 1
            WHERE (ISNULL(@GroupName, '') = '' OR grp.GroupId = TRY_CONVERT(INT, @GroupName))
              AND (ISNULL(@ZoneName, '') = '' OR rgn.RegionId = TRY_CONVERT(INT, @ZoneName))
              AND (ISNULL(@AreaName, '') = '' OR ara.AreaId = TRY_CONVERT(INT, @AreaName))
              AND (ISNULL(@TerritoryName, '') = '' OR tr.TerritoryId = TRY_CONVERT(INT, @TerritoryName))
        ),
        report_rows AS
        (
            SELECT DISTINCT
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END AS RowId,
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupName
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.GroupName + '|' + gt.ZoneName
                    WHEN @DoctorDcrLevel = 'area' THEN gt.GroupName + '|' + gt.ZoneName + '|' + gt.AreaName
                    ELSE gt.GroupName + '|' + gt.ZoneName + '|' + gt.AreaName + '|' + gt.TerritoryName
                END AS RowKey,
                gt.GroupName,
                CASE WHEN @DoctorDcrLevel IN ('zone', 'area', 'territory') THEN gt.ZoneName ELSE '' END AS ZoneName,
                CASE WHEN @DoctorDcrLevel IN ('area', 'territory') THEN gt.AreaName ELSE '' END AS AreaName,
                CASE WHEN @DoctorDcrLevel = 'territory' THEN gt.TerritoryName ELSE '' END AS Territory
            FROM geo_territory gt
        ),
        dcr_agg AS
        (
            SELECT
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END AS RowId,
                SUM(CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 THEN 1 ELSE 0 END) AS TotalDoctorDCR,
                COUNT(DISTINCT CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 THEN C.DoctorID END) AS TotalDoctorDCRCov,
                SUM(CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 AND C.DoctorTypeID_DCR = 2 THEN 1 ELSE 0 END) AS TotalDoctorDCRGMP,
                COUNT(DISTINCT CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 AND C.DoctorTypeID_DCR = 2 THEN C.DoctorID END) AS TotalDoctorDCRGMPCov,
                SUM(CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 AND C.DoctorTypeID_DCR = 1 THEN 1 ELSE 0 END) AS TotalDoctorDCRNonGMP,
                COUNT(DISTINCT CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 AND C.DoctorTypeID_DCR = 1 THEN C.DoctorID END) AS TotalDoctorDCRNonGMPCov
            FROM dbo.tbl_DCRInfo C WITH (NOLOCK)
            INNER JOIN geo_territory gt ON gt.TerritoryId = C.TerritoryId
            WHERE C.EntryDate >= @FromDate
              AND C.EntryDate < DATEADD(DAY, 1, @ToDate)
            GROUP BY
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END
        ),
        doctor_agg AS
        (
            SELECT
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END AS RowId,
                SUM(CASE WHEN ISNULL(dm.ApprovalStatus, 0) = 2 THEN 1 ELSE 0 END) AS TotalDoctor,
                SUM(CASE WHEN ISNULL(dm.ApprovalStatus, 0) = 2 AND dm.DoctorTypeID = 2 THEN 1 ELSE 0 END) AS TotalDoctorGMP,
                COUNT(DISTINCT CASE WHEN ISNULL(dm.ApprovalStatus, 0) = 2 AND dm.DoctorTypeID = 1 THEN dm.DoctorID END) AS TotalDoctorNonGMP
            FROM dbo.tblDoctorMaster dm WITH (NOLOCK)
            INNER JOIN geo_territory gt ON gt.TerritoryId = dm.TerritoryId
            GROUP BY
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END
        )
        SELECT
            rr.RowId AS TrrId_,
            rr.RowKey,
            rr.GroupName,
            rr.ZoneName,
            rr.AreaName,
            rr.Territory,
            ISNULL(doc.TotalDoctorGMP, 0) AS TotalGmpCount,
            ISNULL(doc.TotalDoctorNonGMP, 0) AS TotalNonGmpCount,
            ISNULL(doc.TotalDoctor, 0) AS TotalCount,
            ISNULL(dcr.TotalDoctorDCRGMPCov, 0) AS DCRGmpDoctorCoverage,
            ISNULL(dcr.TotalDoctorDCRNonGMPCov, 0) AS DCRNonGmpDoctorCoverage,
            ISNULL(dcr.TotalDoctorDCRCov, 0) AS DCRTotalDoctorCoverage,
            ISNULL(dcr.TotalDoctorDCRGMP, 0) AS DCRTotalGmpCount,
            ISNULL(dcr.TotalDoctorDCRNonGMP, 0) AS DCRTotalNonGmpCount,
            ISNULL(dcr.TotalDoctorDCR, 0) AS DCRTotalCount,
            ISNULL(dcr.TotalDoctorDCRGMP, 0) AS SumOfGmpDcr,
            ISNULL(dcr.TotalDoctorDCRNonGMP, 0) AS SumOfNonGmpDcr,
            ISNULL(dcr.TotalDoctorDCR, 0) AS TotalDcr,
            ISNULL(dcr.TotalDoctorDCRGMP, 0) AS TotalDoctorDCRGMPCount,
            ISNULL(dcr.TotalDoctorDCRNonGMP, 0) AS TotalDoctorDCRNONGMPCount,
            ISNULL(dcr.TotalDoctorDCR, 0) AS TotalDoctorDCRCount
        FROM report_rows rr
        LEFT JOIN dcr_agg dcr ON dcr.RowId = rr.RowId
        LEFT JOIN doctor_agg doc ON doc.RowId = rr.RowId
        ORDER BY rr.RowKey;

        RETURN;

    END

-- MetricGroup: doctorRx early shortcut

    DECLARE @DoctorRxMetricGroup NVARCHAR(100) =
        REPLACE(REPLACE(REPLACE(REPLACE(LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))), ' ', ''), '&', ''), '-', ''), '_', '');

    IF (@DoctorRxMetricGroup IN ('doctorrx', 'dcrrx'))

    BEGIN

        DECLARE @DoctorRxLevel NVARCHAR(20) = LOWER(LTRIM(RTRIM(ISNULL(@reportLevel, 'territory'))));

        IF (@DoctorRxLevel NOT IN ('group', 'zone', 'area', 'territory'))
            SET @DoctorRxLevel = 'territory';

        ;WITH geo_territory AS
        (
            SELECT
                tr.TerritoryId,
                ara.AreaId,
                rgn.RegionId,
                grp.GroupId,
                grp.GroupName,
                rgn.RegionName AS ZoneName,
                ara.AreaName,
                tr.TerritoryName
            FROM dbo.tblTerritory tr WITH (NOLOCK)
            INNER JOIN dbo.tblArea ara WITH (NOLOCK) ON ara.AreaId = tr.AreaId AND ara.IsActive = 1
            INNER JOIN dbo.tblRegion rgn WITH (NOLOCK) ON rgn.RegionId = ara.RegionId AND rgn.IsActive = 1
            INNER JOIN dbo.tbl_Group grp WITH (NOLOCK) ON grp.GroupId = rgn.GroupId AND grp.IsActive = 1
            WHERE (ISNULL(@GroupName, '') = '' OR grp.GroupId = TRY_CONVERT(INT, @GroupName))
              AND (ISNULL(@ZoneName, '') = '' OR rgn.RegionId = TRY_CONVERT(INT, @ZoneName))
              AND (ISNULL(@AreaName, '') = '' OR ara.AreaId = TRY_CONVERT(INT, @AreaName))
              AND (ISNULL(@TerritoryName, '') = '' OR tr.TerritoryId = TRY_CONVERT(INT, @TerritoryName))
        ),
        report_rows AS
        (
            SELECT DISTINCT
                CASE
                    WHEN @DoctorRxLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorRxLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorRxLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END AS RowId,
                CASE
                    WHEN @DoctorRxLevel = 'group' THEN gt.GroupName
                    WHEN @DoctorRxLevel = 'zone' THEN gt.GroupName + '|' + gt.ZoneName
                    WHEN @DoctorRxLevel = 'area' THEN gt.GroupName + '|' + gt.ZoneName + '|' + gt.AreaName
                    ELSE gt.GroupName + '|' + gt.ZoneName + '|' + gt.AreaName + '|' + gt.TerritoryName
                END AS RowKey,
                gt.GroupName,
                CASE WHEN @DoctorRxLevel IN ('zone', 'area', 'territory') THEN gt.ZoneName ELSE '' END AS ZoneName,
                CASE WHEN @DoctorRxLevel IN ('area', 'territory') THEN gt.AreaName ELSE '' END AS AreaName,
                CASE WHEN @DoctorRxLevel = 'territory' THEN gt.TerritoryName ELSE '' END AS Territory
            FROM geo_territory gt
        ),
        
        rx_agg AS
        (
            SELECT
                CASE
                    WHEN @DoctorRxLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorRxLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorRxLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END AS RowId,
                SUM(CASE WHEN C.DoctorTypeId_RX = 2 THEN 1 ELSE 0 END) AS TotalDoctorRXGMP,
                COUNT(DISTINCT CASE WHEN C.DoctorTypeId_RX = 2 THEN C.DoctorID END) AS TotalDoctorRXGMPCov,
                SUM(CASE WHEN C.DoctorTypeId_RX = 1 THEN 1 ELSE 0 END) AS TotalDoctorRXNonGMP,
                COUNT(DISTINCT CASE WHEN C.DoctorTypeId_RX = 1 THEN C.DoctorID END) AS TotalDoctorRXNonGMPCov,
                SUM(CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 THEN 1 ELSE 0 END) AS TotalDoctorRX,
                COUNT(DISTINCT CASE WHEN ISNULL(C.ApprovalStatus, 0) = 2 THEN C.DoctorID END) AS TotalDoctorRXCov
            FROM dbo.tbl_PrescriptionMaster C WITH (NOLOCK)
            INNER JOIN geo_territory gt ON gt.TerritoryId = C.TerritoryId
            WHERE C.EntryDate >= @FromDate
              AND C.EntryDate < DATEADD(DAY, 1, @ToDate)
            GROUP BY
                CASE
                    WHEN @DoctorRxLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorRxLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorRxLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END
        ),

         doctor_agg AS
        (
            SELECT
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId
                END AS RowId,
                SUM(CASE WHEN ISNULL(dm.ApprovalStatus, 0) = 2 THEN 1 ELSE 0 END) AS TotalDoctor,
                SUM(CASE WHEN ISNULL(dm.ApprovalStatus, 0) = 2 AND dm.DoctorTypeID = 2 THEN 1 ELSE 0 END) AS TotalDoctorGMP,
                COUNT(DISTINCT CASE WHEN ISNULL(dm.ApprovalStatus, 0) = 2 AND dm.DoctorTypeID = 1 THEN dm.DoctorID END) AS TotalDoctorNonGMP
            FROM dbo.tblDoctorMaster dm WITH (NOLOCK)
            INNER JOIN geo_territory gt ON gt.TerritoryId = dm.TerritoryId
            GROUP BY
                CASE
                    WHEN @DoctorDcrLevel = 'group' THEN gt.GroupId
                    WHEN @DoctorDcrLevel = 'zone' THEN gt.RegionId
                    WHEN @DoctorDcrLevel = 'area' THEN gt.AreaId
                    ELSE gt.TerritoryId

                    end
                )
        SELECT
            rr.RowId AS TrrId_,
            rr.RowKey,
            rr.GroupName,
            rr.ZoneName,
            rr.AreaName,
            rr.Territory,
           ISNULL(doc.TotalDoctorGMP, 0) AS TotalGmpCount,
            ISNULL(doc.TotalDoctorNonGMP, 0) AS TotalNonGmpCount,
            ISNULL(doc.TotalDoctor, 0) AS TotalCount,
            ISNULL(rx.TotalDoctorRXGMPCov, 0) AS RXGmpDoctorCoverage,
            ISNULL(rx.TotalDoctorRXNonGMPCov, 0) AS RXNonGmpDoctorCoverage,
            ISNULL(rx.TotalDoctorRXCov, 0) AS RXTotalDoctorCoverage,
            ISNULL(rx.TotalDoctorRXGMP, 0) AS RXTotalGmpCount,
            ISNULL(rx.TotalDoctorRXNonGMP, 0) AS RXTotalNonGmpCount,
            ISNULL(rx.TotalDoctorRX, 0) AS RXTotalCount,
            ISNULL(rx.TotalDoctorRXGMP, 0) AS SumOfGmpRx,
            ISNULL(rx.TotalDoctorRXNonGMP, 0) AS SumOfNonGmpRx,
            ISNULL(rx.TotalDoctorRX, 0) AS TotalRx
        FROM report_rows rr
        LEFT JOIN doctor_agg doc ON doc.RowId = rr.RowId
        LEFT JOIN rx_agg rx ON rx.RowId = rr.RowId
        ORDER BY rr.RowKey;



        RETURN;

    END



        DECLARE @CampaignFilter TABLE (Value NVARCHAR(500) PRIMARY KEY);

    DECLARE @PharmaFilter   TABLE (Value NVARCHAR(500) PRIMARY KEY);

    DECLARE @CustomerFilter TABLE (Value NVARCHAR(500) PRIMARY KEY);

    DECLARE @ProviderFilter TABLE (Value NVARCHAR(500) PRIMARY KEY);

    -------------------------------------------------------------------------

    -- Date range (sargable filters)

    -------------------------------------------------------------------------

    

       DECLARE 

        @FromMonth INT,

        @FromYear  INT 

        



    SET @FromMonth = MONTH(@fromDate);

    SET @FromYear  = YEAR(@fromDate);

    -------------------------------------------------------------------------

    -- Filter helpers

    -------------------------------------------------------------------------





    DECLARE @SplitXml XML;

    DECLARE @Safe NVARCHAR(MAX);



    -- Campaign codes

    IF (NULLIF(LTRIM(RTRIM(@CampaignCodes)), '') IS NOT NULL)

    BEGIN

        SET @Safe = (SELECT @CampaignCodes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);



        INSERT INTO @CampaignFilter(Value)

        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))

        FROM @SplitXml.nodes('/i') AS X(C)

        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';

    END



    -- Pharma

    IF (NULLIF(LTRIM(RTRIM(@PharmaPlatforms)), '') IS NOT NULL)

    BEGIN

        SET @Safe = (SELECT @PharmaPlatforms FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);



        INSERT INTO @PharmaFilter(Value)

        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))

        FROM @SplitXml.nodes('/i') AS X(C)

        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';

    END



    -- Customer

    IF (NULLIF(LTRIM(RTRIM(@CustomerTypes)), '') IS NOT NULL)

    BEGIN

        SET @Safe = (SELECT @CustomerTypes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);



        INSERT INTO @CustomerFilter(Value)

        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))

        FROM @SplitXml.nodes('/i') AS X(C)

        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';

    END



    -- Provider

    IF (NULLIF(LTRIM(RTRIM(@ProviderTypes)), '') IS NOT NULL)

    BEGIN

        SET @Safe = (SELECT @ProviderTypes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);



        INSERT INTO @ProviderFilter(Value)

        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))

        FROM @SplitXml.nodes('/i') AS X(C)

        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';

    END



    -------------------------------------------------------------------------

    -- Base table (territory wise KPI)

    -------------------------------------------------------------------------

    DECLARE @Base TABLE

    (

        TrrId_ int PRIMARY KEY,          -- à¦à¦• Territory à¦à¦• Row à¦§à¦°à§‡

        RowKey NVARCHAR(500),

        GroupName NVARCHAR(150),

        ZoneName NVARCHAR(150),

        AreaName NVARCHAR(150),

        Territory NVARCHAR(150),

        FilterType NVARCHAR(50),

        CalculationType NVARCHAR(50),

        FiscalYear INT,

        FiscalMonth INT,

        PharmaPlatform NVARCHAR(100),

        ProviderType NVARCHAR(100),

        Target DECIMAL(18,2),

        InvoiceAchievement DECIMAL(18,2),

        AchievementCollection DECIMAL(18,2),



        CampaignInvoiceValue DECIMAL(18,2),

        CampaignCollection DECIMAL(18,2),



        CampaignDoctorCoverage INT,

        ProviderTypeWiseChemistCoverage INT,

        ProviderTypeWiseInvoiceAmount DECIMAL(18,2),

        ProviderTypeWiseCollection DECIMAL(18,2),

        ProviderTypeWiseTotalChemistCoverage INT,

        ProviderTypeWiseTotalInvoiceAmount DECIMAL(18,2),

        ProviderTypeWiseTotalCollection DECIMAL(18,2),

        PharmaPlatformWiseCollection DECIMAL(18,2),





        PharmaPlatformWiseTotalChemistCoverage INT,

        PharmaPlatformWiseTotalInvoiceAmount DECIMAL(18,2),

        PharmaPlatformWiseTotalCollection DECIMAL(18,2),

        TotalGmpCount INT,

        TotalNonGmpCount INT,

        TotalCount INT,

        DCRGmpDoctorCoverage INT,

        DCRNonGmpDoctorCoverage INT,

        DCRTotalDoctorCoverage INT,

        SumOfGmpDcr INT,

        SumOfNonGmpDcr INT,

        TotalDcr INT,

        RxGmpDoctorCoverage INT,

        RxNonGmpDoctorCoverage INT,

        RxTotalDoctorCoverage INT,

        SumOfGmpRx INT,

        SumOfNonGmpRx INT,

        TotalRx INT,

        invoiceCount  INT,

        invoiceValue DECIMAL(18,2),

        invoiceCollection DECIMAL(18,2) ,

        totalDoctor INT,

        totalCustomer INT

    );



      DECLARE @SelectedCampaign TABLE

    (

        SlotNo       INT PRIMARY KEY,

        CampaignCode NVARCHAR(200)

    );



        DECLARE @SelectedCustomer TABLE

    (

        SlotNo       INT PRIMARY KEY,

        CustomerType NVARCHAR(100)

    );



    DECLARE @SelectedPharma TABLE

    (

        SlotNo        INT PRIMARY KEY,

        PharmaPlatform NVARCHAR(100)

    );



     DECLARE @Pharma TABLE

    (

        RowKey NVARCHAR(500),

        SlotNo INT,

        PharmaPlatform NVARCHAR(100),

        InvoiceCount INT,

        InvoiceValue DECIMAL(18,2),

        InvoiceCollection DECIMAL(18,2),

        PRIMARY KEY (RowKey, SlotNo)

    );



      DECLARE @Provider TABLE

    (

        RowKey NVARCHAR(500),

        SlotNo INT,

        ProviderType NVARCHAR(100),

        InvoiceCount INT,

        InvoiceValue DECIMAL(18,2),

        InvoiceCollection DECIMAL(18,2),

        PRIMARY KEY (RowKey, SlotNo)

    );







      DECLARE @SelectedProvider TABLE

    (

        SlotNo       INT PRIMARY KEY,

        ProviderType NVARCHAR(100)

    );



    DECLARE @Campaign TABLE

    (

        RowKey NVARCHAR(500),

        SlotNo INT,

        CampaignCode NVARCHAR(200),

        CampaignInvoiceValue DECIMAL(18,2),

        CampaignCollection   DECIMAL(18,2),

        PRIMARY KEY (RowKey, SlotNo)

    );



      DECLARE @CampaignAgg TABLE

    (

        RowKey NVARCHAR(500),



        Campaign1_Name NVARCHAR(200),

        Campaign1_Invoice DECIMAL(18,2),

        Campaign1_Collection DECIMAL(18,2),



        Campaign2_Name NVARCHAR(200),

        Campaign2_Invoice DECIMAL(18,2),

        Campaign2_Collection DECIMAL(18,2),



        Campaign3_Name NVARCHAR(200),

        Campaign3_Invoice DECIMAL(18,2),

        Campaign3_Collection DECIMAL(18,2),



        Campaign4_Name NVARCHAR(200),

        Campaign4_Invoice DECIMAL(18,2),

        Campaign4_Collection DECIMAL(18,2)

    );





      DECLARE @Customer TABLE

    (

        RowKey NVARCHAR(500),

        SlotNo INT,

        CustomerType NVARCHAR(100),

        InvoiceCount INT,

        InvoiceValue DECIMAL(18,2),

        InvoiceCollection DECIMAL(18,2),

        PRIMARY KEY (RowKey, SlotNo)

    );





     DECLARE @CustomerAgg TABLE

    (

        RowKey NVARCHAR(500),



        Customer1_Name NVARCHAR(100),

        Customer1_InvoiceCount INT,

        Customer1_InvoiceValue DECIMAL(18,2),

        Customer1_InvoiceCollection DECIMAL(18,2),



        Customer2_Name NVARCHAR(100),

        Customer2_InvoiceCount INT,

        Customer2_InvoiceValue DECIMAL(18,2),

        Customer2_InvoiceCollection DECIMAL(18,2),



        Customer3_Name NVARCHAR(100),

        Customer3_InvoiceCount INT,

        Customer3_InvoiceValue DECIMAL(18,2),

        Customer3_InvoiceCollection DECIMAL(18,2),



        Customer4_Name NVARCHAR(100),

        Customer4_InvoiceCount INT,

        Customer4_InvoiceValue DECIMAL(18,2),

        Customer4_InvoiceCollection DECIMAL(18,2) , 



        Customer5_Name NVARCHAR(100),

        Customer5_InvoiceCount INT,

        Customer5_InvoiceValue DECIMAL(18,2),

        Customer5_InvoiceCollection DECIMAL(18,2), 



        Customer6_Name NVARCHAR(100),

        Customer6_InvoiceCount INT,

        Customer6_InvoiceValue DECIMAL(18,2),

        Customer6_InvoiceCollection DECIMAL(18,2)

    );



    ---------------territory

        DECLARE @PharmaAgg TABLE

    (

        RowKey NVARCHAR(500),



        PharmaPlatform1_Name NVARCHAR(100),

        PharmaPlatform1_InvoiceAmount DECIMAL(18,2),

        PharmaPlatform1_ChemistCoverage INT,

        PharmaPlatform1_InvoiceCollection DECIMAL(18,2),



        PharmaPlatform2_Name NVARCHAR(100),

        PharmaPlatform2_InvoiceAmount DECIMAL(18,2),

        PharmaPlatform2_ChemistCoverage INT,

        PharmaPlatform2_InvoiceCollection DECIMAL(18,2),



        PharmaPlatform3_Name NVARCHAR(100),

        PharmaPlatform3_InvoiceAmount DECIMAL(18,2),

        PharmaPlatform3_ChemistCoverage INT,

        PharmaPlatform3_InvoiceCollection DECIMAL(18,2),



        PharmaPlatform4_Name NVARCHAR(100),

        PharmaPlatform4_InvoiceAmount DECIMAL(18,2),

        PharmaPlatform4_ChemistCoverage INT,

        PharmaPlatform4_InvoiceCollection DECIMAL(18,2)

    );



       DECLARE @ProviderAgg TABLE

    (

        RowKey NVARCHAR(500),



        ProviderType1_Name NVARCHAR(100),

        ProviderType1_InvoiceAmount DECIMAL(18,2),

        ProviderType1_ChemistCoverage INT,

        ProviderType1_InvoiceCollection DECIMAL(18,2),



        ProviderType2_Name NVARCHAR(100),

        ProviderType2_InvoiceAmount DECIMAL(18,2),

        ProviderType2_ChemistCoverage INT,

        ProviderType2_InvoiceCollection DECIMAL(18,2),



        ProviderType3_Name NVARCHAR(100),

        ProviderType3_InvoiceAmount DECIMAL(18,2),

        ProviderType3_ChemistCoverage INT,

        ProviderType3_InvoiceCollection DECIMAL(18,2),



        ProviderType4_Name NVARCHAR(100),

        ProviderType4_InvoiceAmount DECIMAL(18,2),

        ProviderType4_ChemistCoverage INT,

        ProviderType4_InvoiceCollection DECIMAL(18,2)

    );

       



         

       

          if(@NormalizedReportLevel='territory')

    begin

    INSERT INTO @Base

    (

        TrrId_,

        RowKey, GroupName, ZoneName, AreaName, Territory,

        FilterType, CalculationType, FiscalYear, FiscalMonth,

        PharmaPlatform, ProviderType,

        Target, InvoiceAchievement, AchievementCollection,

        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,

        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,

        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,

        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,

        TotalGmpCount, TotalNonGmpCount, TotalCount,

        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,

        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,

        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,

        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,

        invoiceCount   ,

        invoiceValue  ,

        invoiceCollection , totalDoctor  ,

        totalCustomer    

    )

    SELECT 

      tr.TerritoryId,

        grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName + '|' + tr.TerritoryName AS RowKey,

        grp.GroupName,

        rgn.RegionName,

        ara.AreaName,

        tr.TerritoryName,

        'Territory',

        'NetTP',

        @FromYear,

        @FromMonth,

        'general',      -- demo pharma platform

        'green-star',   -- demo provider type

        ISNULL(tm.TargetAmt,0),

         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,

        ISNULL(tblCollection.CollectionAMT, 0) ,



        -- demo campaign summary

        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,

        68, 460000, 430000, 122, 820000, 770000,

        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),

        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),

        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),

        ISNULL(tblTotalRx.TotalDoctorRXCov,0),



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

        ISNULL(tblTotalRx.TotalDoctorRX,0),



        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),

       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalCustomer.TotalCustomerCount,0)

  FROM dbo.tblTerritory tr  WITH (NOLOCK)

    INNER JOIN dbo.tblArea    ara WITH (NOLOCK) ON ara.AreaId   = tr.AreaId   AND ara.IsActive=1 

    INNER JOIN dbo.tblRegion  rgn WITH (NOLOCK) ON ara.RegionId = rgn.RegionId AND rgn.IsActive=1 

    INNER JOIN dbo.tbl_Group  grp WITH (NOLOCK) ON grp.GroupId  = rgn.GroupId  AND grp.IsActive=1 

     

    

  

    

  



    LEFT JOIN (

        SELECT tr.TerritoryId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 

        FROM tblTerritoryDataMigration tm

        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 

        

        CROSS APPLY (

    -- MonthName + YearValue à¦¥à§‡à¦•à§‡ à¦®à¦¾à¦¸à§‡à¦° à§§ à¦¤à¦¾à¦°à¦¿à¦–à§‡à¦° date à¦¬à¦¾à¦¨à¦¾à¦šà§à¦›à¦¿

    SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate

) d

WHERE 

    d.MonthStartDate >= @FromDate

    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 

        GROUP BY tr.TerritoryId

    ) tm ON tm.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT ord.TerritoryId,

               CONVERT(DECIMAL(18,2),

                       ISNULL(SUM(ID.DeliveryNetAmount),0)

               ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE A.UpdateDate between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

        GROUP BY ord.TerritoryId

    ) tblInvAchiv ON tblInvAchiv.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT ord.TerritoryId,

               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE cstp.custPaymentDate between  @FromDate and @ToDate

        GROUP BY ord.TerritoryId

    ) tblCollection ON tblCollection.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.TerritoryId

    ) tblTotalDcr ON tblTotalDcr.TerritoryId =tr.TerritoryId



    left join ( SELECT  ord.TerritoryId , 

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND isnull(ordD.CampaignName,'') <>''  AND    (

            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow

            OR ordD.CampaignName NOT IN (

                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe

               )

          ) group by ord.TerritoryId

         )tblCampInvoice on tblCampInvoice.TerritoryId=tr.TerritoryId

   





          

    left join ( SELECT  ord.TerritoryId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ord.SmcTypeId_Ord is not null group by ord.TerritoryId

         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.TerritoryId=tr.TerritoryId

         left join (SELECT ord2.TerritoryId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null

          

          group by ord2.TerritoryId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.TerritoryId=tr.TerritoryId



           

    left join ( SELECT  ord.TerritoryId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

          AND  DelivaryInvoiceNo is not null   

          AND ord.CustTypeId is not null group by ord.TerritoryId

         )tblCustTypeInvoice on tblCustTypeInvoice.TerritoryId=tr.TerritoryId

         left join (SELECT ord2.TerritoryId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null

          

          group by ord2.TerritoryId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.TerritoryId=tr.TerritoryId



    LEFT JOIN (

        SELECT C.TerritoryId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.TerritoryId

    ) tblTotalDcrGmp ON tblTotalDcrGmp.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT C.TerritoryId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.TerritoryId

    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.TerritoryId

    ) tblTotalRxGmp ON tblTotalRxGmp.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.TerritoryId

    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.TerritoryId = tr.TerritoryId



    LEFT JOIN (

        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov

        FROM tbl_PrescriptionMaster C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.TerritoryId

    ) tblTotalRx ON tblTotalRx.TerritoryId = tr.TerritoryId

     

  

      

     

 



      LEFT JOIN (

        

            SELECT ord.TerritoryId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount

           

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

         

         

        GROUP BY ord.TerritoryId

    ) tblTotalCustomer  ON tblTotalCustomer.TerritoryId = tr.TerritoryId



   WHERE rgn.IsActive = 1 

      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))

  AND (ISNULL(@ZoneName,      '') = '' OR rgn.RegionId     = TRY_CONVERT(INT, @ZoneName))

   

      ----------------

      

       



    ;WITH cf AS

    (

        SELECT 

            Value,

            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

        FROM @CampaignFilter

    )

    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)

    SELECT rn, Value

    FROM cf

    WHERE rn <= 4;



    



    INSERT INTO @Campaign

    (

        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection

    )

    SELECT 

        b.RowKey,

        sc.SlotNo,

        sc.CampaignCode,

        ISNULL(ci.InvoiceAMT, 0),

        ISNULL(0,0)

    FROM @Base b

    CROSS JOIN @SelectedCampaign sc

    OUTER APPLY

    (

        SELECT  

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

         

          AND ordD.CampaignName = sc.CampaignCode

          AND ord.TerritoryId   = b.TrrId_

    ) ci

   



  



    INSERT INTO @CampaignAgg

    (

        RowKey,

        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,

        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,

        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,

        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection

    )

    SELECT

        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)

    FROM @Campaign

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- Customer breakdown (pivot 1â€“4)

    -------------------------------------------------------------------------





    IF EXISTS (SELECT 1 FROM @CustomerFilter)

    BEGIN

        ;WITH cf AS

        (

            SELECT 

                Value AS CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @CustomerFilter

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH cf AS

        (

            SELECT DISTINCT 

                ord.CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.TerritoryId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.CustomerType IS NOT NULL

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

     --   WHERE rn <= 4;

    END



  



    INSERT INTO @Customer

    (

        RowKey, SlotNo, CustomerType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sc.SlotNo,

        sc.CustomerType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedCustomer sc

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND CustT.CustomerType = sc.CustomerType

          AND ord.TerritoryId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND CustT.CustomerType = sc.CustomerType

          AND ord2.TerritoryId  = b.TrrId_

    ) cc;



   



    INSERT INTO @CustomerAgg

    (

        RowKey,

        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,

        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,

        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,

        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,

        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,

        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)

        ,



        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)

    FROM @Customer

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- PharmaPlatform breakdown (pivot 1â€“4)  â†’ ord.SMCType_Ord

    -------------------------------------------------------------------------

    

    IF EXISTS (SELECT 1 FROM @PharmaFilter)

    BEGIN

        ;WITH pf AS

        (

            SELECT 

                Value AS PharmaPlatform,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @PharmaFilter

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, PharmaPlatform

        FROM pf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pf AS

        (

            SELECT DISTINCT 

                ord.SMCType_Ord,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.TerritoryId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.SMCType_Ord IS NOT NULL

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, SMCType_Ord

        FROM pf

      --  WHERE rn <= 4;

    END



   



    INSERT INTO @Pharma

    (

        RowKey, SlotNo, PharmaPlatform,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.PharmaPlatform,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        0

    FROM @Base b

    CROSS JOIN @SelectedPharma sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND ord.SMCType_Ord = sp.PharmaPlatform

          AND ord.TerritoryId  = b.TrrId_

    ) ci

  



  



    INSERT INTO @PharmaAgg

    (

        RowKey,

        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,

        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,

        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,

        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)

    FROM @Pharma

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- ProviderType breakdown (pivot 1â€“4) â†’ tblProgramType.ProgramTypeName

    -------------------------------------------------------------------------

  



    IF EXISTS (SELECT 1 FROM @ProviderFilter)

    BEGIN

        ;WITH pr AS

        (

            SELECT 

                Value AS ProviderType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @ProviderFilter

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProviderType

        FROM pr

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pr AS

        (

            SELECT DISTINCT 

                ppt.ProgramTypeName,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

            INNER JOIN @Base b ON b.TrrId_ = ord.TerritoryId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ppt.ProgramTypeName IS NOT NULL

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProgramTypeName

        FROM pr

       -- WHERE rn <= 4;

    END



  



    INSERT INTO @Provider

    (

        RowKey, SlotNo, ProviderType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.ProviderType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedProvider sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord.TerritoryId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord2.TerritoryId  = b.TrrId_

    ) cc;



 



    INSERT INTO @ProviderAgg

    (

        RowKey,

        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,

        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,

        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,

        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)

    FROM @Provider

    GROUP BY RowKey;

      -----------------

      end

       ---------------area

    

      

       

          if(@NormalizedReportLevel='area')

    begin

    INSERT INTO @Base

    (

        TrrId_,

        RowKey, GroupName, ZoneName, AreaName, Territory,

        FilterType, CalculationType, FiscalYear, FiscalMonth,

        PharmaPlatform, ProviderType,

        Target, InvoiceAchievement, AchievementCollection,

        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,

        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,

        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,

        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,

        TotalGmpCount, TotalNonGmpCount, TotalCount,

        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,

        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,

        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,

        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,

        invoiceCount   ,

        invoiceValue  ,

        invoiceCollection , totalDoctor  ,

        totalCustomer    

    )

    SELECT 

      ara.AreaId,

        grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName   AS RowKey,

        grp.GroupName,

        rgn.RegionName,

        ara.AreaName,

        '',

        'Territory',

        'NetTP',

        @FromYear,

        @FromMonth,

        'general',      -- demo pharma platform

        'green-star',   -- demo provider type

        ISNULL(tm.TargetAmt,0),

         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,

        ISNULL(tblCollection.CollectionAMT, 0) ,



        -- demo campaign summary

        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,

        68, 460000, 430000, 122, 820000, 770000,

        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),

        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),

        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),

        ISNULL(tblTotalRx.TotalDoctorRXCov,0),



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

        ISNULL(tblTotalRx.TotalDoctorRX,0),



        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),

       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalCustomer.TotalCustomerCount,0)

FROM dbo.tblArea    ara  WITH (NOLOCK)

     

    INNER JOIN dbo.tblRegion  rgn WITH (NOLOCK) ON ara.RegionId = rgn.RegionId AND rgn.IsActive=1 

    INNER JOIN dbo.tbl_Group  grp WITH (NOLOCK) ON grp.GroupId  = rgn.GroupId  AND grp.IsActive=1 

    

  



    LEFT JOIN (

        SELECT ar.AreaId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 

        FROM tblTerritoryDataMigration tm

        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 

        INNER JOIN dbo.tblArea  ar WITH (NOLOCK) ON tr.AreaId = ar.AreaId AND ar.IsActive=1 

       

        CROSS APPLY (

    -- MonthName + YearValue à¦¥à§‡à¦•à§‡ à¦®à¦¾à¦¸à§‡à¦° à§§ à¦¤à¦¾à¦°à¦¿à¦–à§‡à¦° date à¦¬à¦¾à¦¨à¦¾à¦šà§à¦›à¦¿

   SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate

) d

WHERE 

    d.MonthStartDate >= @FromDate

    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 

        GROUP BY ar.AreaId

    ) tm ON tm.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT ord.AreaId,

               CONVERT(DECIMAL(18,2),

                       ISNULL(SUM(ID.DeliveryNetAmount),0)

               ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE A.UpdateDate between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

        GROUP BY ord.AreaId

    ) tblInvAchiv ON tblInvAchiv.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT ord.AreaId,

               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE cstp.custPaymentDate between  @FromDate and @ToDate

        GROUP BY ord.AreaId

    ) tblCollection ON tblCollection.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.AreaId

    ) tblTotalDcr ON tblTotalDcr.AreaId =ara.AreaId



    left join ( SELECT  ord.AreaId , 

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND isnull(ordD.CampaignName,'') <>''  AND    (

            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow

            OR ordD.CampaignName NOT IN (

                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe

               )

          ) group by ord.AreaId

         )tblCampInvoice on tblCampInvoice.AreaId=ara.AreaId

   





          

    left join ( SELECT  ord.AreaId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ord.SmcTypeId_Ord is not null group by ord.AreaId

         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.AreaId=ara.AreaId

         left join (SELECT ord2.AreaId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null

          

          group by ord2.AreaId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.AreaId=ara.AreaId



           

    left join ( SELECT  ord.AreaId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

          AND  DelivaryInvoiceNo is not null   

          AND ord.CustTypeId is not null group by ord.AreaId

         )tblCustTypeInvoice on tblCustTypeInvoice.AreaId=ara.AreaId

         left join (SELECT ord2.AreaId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null

          

          group by ord2.AreaId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.AreaId=ara.AreaId



    LEFT JOIN (

        SELECT C.AreaId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.AreaId

    ) tblTotalDcrGmp ON tblTotalDcrGmp.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT C.AreaId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.AreaId

    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.AreaId

    ) tblTotalRxGmp ON tblTotalRxGmp.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.AreaId

    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.AreaId = ara.AreaId



    LEFT JOIN (

        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov

        FROM tbl_PrescriptionMaster C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.AreaId

    ) tblTotalRx ON tblTotalRx.AreaId = ara.AreaId

     

  

      

     

 



      LEFT JOIN (

        

            SELECT ord.AreaId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount

           

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

         

         

        GROUP BY ord.AreaId

    ) tblTotalCustomer  ON tblTotalCustomer.AreaId = ara.AreaId



   WHERE rgn.IsActive = 1 

      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))

  AND (ISNULL(@ZoneName,      '') = '' OR rgn.RegionId     = TRY_CONVERT(INT, @ZoneName))

   

      ----------------

      

       



    ;WITH cf AS

    (

        SELECT 

            Value,

            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

        FROM @CampaignFilter

    )

    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)

    SELECT rn, Value

    FROM cf

    WHERE rn <= 4;



    



    INSERT INTO @Campaign

    (

        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection

    )

    SELECT 

        b.RowKey,

        sc.SlotNo,

        sc.CampaignCode,

        ISNULL(ci.InvoiceAMT, 0),

        ISNULL(0,0)

    FROM @Base b

    CROSS JOIN @SelectedCampaign sc

    OUTER APPLY

    (

        SELECT  

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

         

          AND ordD.CampaignName = sc.CampaignCode

          AND ord.AreaId   = b.TrrId_

    ) ci

   



  



    INSERT INTO @CampaignAgg

    (

        RowKey,

        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,

        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,

        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,

        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection

    )

    SELECT

        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)

    FROM @Campaign

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- Customer breakdown (pivot 1â€“4)

    -------------------------------------------------------------------------





    IF EXISTS (SELECT 1 FROM @CustomerFilter)

    BEGIN

        ;WITH cf AS

        (

            SELECT 

                Value AS CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @CustomerFilter

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH cf AS

        (

            SELECT DISTINCT 

                ord.CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.AreaId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.CustomerType IS NOT NULL

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

     --   WHERE rn <= 4;

    END



  



    INSERT INTO @Customer

    (

        RowKey, SlotNo, CustomerType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sc.SlotNo,

        sc.CustomerType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedCustomer sc

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND CustT.CustomerType = sc.CustomerType

          AND ord.AreaId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND CustT.CustomerType = sc.CustomerType

          AND ord2.AreaId  = b.TrrId_

    ) cc;



   



    INSERT INTO @CustomerAgg

    (

        RowKey,

        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,

        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,

        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,

        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,

        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,

        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)

        ,



        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)

    FROM @Customer

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- PharmaPlatform breakdown (pivot 1â€“4)  â†’ ord.SMCType_Ord

    -------------------------------------------------------------------------

    

    IF EXISTS (SELECT 1 FROM @PharmaFilter)

    BEGIN

        ;WITH pf AS

        (

            SELECT 

                Value AS PharmaPlatform,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @PharmaFilter

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, PharmaPlatform

        FROM pf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pf AS

        (

            SELECT DISTINCT 

                ord.SMCType_Ord,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.AreaId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.SMCType_Ord IS NOT NULL

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, SMCType_Ord

        FROM pf

      --  WHERE rn <= 4;

    END



   



    INSERT INTO @Pharma

    (

        RowKey, SlotNo, PharmaPlatform,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.PharmaPlatform,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        0

    FROM @Base b

    CROSS JOIN @SelectedPharma sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND ord.SMCType_Ord = sp.PharmaPlatform

          AND ord.AreaId  = b.TrrId_

    ) ci

  



  



    INSERT INTO @PharmaAgg

    (

        RowKey,

        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,

        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,

        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,

        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)

    FROM @Pharma

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- ProviderType breakdown (pivot 1â€“4) â†’ tblProgramType.ProgramTypeName

    -------------------------------------------------------------------------

  



    IF EXISTS (SELECT 1 FROM @ProviderFilter)

    BEGIN

        ;WITH pr AS

        (

            SELECT 

                Value AS ProviderType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @ProviderFilter

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProviderType

        FROM pr

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pr AS

        (

            SELECT DISTINCT 

                ppt.ProgramTypeName,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

            INNER JOIN @Base b ON b.TrrId_ = ord.AreaId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ppt.ProgramTypeName IS NOT NULL

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProgramTypeName

        FROM pr

       -- WHERE rn <= 4;

    END



  



    INSERT INTO @Provider

    (

        RowKey, SlotNo, ProviderType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.ProviderType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedProvider sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord.AreaId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord2.AreaId  = b.TrrId_

    ) cc;



 



    INSERT INTO @ProviderAgg

    (

        RowKey,

        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,

        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,

        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,

        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)

    FROM @Provider

    GROUP BY RowKey;

      -----------------

      end

      

       

       ---------------Zone

  



      if(@NormalizedReportLevel='zone')

    begin

    INSERT INTO @Base

    (

        TrrId_,

        RowKey, GroupName, ZoneName, AreaName, Territory,

        FilterType, CalculationType, FiscalYear, FiscalMonth,

        PharmaPlatform, ProviderType,

        Target, InvoiceAchievement, AchievementCollection,

        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,

        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,

        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,

        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,

        TotalGmpCount, TotalNonGmpCount, TotalCount,

        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,

        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,

        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,

        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,

        invoiceCount   ,

        invoiceValue  ,

        invoiceCollection , totalDoctor  ,

        totalCustomer    

    )

    SELECT 

        rgn.RegionId,

        grp.GroupName + '|' + rgn.RegionName     AS RowKey,

        grp.GroupName,

        rgn.RegionName,

         '',

        '',

        'Territory',

        'NetTP',

        @FromYear,

        @FromMonth,

        'general',      -- demo pharma platform

        'green-star',   -- demo provider type

        ISNULL(tm.TargetAmt,0),

         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,

        ISNULL(tblCollection.CollectionAMT, 0) ,



        -- demo campaign summary

        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,

        68, 460000, 430000, 122, 820000, 770000,

        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),

        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),

        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),

        ISNULL(tblTotalRx.TotalDoctorRXCov,0),



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

        ISNULL(tblTotalRx.TotalDoctorRX,0),



        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),

       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalCustomer.TotalCustomerCount,0)



     FROM    dbo.tblRegion  rgn  WITH (NOLOCK)

     

    

    INNER JOIN dbo.tbl_Group  grp WITH (NOLOCK) ON grp.GroupId  = rgn.GroupId  AND grp.IsActive=1 

    

  



    LEFT JOIN (

        SELECT ar.RegionId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 

        FROM tblTerritoryDataMigration tm

        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 

        INNER JOIN dbo.tblArea  ar WITH (NOLOCK) ON tr.AreaId = ar.AreaId AND ar.IsActive=1 

       

        CROSS APPLY (

    -- MonthName + YearValue à¦¥à§‡à¦•à§‡ à¦®à¦¾à¦¸à§‡à¦° à§§ à¦¤à¦¾à¦°à¦¿à¦–à§‡à¦° date à¦¬à¦¾à¦¨à¦¾à¦šà§à¦›à¦¿

    SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate

) d

WHERE 

    d.MonthStartDate >= @FromDate

    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 

        GROUP BY ar.RegionId

    ) tm ON tm.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT ord.RegionId,

               CONVERT(DECIMAL(18,2),

                       ISNULL(SUM(ID.DeliveryNetAmount),0)

               ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE A.UpdateDate between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

        GROUP BY ord.RegionId

    ) tblInvAchiv ON tblInvAchiv.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT ord.RegionId,

               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE cstp.custPaymentDate between  @FromDate and @ToDate

        GROUP BY ord.RegionId

    ) tblCollection ON tblCollection.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.RegionId

    ) tblTotalDcr ON tblTotalDcr.RegionId =rgn.RegionId



    left join ( SELECT  ord.RegionId , 

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND isnull(ordD.CampaignName,'') <>''  AND    (

            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow

            OR ordD.CampaignName NOT IN (

                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe

               )

          ) group by ord.RegionId

         )tblCampInvoice on tblCampInvoice.RegionId=rgn.RegionId

   





          

    left join ( SELECT  ord.RegionId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ord.SmcTypeId_Ord is not null group by ord.RegionId

         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.RegionId=rgn.RegionId

         left join (SELECT ord2.RegionId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null

          

          group by ord2.RegionId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.RegionId=rgn.RegionId



           

    left join ( SELECT  ord.RegionId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

          AND  DelivaryInvoiceNo is not null   

          AND ord.CustTypeId is not null group by ord.RegionId

         )tblCustTypeInvoice on tblCustTypeInvoice.RegionId=rgn.RegionId

         left join (SELECT ord2.RegionId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null

          

          group by ord2.RegionId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.RegionId=rgn.RegionId



    LEFT JOIN (

        SELECT C.RegionId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.RegionId

    ) tblTotalDcrGmp ON tblTotalDcrGmp.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT C.RegionId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.RegionId

    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.RegionId

    ) tblTotalRxGmp ON tblTotalRxGmp.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.RegionId

    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.RegionId = rgn.RegionId



    LEFT JOIN (

        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov

        FROM tbl_PrescriptionMaster C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.RegionId

    ) tblTotalRx ON tblTotalRx.RegionId = rgn.RegionId

     

  

      

     

 



      LEFT JOIN (

        

            SELECT ord.RegionId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount

           

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

         

         

        GROUP BY ord.RegionId

    ) tblTotalCustomer  ON tblTotalCustomer.RegionId = rgn.RegionId



   WHERE rgn.IsActive = 1 

      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))

  AND (ISNULL(@ZoneName,      '') = '' OR rgn.RegionId     = TRY_CONVERT(INT, @ZoneName))

   

      ----------------

      

       



    ;WITH cf AS

    (

        SELECT 

            Value,

            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

        FROM @CampaignFilter

    )

    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)

    SELECT rn, Value

    FROM cf

    WHERE rn <= 4;



    



    INSERT INTO @Campaign

    (

        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection

    )

    SELECT 

        b.RowKey,

        sc.SlotNo,

        sc.CampaignCode,

        ISNULL(ci.InvoiceAMT, 0),

        ISNULL(0,0)

    FROM @Base b

    CROSS JOIN @SelectedCampaign sc

    OUTER APPLY

    (

        SELECT  

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

         

          AND ordD.CampaignName = sc.CampaignCode

          AND ord.RegionId   = b.TrrId_

    ) ci

   



  



    INSERT INTO @CampaignAgg

    (

        RowKey,

        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,

        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,

        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,

        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection

    )

    SELECT

        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)

    FROM @Campaign

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- Customer breakdown (pivot 1â€“4)

    -------------------------------------------------------------------------





    IF EXISTS (SELECT 1 FROM @CustomerFilter)

    BEGIN

        ;WITH cf AS

        (

            SELECT 

                Value AS CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @CustomerFilter

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH cf AS

        (

            SELECT DISTINCT 

                ord.CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.RegionId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.CustomerType IS NOT NULL

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

     --   WHERE rn <= 4;

    END



  



    INSERT INTO @Customer

    (

        RowKey, SlotNo, CustomerType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sc.SlotNo,

        sc.CustomerType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedCustomer sc

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND CustT.CustomerType = sc.CustomerType

          AND ord.RegionId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND CustT.CustomerType = sc.CustomerType

          AND ord2.RegionId  = b.TrrId_

    ) cc;



   



    INSERT INTO @CustomerAgg

    (

        RowKey,

        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,

        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,

        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,

        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,

        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,

        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)

        ,



        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)

    FROM @Customer

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- PharmaPlatform breakdown (pivot 1â€“4)  â†’ ord.SMCType_Ord

    -------------------------------------------------------------------------

    

    IF EXISTS (SELECT 1 FROM @PharmaFilter)

    BEGIN

        ;WITH pf AS

        (

            SELECT 

                Value AS PharmaPlatform,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @PharmaFilter

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, PharmaPlatform

        FROM pf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pf AS

        (

            SELECT DISTINCT 

                ord.SMCType_Ord,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.RegionId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.SMCType_Ord IS NOT NULL

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, SMCType_Ord

        FROM pf

      --  WHERE rn <= 4;

    END



   



    INSERT INTO @Pharma

    (

        RowKey, SlotNo, PharmaPlatform,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.PharmaPlatform,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        0

    FROM @Base b

    CROSS JOIN @SelectedPharma sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND ord.SMCType_Ord = sp.PharmaPlatform

          AND ord.RegionId  = b.TrrId_

    ) ci

  



  



    INSERT INTO @PharmaAgg

    (

        RowKey,

        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,

        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,

        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,

        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)

    FROM @Pharma

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- ProviderType breakdown (pivot 1â€“4) â†’ tblProgramType.ProgramTypeName

    -------------------------------------------------------------------------

  



    IF EXISTS (SELECT 1 FROM @ProviderFilter)

    BEGIN

        ;WITH pr AS

        (

            SELECT 

                Value AS ProviderType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @ProviderFilter

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProviderType

        FROM pr

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pr AS

        (

            SELECT DISTINCT 

                ppt.ProgramTypeName,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

            INNER JOIN @Base b ON b.TrrId_ = ord.RegionId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ppt.ProgramTypeName IS NOT NULL

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProgramTypeName

        FROM pr

       -- WHERE rn <= 4;

    END



  



    INSERT INTO @Provider

    (

        RowKey, SlotNo, ProviderType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.ProviderType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedProvider sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord.RegionId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord2.RegionId  = b.TrrId_

    ) cc;



 



    INSERT INTO @ProviderAgg

    (

        RowKey,

        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,

        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,

        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,

        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)

    FROM @Provider

    GROUP BY RowKey;

      -----------------

      end

      

      

       ---------------group

    if(@NormalizedReportLevel='group')

    begin

    INSERT INTO @Base

    (

        TrrId_,

        RowKey, GroupName, ZoneName, AreaName, Territory,

        FilterType, CalculationType, FiscalYear, FiscalMonth,

        PharmaPlatform, ProviderType,

        Target, InvoiceAchievement, AchievementCollection,

        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,

        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,

        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,

        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,

        TotalGmpCount, TotalNonGmpCount, TotalCount,

        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,

        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,

        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,

        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,

        invoiceCount   ,

        invoiceValue  ,

        invoiceCollection , totalDoctor  ,

        totalCustomer    

    )

    SELECT 

        grp.GroupId,

        grp.GroupName       AS RowKey,

        grp.GroupName,

       '',

       '',

        '',

        'Territory',

        'NetTP',

        @FromYear,

        @FromMonth,

        'general',      -- demo pharma platform

        'green-star',   -- demo provider type

        ISNULL(tm.TargetAmt,0),

         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,

        ISNULL(tblCollection.CollectionAMT, 0) ,



        -- demo campaign summary

        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,

        68, 460000, 430000, 122, 820000, 770000,

        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0)+

          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),

         ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0)+

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0), 



        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),

       ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0)+

        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0), 



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),

         ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0)+

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),



        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

        

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0)+

        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),



        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),

       ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0)+

          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),

        ISNULL(tblTotalCustomer.TotalCustomerCount,0)



    FROM dbo.tbl_Group  grp     WITH (NOLOCK)

     

    

  



    LEFT JOIN (

        SELECT rg.GroupId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 

        FROM tblTerritoryDataMigration tm

        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 

        INNER JOIN dbo.tblArea  ar WITH (NOLOCK) ON tr.AreaId = ar.AreaId AND ar.IsActive=1 

        INNER JOIN dbo.tblRegion  rg WITH (NOLOCK) ON rg.RegionId = ar.RegionId AND rg.IsActive=1 

        CROSS APPLY (

    -- MonthName + YearValue à¦¥à§‡à¦•à§‡ à¦®à¦¾à¦¸à§‡à¦° à§§ à¦¤à¦¾à¦°à¦¿à¦–à§‡à¦° date à¦¬à¦¾à¦¨à¦¾à¦šà§à¦›à¦¿

    SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate

) d

WHERE 

    d.MonthStartDate >= @FromDate

    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 

        GROUP BY rg.GroupId

    ) tm ON tm.GroupId = grp.GroupId



    LEFT JOIN (

        SELECT ord.GroupId,

               CONVERT(DECIMAL(18,2),

                       ISNULL(SUM(ID.DeliveryNetAmount),0)

               ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE A.UpdateDate between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

        GROUP BY ord.GroupId

    ) tblInvAchiv ON tblInvAchiv.GroupId = grp.GroupId



    LEFT JOIN (

        SELECT ord.GroupId,

               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 

        WHERE cstp.custPaymentDate between  @FromDate and @ToDate

        GROUP BY ord.GroupId

    ) tblCollection ON tblCollection.GroupId = grp.GroupId



   

    left join ( SELECT  ord.GroupId , 

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND isnull(ordD.CampaignName,'') <>''  AND    (

            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow

            OR ordD.CampaignName NOT IN (

                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe

               )

          ) group by ord.GroupId

         )tblCampInvoice on tblCampInvoice.GroupId=grp.GroupId

   





          

    left join ( SELECT  ord.GroupId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ord.SmcTypeId_Ord is not null group by ord.GroupId

         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.GroupId=grp.GroupId

         left join (SELECT ord2.GroupId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null

          

          group by ord2.GroupId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.GroupId=grp.GroupId



           

    left join ( SELECT  ord.GroupId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

          AND  DelivaryInvoiceNo is not null   

          AND ord.CustTypeId is not null group by ord.GroupId

         )tblCustTypeInvoice on tblCustTypeInvoice.GroupId=grp.GroupId

         left join (SELECT ord2.GroupId,  

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId

        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId

        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null

          

          group by ord2.GroupId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.GroupId=grp.GroupId



    LEFT JOIN (

        SELECT C.GroupId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.GroupId

    ) tblTotalDcrGmp ON tblTotalDcrGmp.GroupId = grp.GroupId



    LEFT JOIN (

        SELECT C.GroupId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov

        FROM tbl_DCRInfo C

        WHERE ISNULL(C.ApprovalStatus,0) = '2'

          AND C.DoctorTypeID_DCR = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.GroupId

    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.GroupId = grp.GroupId



    LEFT JOIN (

        SELECT C.GroupId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 2

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.GroupId

    ) tblTotalRxGmp ON tblTotalRxGmp.GroupId = grp.GroupId



    LEFT JOIN (

        SELECT C.GroupId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov

        FROM tbl_PrescriptionMaster C

        WHERE C.DoctorTypeId_RX = 1

          AND convert(date,C.EntryDate)  between  @FromDate and @ToDate

        GROUP BY C.GroupId

    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.GroupId = grp.GroupId



  

  

      

     

 



      LEFT JOIN (

        

            SELECT ord.GroupId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount

           

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

         

         

        GROUP BY ord.GroupId

    ) tblTotalCustomer  ON tblTotalCustomer.GroupId = grp.GroupId



    WHERE grp.IsActive = 1 and grp.GroupName <>'TestRezion'

      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))

   

      ----------------

      

       



    ;WITH cf AS

    (

        SELECT 

            Value,

            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

        FROM @CampaignFilter

    )

    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)

    SELECT rn, Value

    FROM cf

    WHERE rn <= 4;



    



    INSERT INTO @Campaign

    (

        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection

    )

    SELECT 

        b.RowKey,

        sc.SlotNo,

        sc.CampaignCode,

        ISNULL(ci.InvoiceAMT, 0),

        ISNULL(0,0)

    FROM @Base b

    CROSS JOIN @SelectedCampaign sc

    OUTER APPLY

    (

        SELECT  

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceAMT

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId

        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 

        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 

        WHERE A.UpdateDate  between  @FromDate and @ToDate

        AND  DelivaryInvoiceNo is not null   

         

          AND ordD.CampaignName = sc.CampaignCode

          AND ord.GroupId   = b.TrrId_

    ) ci

   



  



    INSERT INTO @CampaignAgg

    (

        RowKey,

        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,

        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,

        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,

        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection

    )

    SELECT

        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)

    FROM @Campaign

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- Customer breakdown (pivot 1â€“4)

    -------------------------------------------------------------------------





    IF EXISTS (SELECT 1 FROM @CustomerFilter)

    BEGIN

        ;WITH cf AS

        (

            SELECT 

                Value AS CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @CustomerFilter

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH cf AS

        (

            SELECT DISTINCT 

                ord.CustomerType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.GroupId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.CustomerType IS NOT NULL

        )

        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)

        SELECT rn, CustomerType

        FROM cf

     --   WHERE rn <= 4;

    END



  



    INSERT INTO @Customer

    (

        RowKey, SlotNo, CustomerType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sc.SlotNo,

        sc.CustomerType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedCustomer sc

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND CustT.CustomerType = sc.CustomerType

          AND ord.GroupId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND CustT.CustomerType = sc.CustomerType

          AND ord2.GroupId  = b.TrrId_

    ) cc;



   



    INSERT INTO @CustomerAgg

    (

        RowKey,

        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,

        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,

        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,

        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,

        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,

        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)

        ,



        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)

    FROM @Customer

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- PharmaPlatform breakdown (pivot 1â€“4)  â†’ ord.SMCType_Ord

    -------------------------------------------------------------------------

    

    IF EXISTS (SELECT 1 FROM @PharmaFilter)

    BEGIN

        ;WITH pf AS

        (

            SELECT 

                Value AS PharmaPlatform,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @PharmaFilter

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, PharmaPlatform

        FROM pf

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pf AS

        (

            SELECT DISTINCT 

                ord.SMCType_Ord,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN @Base b ON b.TrrId_ = ord.GroupId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ord.SMCType_Ord IS NOT NULL

        )

        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)

        SELECT rn, SMCType_Ord

        FROM pf

      --  WHERE rn <= 4;

    END



   



    INSERT INTO @Pharma

    (

        RowKey, SlotNo, PharmaPlatform,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.PharmaPlatform,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        0

    FROM @Base b

    CROSS JOIN @SelectedPharma sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  

        WHERE A.UpdateDate  between  @FromDate and @ToDate

           AND  DelivaryInvoiceNo is not null   

          AND ord.SMCType_Ord = sp.PharmaPlatform

          AND ord.GroupId  = b.TrrId_

    ) ci

  



  



    INSERT INTO @PharmaAgg

    (

        RowKey,

        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,

        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,

        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,

        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)

    FROM @Pharma

    GROUP BY RowKey;



    -------------------------------------------------------------------------

    -- ProviderType breakdown (pivot 1â€“4) â†’ tblProgramType.ProgramTypeName

    -------------------------------------------------------------------------

  



    IF EXISTS (SELECT 1 FROM @ProviderFilter)

    BEGIN

        ;WITH pr AS

        (

            SELECT 

                Value AS ProviderType,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM @ProviderFilter

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProviderType

        FROM pr

       -- WHERE rn <= 4;

    END

    ELSE

    BEGIN

        ;WITH pr AS

        (

            SELECT DISTINCT 

                ppt.ProgramTypeName,

                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn

            FROM tblOrder ord WITH (NOLOCK)

            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId

            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

            INNER JOIN @Base b ON b.TrrId_ = ord.GroupId

            WHERE A.UpdateDate  between  @FromDate and @ToDate

              AND ppt.ProgramTypeName IS NOT NULL

        )

        INSERT INTO @SelectedProvider (SlotNo, ProviderType)

        SELECT rn, ProgramTypeName

        FROM pr

       -- WHERE rn <= 4;

    END



  



    INSERT INTO @Provider

    (

        RowKey, SlotNo, ProviderType,

        InvoiceCount, InvoiceValue, InvoiceCollection

    )

    SELECT

        b.RowKey,

        sp.SlotNo,

        sp.ProviderType,

        ISNULL(ci.InvoiceCount, 0),

        ISNULL(ci.InvoiceValue, 0.00),

        ISNULL(cc.InvoiceCollection,0.00)

    FROM @Base b

    CROSS JOIN @SelectedProvider sp

    OUTER APPLY

    (

        SELECT

            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,

            CONVERT(DECIMAL(18,2),

                ISNULL(SUM(ID.DeliveryNetAmount),0)

            ) AS InvoiceValue

        FROM dbo.tblInvoice A WITH (NOLOCK)

        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId

        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId

        WHERE A.UpdateDate  between  @FromDate and @ToDate

         AND  DelivaryInvoiceNo is not null   

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord.GroupId  = b.TrrId_

    ) ci

    OUTER APPLY

    (

        SELECT

            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection

        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)

        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId

        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId

        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId

        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate

          AND ppt.ProgramTypeName = sp.ProviderType

          AND ord2.GroupId  = b.TrrId_

    ) cc;



 



    INSERT INTO @ProviderAgg

    (

        RowKey,

        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,

        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,

        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,

        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection

    )

    SELECT

        RowKey,



        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),



        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),

        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)

    FROM @Provider

    GROUP BY RowKey;

      -----------------

      end

    -------------------------------------------------------------------------

    -- Campaign selection + pivot (1â€“4)

    -------------------------------------------------------------------------

  









    -------------------------------------------------------------------------

    -- MetricGroup: customer shortcut

    IF (LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))) = 'customer')

    BEGIN

        SELECT

            b.TrrId_,

            b.RowKey,

            b.GroupName,

            b.ZoneName,

            b.AreaName,

            b.Territory,

            ISNULL(b.invoiceCount, 0) AS InvoiceCount,

            ISNULL(b.invoiceValue, 0) AS InvoiceValue,

            ISNULL(b.invoiceCollection, 0) AS InvoiceCollection,

            ISNULL(cu.Customer1_Name,              '') AS Customer1_Name,

            ISNULL(cu.Customer1_InvoiceCount,      0)  AS Customer1_InvoiceCount,

            ISNULL(cu.Customer1_InvoiceValue,      0)  AS Customer1_InvoiceValue,

            ISNULL(cu.Customer1_InvoiceCollection, 0)  AS Customer1_InvoiceCollection,

            ISNULL(cu.Customer2_Name,              '') AS Customer2_Name,

            ISNULL(cu.Customer2_InvoiceCount,      0)  AS Customer2_InvoiceCount,

            ISNULL(cu.Customer2_InvoiceValue,      0)  AS Customer2_InvoiceValue,

            ISNULL(cu.Customer2_InvoiceCollection, 0)  AS Customer2_InvoiceCollection,

            ISNULL(cu.Customer3_Name,              '') AS Customer3_Name,

            ISNULL(cu.Customer3_InvoiceCount,      0)  AS Customer3_InvoiceCount,

            ISNULL(cu.Customer3_InvoiceValue,      0)  AS Customer3_InvoiceValue,

            ISNULL(cu.Customer3_InvoiceCollection, 0)  AS Customer3_InvoiceCollection,

            ISNULL(cu.Customer4_Name,              '') AS Customer4_Name,

            ISNULL(cu.Customer4_InvoiceCount,      0)  AS Customer4_InvoiceCount,

            ISNULL(cu.Customer4_InvoiceValue,      0)  AS Customer4_InvoiceValue,

            ISNULL(cu.Customer4_InvoiceCollection, 0)  AS Customer4_InvoiceCollection,

            ISNULL(cu.Customer5_Name,              '') AS Customer5_Name,

            ISNULL(cu.Customer5_InvoiceCount,      0)  AS Customer5_InvoiceCount,

            ISNULL(cu.Customer5_InvoiceValue,      0)  AS Customer5_InvoiceValue,

            ISNULL(cu.Customer5_InvoiceCollection, 0)  AS Customer5_InvoiceCollection,

            ISNULL(cu.Customer6_Name,              '') AS Customer6_Name,

            ISNULL(cu.Customer6_InvoiceCount,      0)  AS Customer6_InvoiceCount,

            ISNULL(cu.Customer6_InvoiceValue,      0)  AS Customer6_InvoiceValue,

            ISNULL(cu.Customer6_InvoiceCollection, 0)  AS Customer6_InvoiceCollection,

            ISNULL(b.totalCustomer, 0) AS TotalCustomer

        FROM @Base b

        LEFT JOIN @CustomerAgg cu ON cu.RowKey = b.RowKey;



        RETURN;

    END

    -------------------------------------------------------------------------

        -- MetricGroup: doctorRx shortcut

    IF (LOWER(LTRIM(RTRIM(ISNULL(@MetricGroup, '')))) = 'doctorrx')

    BEGIN

        SELECT

            b.TrrId_,

            b.RowKey,

            b.GroupName,

            b.ZoneName,

            b.AreaName,

            b.Territory,

            b.TotalGmpCount,

            b.TotalNonGmpCount,

            b.TotalCount,

            b.DCRGmpDoctorCoverage,

            b.DCRNonGmpDoctorCoverage,

            b.DCRTotalDoctorCoverage,

            b.SumOfGmpDcr,

            b.SumOfNonGmpDcr,

            b.TotalDcr,

            b.SumOfGmpDcr AS TotalDoctorDCRGMPCount,

            b.SumOfNonGmpDcr AS TotalDoctorDCRNONGMPCount,

            b.TotalDcr AS TotalDoctorDCRCount,

            b.RxGmpDoctorCoverage AS RXGmpDoctorCoverage,

            b.RxNonGmpDoctorCoverage AS RXNonGmpDoctorCoverage,

            b.RxTotalDoctorCoverage AS RXTotalDoctorCoverage,

            b.SumOfGmpRx,

            b.SumOfNonGmpRx,

            b.TotalRx,

            b.SumOfGmpRx AS TotalDoctorRXGMPCount,

            b.SumOfNonGmpRx AS TotalDoctorRXNONGMPCount,

            b.TotalRx AS TotalDoctorRXCount

        FROM @Base b;



        RETURN;

    END

-- FINAL OUTPUT

    -------------------------------------------------------------------------

    SELECT 

        b.TrrId_,

        b.RowKey,

        b.GroupName,

        b.ZoneName,

        b.AreaName,

        b.Territory,

        b.Target,

        b.InvoiceAchievement,

        b.AchievementCollection,



          ISNULL( invoiceCount ,  0)  CampaignWiseTotalinvoiceCount ,

       ISNULL( invoiceValue ,  0) CampaignWiseTotalinvoiceValue,

       ISNULL( invoiceCollection ,  0)   CampaignWiseTotalinvoiceCollection,



       

       ISNULL( invoiceCount ,  0)  customerTypeTotalInvoiceCount ,

       ISNULL( invoiceValue ,  0) customerTypeTotalInvoiceValue,

       ISNULL( invoiceCollection ,  0)   customerTypeTotalInvoiceCollection,

       

    

        b.ProviderTypeWiseTotalChemistCoverage,

        b.ProviderTypeWiseTotalInvoiceAmount,

        b.ProviderTypeWiseTotalCollection,

         

        b.PharmaPlatformWiseTotalChemistCoverage,

        b.PharmaPlatformWiseTotalInvoiceAmount,

        b.PharmaPlatformWiseTotalCollection,



        b.TotalGmpCount,

        b.TotalNonGmpCount,

        b.TotalCount,

        b.DCRGmpDoctorCoverage,

        b.DCRNonGmpDoctorCoverage,

        b.DCRTotalDoctorCoverage,

        b.SumOfGmpDcr,

        b.SumOfNonGmpDcr,

        b.TotalDcr,

        b.SumOfGmpDcr AS TotalDoctorDCRGMPCount,

        b.SumOfNonGmpDcr AS TotalDoctorDCRNONGMPCount,

        b.TotalDcr AS TotalDoctorDCRCount,

        b.RXGmpDoctorCoverage,

        b.RXNonGmpDoctorCoverage,

        b.RXTotalDoctorCoverage,

        b.SumOfGmpRx,

        b.SumOfNonGmpRx,

        b.TotalRx,

        b.SumOfGmpRx AS TotalDoctorRXGMPCount,

        b.SumOfNonGmpRx AS TotalDoctorRXNONGMPCount,

        b.TotalRx AS TotalDoctorRXCount,



        -- Campaign slots

        ISNULL(ca.Campaign1_Name,       '') AS Campaign1_Name,

        ISNULL(ca.Campaign1_Invoice,    0)  AS Campaign1_Invoice,

        ISNULL(ca.Campaign1_Collection, 0)  AS Campaign1_Collection,



        ISNULL(ca.Campaign2_Name,       '') AS Campaign2_Name,

        ISNULL(ca.Campaign2_Invoice,    0)  AS Campaign2_Invoice,

        ISNULL(ca.Campaign2_Collection, 0)  AS Campaign2_Collection,



        ISNULL(ca.Campaign3_Name,       '') AS Campaign3_Name,

        ISNULL(ca.Campaign3_Invoice,    0)  AS Campaign3_Invoice,

        ISNULL(ca.Campaign3_Collection, 0)  AS Campaign3_Collection,



        ISNULL(ca.Campaign4_Name,       '') AS Campaign4_Name,

        ISNULL(ca.Campaign4_Invoice,    0)  AS Campaign4_Invoice,

        ISNULL(ca.Campaign4_Collection, 0)  AS Campaign4_Collection,



        -- Customer type slots

        ISNULL(cu.Customer1_Name,              '') AS Customer1_Name,

        ISNULL(cu.Customer1_InvoiceCount,      0)  AS Customer1_InvoiceCount,

        ISNULL(cu.Customer1_InvoiceValue,      0)  AS Customer1_InvoiceValue,

        ISNULL(cu.Customer1_InvoiceCollection, 0)  AS Customer1_InvoiceCollection,



        ISNULL(cu.Customer2_Name,              '') AS Customer2_Name,

        ISNULL(cu.Customer2_InvoiceCount,      0)  AS Customer2_InvoiceCount,

        ISNULL(cu.Customer2_InvoiceValue,      0)  AS Customer2_InvoiceValue,

        ISNULL(cu.Customer2_InvoiceCollection, 0)  AS Customer2_InvoiceCollection,



        ISNULL(cu.Customer3_Name,              '') AS Customer3_Name,

        ISNULL(cu.Customer3_InvoiceCount,      0)  AS Customer3_InvoiceCount,

        ISNULL(cu.Customer3_InvoiceValue,      0)  AS Customer3_InvoiceValue,

        ISNULL(cu.Customer3_InvoiceCollection, 0)  AS Customer3_InvoiceCollection,



        ISNULL(cu.Customer4_Name,              '') AS Customer4_Name,

        ISNULL(cu.Customer4_InvoiceCount,      0)  AS Customer4_InvoiceCount,

        ISNULL(cu.Customer4_InvoiceValue,      0)  AS Customer4_InvoiceValue,

        ISNULL(cu.Customer4_InvoiceCollection, 0)  AS Customer4_InvoiceCollection

        ,



        ISNULL(cu.Customer5_Name,              '') AS Customer5_Name,

        ISNULL(cu.Customer5_InvoiceCount,      0)  AS Customer5_InvoiceCount,

        ISNULL(cu.Customer5_InvoiceValue,      0)  AS Customer5_InvoiceValue,

        ISNULL(cu.Customer5_InvoiceCollection, 0)  AS Customer5_InvoiceCollection,

       



        ISNULL(cu.Customer6_Name,              '') AS Customer6_Name,

        ISNULL(cu.Customer6_InvoiceCount,      0)  AS Customer6_InvoiceCount,

        ISNULL(cu.Customer6_InvoiceValue,      0)  AS Customer6_InvoiceValue,

        ISNULL(cu.Customer6_InvoiceCollection, 0)  AS Customer6_InvoiceCollection,





        -- Pharma Platform slots

        ISNULL(ph.PharmaPlatform1_Name,              '') AS PharmaPlatform1_Name,

        ISNULL(ph.PharmaPlatform1_InvoiceAmount,      0)  AS PharmaPlatform1_InvoiceAmount,

        ISNULL(ph.PharmaPlatform1_ChemistCoverage,    0)  AS PharmaPlatform1_ChemistCoverage,

        ISNULL(ph.PharmaPlatform1_InvoiceCollection,  0)  AS PharmaPlatform1_InvoiceCollection,



        ISNULL(ph.PharmaPlatform2_Name,              '') AS PharmaPlatform2_Name,

        ISNULL(ph.PharmaPlatform2_InvoiceAmount,      0)  AS PharmaPlatform2_InvoiceAmount,

        ISNULL(ph.PharmaPlatform2_ChemistCoverage,    0)  AS PharmaPlatform2_ChemistCoverage,

        ISNULL(ph.PharmaPlatform2_InvoiceCollection,  0)  AS PharmaPlatform2_InvoiceCollection,



        ISNULL(ph.PharmaPlatform3_Name,              '') AS PharmaPlatform3_Name,

        ISNULL(ph.PharmaPlatform3_InvoiceAmount,      0)  AS PharmaPlatform3_InvoiceAmount,

        ISNULL(ph.PharmaPlatform3_ChemistCoverage,    0)  AS PharmaPlatform3_ChemistCoverage,

        ISNULL(ph.PharmaPlatform3_InvoiceCollection,  0)  AS PharmaPlatform3_InvoiceCollection,



        ISNULL(ph.PharmaPlatform4_Name,              '') AS PharmaPlatform4_Name,

        ISNULL(ph.PharmaPlatform4_InvoiceAmount,      0)  AS PharmaPlatform4_InvoiceAmount,

        ISNULL(ph.PharmaPlatform4_ChemistCoverage,    0)  AS PharmaPlatform4_ChemistCoverage,

        ISNULL(ph.PharmaPlatform4_InvoiceCollection,  0)  AS PharmaPlatform4_InvoiceCollection,



        -- Provider Type slots

        ISNULL(pr.ProviderType1_Name,              '') AS ProviderType1_Name,

        ISNULL(pr.ProviderType1_InvoiceAmount,      0)  AS ProviderType1_InvoiceAmount,

        ISNULL(pr.ProviderType1_ChemistCoverage,    0)  AS ProviderType1_ChemistCoverage,

        ISNULL(pr.ProviderType1_InvoiceCollection,  0)  AS ProviderType1_InvoiceCollection,



        ISNULL(pr.ProviderType2_Name,              '') AS ProviderType2_Name,

        ISNULL(pr.ProviderType2_InvoiceAmount,      0)  AS ProviderType2_InvoiceAmount,

        ISNULL(pr.ProviderType2_ChemistCoverage,    0)  AS ProviderType2_ChemistCoverage,

        ISNULL(pr.ProviderType2_InvoiceCollection,  0)  AS ProviderType2_InvoiceCollection,



        ISNULL(pr.ProviderType3_Name,              '') AS ProviderType3_Name,

        ISNULL(pr.ProviderType3_InvoiceAmount,      0)  AS ProviderType3_InvoiceAmount,

        ISNULL(pr.ProviderType3_ChemistCoverage,    0)  AS ProviderType3_ChemistCoverage,

        ISNULL(pr.ProviderType3_InvoiceCollection,  0)  AS ProviderType3_InvoiceCollection,



        ISNULL(pr.ProviderType4_Name,              '') AS ProviderType4_Name,

        ISNULL(pr.ProviderType4_InvoiceAmount,      0)  AS ProviderType4_InvoiceAmount,

        ISNULL(pr.ProviderType4_ChemistCoverage,    0)  AS ProviderType4_ChemistCoverage,

        ISNULL(pr.ProviderType4_InvoiceCollection,  0)  AS ProviderType4_InvoiceCollection,

         

     





        ISNULL(totalDoctor,  0) totalDoctor ,

        ISNULL(totalCustomer  ,  0)   totalCustomer





    FROM @Base b

    LEFT JOIN @CampaignAgg ca ON ca.RowKey = b.RowKey

    LEFT JOIN @CustomerAgg cu ON cu.RowKey = b.RowKey

    LEFT JOIN @PharmaAgg   ph ON ph.RowKey = b.RowKey

    LEFT JOIN @ProviderAgg pr ON pr.RowKey = b.RowKey;



    -------------------------------------------------------------------------

    -- Raw debug output (optional)

    -------------------------------------------------------------------------

    -- 1) Campaign rows

    SELECT  

        cp.RowKey,

        cp.SlotNo,

        cp.CampaignCode,

        cp.CampaignInvoiceValue,

        cp.CampaignCollection

    FROM @Campaign cp

    WHERE EXISTS (SELECT 1 FROM @Base b WHERE b.RowKey = cp.RowKey)

    ORDER BY cp.RowKey, cp.SlotNo;



    -- 2) Customer rows

    SELECT

        c.RowKey,

        c.SlotNo,

        c.CustomerType,

        c.InvoiceCount,

        c.InvoiceValue,

        c.InvoiceCollection

    FROM @Customer c

    WHERE EXISTS (SELECT 1 FROM @Base b WHERE b.RowKey = c.RowKey)

    ORDER BY c.RowKey, c.SlotNo;



    -- 3) Provider rows

    SELECT

        p.RowKey,

        p.SlotNo,

        p.ProviderType,

        p.InvoiceCount,

        p.InvoiceValue,

        p.InvoiceCollection

    FROM @Provider p

    WHERE EXISTS (SELECT 1 FROM @Base b WHERE b.RowKey = p.RowKey)

    ORDER BY p.RowKey, p.SlotNo;

END;
