
CREATE PROCEDURE [dbo].[sp_Save_MarketPropToTable]
    @MarketPropMasterId INT NULL,
    @EntryBy NVARCHAR(MAX) NULL,
    @EntryDate DATETIME NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SubcodeD NVARCHAR(MAX);
    DECLARE @MarketId INT;
    DECLARE @TerritoryId INT;
    DECLARE @MarketCode NVARCHAR(MAX);
    DECLARE @MarketName NVARCHAR(MAX);
    DECLARE @DivisionId INT;
    DECLARE @DistrictId INT;
    DECLARE @ThanaId INT;
    DECLARE @DZSMStationTypeId INT;
    DECLARE @RegionalHeadStationTypeId INT;
    DECLARE @AMStationTypeId INT;
    DECLARE @MIOStationTypeId INT;
    DECLARE @SalesAssistantStationTypeId INT;
    DECLARE @ConvertType NVARCHAR(MAX);
    DECLARE @sTerId INT = 0;

    DECLARE @MyCursor CURSOR;
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    SELECT ConvertType,
           MarketId,
           TerritoryId,
           MarketCode,
           MarketName,
           DivisionId,
           DistrictId,
           ThanaId,
           DZSMStationTypeId,
           RegionalHeadStationTypeId,
           AMStationTypeId,
           MIOStationTypeId,
           SalesAssistantStationTypeId
    FROM dbo.tblMarketPropDetail
    LEFT JOIN dbo.tblMarketPropMaster
           ON tblMarketPropMaster.MarketPropMasterId = tblMarketPropDetail.MarketPropMasterId
    WHERE tblMarketPropMaster.MarketPropMasterId = @MarketPropMasterId  -- ✅ hardcoded 109 সরানো হয়েছে
      AND IsTransfer = 0;

    OPEN @MyCursor;
    FETCH NEXT FROM @MyCursor
    INTO @ConvertType, @MarketId, @TerritoryId, @MarketCode, @MarketName, @DivisionId, @DistrictId, @ThanaId,
         @DZSMStationTypeId, @RegionalHeadStationTypeId, @AMStationTypeId, @MIOStationTypeId, @SalesAssistantStationTypeId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- ✅ প্রতিটা iteration এ @sTerId রিসেট
        SET @sTerId = 0;

        IF (@ConvertType = 'MarketUpdate')
        BEGIN
            IF (@MarketName = '')
            BEGIN
                SELECT @sTerId = ISNULL(strr.SubTerritoryId, 0)
                FROM tblMarket strr
                WHERE strr.MarketCode = @MarketCode;

                -- ✅ যদি SELECT কোনো row না পায়, আবার 0 করো
                IF @sTerId IS NULL SET @sTerId = 0;

                UPDATE dbo.tblMarket
                   SET UpdateBy = @EntryBy,
                       MarketName = (SELECT MarketName FROM dbo.tblMarket WHERE MarketId = @MarketId),
                       UpdateDate = GETDATE(),
                       ThanaId = @ThanaId
                 WHERE MarketId = @MarketId;
            END
            ELSE
            BEGIN
                -- ✅ MarketUpdate else branch এ আলাদা রিসেট
                SET @sTerId = 0;

                SELECT @sTerId = ISNULL(strr.SubTerritoryId, 0)
                FROM tblMarket strr
                WHERE strr.MarketCode = @MarketCode;

                IF @sTerId IS NULL SET @sTerId = 0;

                IF (@sTerId = 0)
                BEGIN
                    -- ✅ Race condition এড়াতে MAX ব্যবহার
                    SELECT @SubcodeD = 'STR-' + CONVERT(NVARCHAR(MAX), (ISNULL(MAX(SubTerritoryId), 10000) + 1))
                    FROM dbo.tblSubTerritory;

                    INSERT INTO dbo.tblSubTerritory
                    (
                        TerritoryId,
                        SubTerritoryName,
                        SubTerritoryCode,
                        SubTerritoryShortName,
                        Description,
                        Remarks,
                        IsActive,
                        EntryBy,
                        EntryDate
                    )
                    VALUES
                    (
                        @TerritoryId,
                        @MarketName,
                        @SubcodeD,
                        N'',
                        N'',
                        N'',
                        '1',
                        @EntryBy,
                        @EntryDate
                    );

                    SELECT @sTerId = SCOPE_IDENTITY();
                END

                UPDATE dbo.tblMarket
                   SET UpdateBy = @EntryBy,
                       MarketName = @MarketName,
                       SubTerritoryId = @sTerId,
                       UpdateDate = GETDATE(),
                       ThanaId = @ThanaId
                 WHERE MarketId = @MarketId;
            END

            IF (@MIOStationTypeId IS NOT NULL)
            BEGIN
                DELETE FROM tblMarketStationDetail WHERE MarketId = @MarketId AND UserRoleID = 1;
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MarketId, @MIOStationTypeId, 1);
            END

            IF (@AMStationTypeId IS NOT NULL)
            BEGIN
                DELETE FROM tblMarketStationDetail WHERE MarketId = @MarketId AND UserRoleID = 2;
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MarketId, @AMStationTypeId, 2);
            END

            IF (@DZSMStationTypeId IS NOT NULL)
            BEGIN
                DELETE FROM tblMarketStationDetail WHERE MarketId = @MarketId AND UserRoleID = 3;
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MarketId, @DZSMStationTypeId, 3);
            END

            IF (@RegionalHeadStationTypeId IS NOT NULL)
            BEGIN
                DELETE FROM tblMarketStationDetail WHERE MarketId = @MarketId AND UserRoleID = 4;
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MarketId, @RegionalHeadStationTypeId, 4);
            END

            IF (@SalesAssistantStationTypeId IS NOT NULL)
            BEGIN
                DELETE FROM tblMarketStationDetail WHERE MarketId = @MarketId AND UserRoleID = 32;
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MarketId, @SalesAssistantStationTypeId, 32);
            END
        END

        IF (@ConvertType = 'TerritoryUpdate')
        BEGIN
            -- ✅ মূল Fix: প্রতি iteration এ রিসেট (উপরে global SET @sTerId = 0 দেওয়া হয়েছে)
            -- কিন্তু TerritoryUpdate এ ঢোকার সময় নিশ্চিতভাবে আবার রিসেট
            SET @sTerId = 0;

            SELECT @sTerId = ISNULL(strr.SubTerritoryId, 0)
            FROM tblSubTerritory strr
            INNER JOIN tblTerritory tr ON tr.TerritoryId = strr.TerritoryId
            WHERE tr.TerritoryId = @TerritoryId
              AND strr.SubTerritoryName = @MarketName;

            -- ✅ SELECT এ row না পেলে @sTerId unchanged থাকে, তাই আবার চেক
            IF @sTerId IS NULL SET @sTerId = 0;

            IF (@sTerId = 0)
            BEGIN
                -- ✅ Race condition এড়াতে MAX ব্যবহার
                SELECT @SubcodeD = 'STR-' + CONVERT(NVARCHAR(MAX), (ISNULL(MAX(SubTerritoryId), 10000) + 1))
                FROM dbo.tblSubTerritory;

                INSERT INTO dbo.tblSubTerritory
                (
                    TerritoryId,
                    SubTerritoryName,
                    SubTerritoryCode,
                    SubTerritoryShortName,
                    Description,
                    Remarks,
                    IsActive,
                    EntryBy,
                    EntryDate
                )
                VALUES
                (
                    @TerritoryId,
                    @MarketName,
                    @SubcodeD,
                    N'',
                    N'',
                    N'',
                    '1',
                    @EntryBy,
                    @EntryDate
                );

                SELECT @sTerId = SCOPE_IDENTITY();
            END

            UPDATE dbo.tblMarket
               SET SubTerritoryId = @sTerId,
                   UpdateBy = @EntryBy,
                   UpdateDate = GETDATE()
             WHERE MarketId = @MarketId;
        END

        IF (@ConvertType = 'MarketInsert')
        BEGIN
            DECLARE @CountData INT = 0;

            IF (@MarketCode <> '')
            BEGIN
                SELECT @CountData = @CountData + ISNULL(COUNT(*), 0)
                FROM dbo.tblMarket
                WHERE MarketCode = @MarketCode;
            END
            ELSE
            BEGIN
                -- ✅ Race condition এড়াতে MAX ব্যবহার
                SELECT @MarketCode = 'MAR-' + CONVERT(NVARCHAR(MAX), (ISNULL(MAX(MarketId), 10000) + 1))
                FROM dbo.tblMarket;
            END

            SELECT @CountData = @CountData + ISNULL(COUNT(*), 0)
            FROM dbo.tblMarket
            WHERE MarketName = @MarketName
              AND TerritoryId = @TerritoryId;

            IF (@CountData = 0)
            BEGIN
                -- ✅ Race condition এড়াতে MAX ব্যবহার
                SELECT @SubcodeD = 'STR-' + CONVERT(NVARCHAR(MAX), (ISNULL(MAX(SubTerritoryId), 10000) + 1))
                FROM dbo.tblSubTerritory;

                INSERT INTO dbo.tblSubTerritory
                (
                    TerritoryId,
                    SubTerritoryName,
                    SubTerritoryCode,
                    SubTerritoryShortName,
                    Description,
                    Remarks,
                    IsActive,
                    EntryBy,
                    EntryDate
                )
                VALUES
                (
                    @TerritoryId,
                    @MarketName,
                    @SubcodeD,
                    N'',
                    N'',
                    N'',
                    '1',
                    @EntryBy,
                    @EntryDate
                );

                DECLARE @SubTerrId INT;
                SELECT @SubTerrId = SCOPE_IDENTITY();

                INSERT INTO dbo.tblMarket
                (
                    SubTerritoryId,
                    MarketName,
                    MarketCode,
                    IsActive,
                    acInAcDate,
                    EntryBy,
                    EntryDate,
                    ThanaId,
                    AreaId,
                    TerritoryId
                )
                VALUES
                (
                    @SubTerrId,
                    @MarketName,
                    @MarketCode,
                    1,
                    GETDATE(),
                    @EntryBy,
                    @EntryDate,
                    @ThanaId,
                    0,
                    @TerritoryId
                );

                DECLARE @MrkId INT;
                SELECT @MrkId = SCOPE_IDENTITY();

                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MrkId, @MIOStationTypeId, 1);
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MrkId, @AMStationTypeId, 2);
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MrkId, @DZSMStationTypeId, 3);
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MrkId, @RegionalHeadStationTypeId, 4);
                INSERT INTO dbo.tblMarketStationDetail (MarketId, StationTypeId, UserRoleID) VALUES (@MrkId, @SalesAssistantStationTypeId, 32);
            END
        END

        FETCH NEXT FROM @MyCursor
        INTO @ConvertType, @MarketId, @TerritoryId, @MarketCode, @MarketName, @DivisionId, @DistrictId, @ThanaId,
             @DZSMStationTypeId, @RegionalHeadStationTypeId, @AMStationTypeId, @MIOStationTypeId, @SalesAssistantStationTypeId;
    END

    CLOSE @MyCursor;
    DEALLOCATE @MyCursor;

    UPDATE dbo.tblMarketPropMaster SET IsTransfer = 1 WHERE MarketPropMasterId = @MarketPropMasterId;
END