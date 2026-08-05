
CREATE PROCEDURE [dbo].[sp_Save_MarketPropDetail]
    @MarketPropMasterId INT NULL,
    @TerritoryCode NVARCHAR(MAX) NULL,
    @MarketCode NVARCHAR(MAX) NULL,
    @MarketName NVARCHAR(MAX) NULL,
    @DivisionName NVARCHAR(MAX) NULL,
    @DistrictName NVARCHAR(MAX) NULL,
    @ThanaName NVARCHAR(MAX) NULL,
    @DZSMStationType NVARCHAR(MAX) NULL,
    @AMStationType NVARCHAR(MAX) NULL,
    @MIOStationType NVARCHAR(MAX) NULL,
    @SalesAssistantStationType NVARCHAR(MAX) NULL,
    @RegionalHeadStationType NVARCHAR(MAX) NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TerritoryId INT,
            @MarketId INT,
            @DivisionId INT,
            @DistrictId INT,
            @ThanaId INT,
            @DZSMStationTypeId INT,
            @RegionalHeadStationTypeId INT,
            @AMStationTypeId INT,
            @MIOStationTypeId INT,
            @SalesAssistantStationTypeId INT;

    SELECT @TerritoryId = ISNULL(TerritoryId, 0) FROM dbo.tblTerritory WHERE TerritoryCode = @TerritoryCode;
    SELECT @MarketId = ISNULL(MarketId, 0) FROM dbo.tblMarket WHERE MarketCode = @MarketCode;
    SELECT @DivisionId = ISNULL(DivisionId, 0) FROM dbo.tbl_Division WHERE DivisionName = @DivisionName;
    SELECT @DistrictId = ISNULL(DistrictId, 0) FROM dbo.tbl_District WHERE DistrictName = @DistrictName;
    SELECT @ThanaId = ISNULL(ThanaId, 0) FROM dbo.tbl_Thana WHERE ThanaName = @ThanaName;
    SELECT @RegionalHeadStationTypeId = ISNULL(StationTypeId, 0) FROM dbo.tblStationType WHERE StationCode = @RegionalHeadStationType;
    SELECT @DZSMStationTypeId = ISNULL(StationTypeId, 0) FROM dbo.tblStationType WHERE StationCode = @DZSMStationType;
    SELECT @AMStationTypeId = ISNULL(StationTypeId, 0) FROM dbo.tblStationType WHERE StationCode = @AMStationType;
    SELECT @MIOStationTypeId = ISNULL(StationTypeId, 0) FROM dbo.tblStationType WHERE StationCode = @MIOStationType;
    SELECT @SalesAssistantStationTypeId = ISNULL(StationTypeId, 0) FROM dbo.tblStationType WHERE StationCode = @SalesAssistantStationType;

    INSERT INTO dbo.tblMarketPropDetail
    (
        MarketPropMasterId,
        TerritoryCode,
        TerritoryId,
        MarketId,
        MarketCode,
        MarketName,
        DivisionName,
        DivisionId,
        DistrictName,
        DistrictId,
        ThanaName,
        ThanaId,
        DZSMStationType,
        DZSMStationTypeId,
        AMStationType,
        AMStationTypeId,
        MIOStationType,
        MIOStationTypeId,
        SalesAssistantStationType,
        SalesAssistantStationTypeId,
        RegionalHeadStationType,
        RegionalHeadStationTypeId
    )
    VALUES
    (
        @MarketPropMasterId,
        @TerritoryCode,
        ISNULL(@TerritoryId, 0),
        ISNULL(@MarketId, 0),
        @MarketCode,
        ISNULL(@MarketName, (SELECT MarketName FROM dbo.tblMarket WHERE MarketId = @MarketId)),
        @DivisionName,
        ISNULL(@DivisionId, 0),
        @DistrictName,
        ISNULL(@DistrictId, 0),
        @ThanaName,
        ISNULL(@ThanaId, (SELECT ThanaId FROM dbo.tblMarket WHERE MarketId = @MarketId)),
        @DZSMStationType,
        @DZSMStationTypeId,
        @AMStationType,
        @AMStationTypeId,
        @MIOStationType,
        @MIOStationTypeId,
        @SalesAssistantStationType,
        @SalesAssistantStationTypeId,
        @RegionalHeadStationType,
        @RegionalHeadStationTypeId
    );

    SELECT SCOPE_IDENTITY();
END
