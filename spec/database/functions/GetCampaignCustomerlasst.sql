create FUNCTION [dbo].[GetCampaignCustomerlasst]
(
    @CutstomerType INT
)
RETURNS 
@MasterTable TABLE 
(
    RowNo INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    CustomerId INT NULL,
    CustomerCode NVARCHAR(MAX),
    CampMasId INT NULL
)
AS
BEGIN
    -- Step 1: Campaigns with priority levels (lower number = higher priority)
    ;WITH CampaignWithPriority AS (
        SELECT 
            cm.CampgainMasterId,
            md.MarketId,
            md.SubTerritoryId,
            md.TerritoryId,
            md.AreaId,
            md.RegionId,
            md.GroupId,
            CASE 
                WHEN md.MarketId IS NOT NULL THEN 1
                WHEN md.SubTerritoryId IS NOT NULL THEN 2
                WHEN md.TerritoryId IS NOT NULL THEN 3
                WHEN md.AreaId IS NOT NULL THEN 4
                WHEN md.RegionId IS NOT NULL THEN 5
                WHEN md.GroupId IS NOT NULL THEN 6
                ELSE 7
            END AS Priority
        FROM dbo.tbl_BonusCampaignNewMaster cm WITH (NOLOCK)
        LEFT JOIN dbo.tbl_BonusCampaignMarketDetail md WITH (NOLOCK)
            ON cm.CampgainMasterId = md.CampaignMasterId
        WHERE cm.CustomerTypeId = @CutstomerType
          AND GETDATE() BETWEEN cm.FromDate AND cm.Todate
    ),
    CustomerMatches AS (
        SELECT DISTINCT
            c.CampgainMasterId,
            v.CustomerMasterId,
            v.CustomerCode,
            c.Priority,
            ROW_NUMBER() OVER (
                PARTITION BY v.CustomerMasterId, c.CampgainMasterId
                ORDER BY c.Priority
            ) AS RowNum
        FROM CampaignWithPriority c
        JOIN dbo.View_CustomerMaster v WITH (NOLOCK)
            ON (
                (c.MarketId IS NOT NULL AND v.MarketId = c.MarketId) OR
                (c.SubTerritoryId IS NOT NULL AND c.MarketId IS NULL AND v.SubTerritoryId = c.SubTerritoryId) OR
                (c.TerritoryId IS NOT NULL AND c.MarketId IS NULL AND c.SubTerritoryId IS NULL AND v.TerritoryId = c.TerritoryId) OR
                (c.AreaId IS NOT NULL AND c.MarketId IS NULL AND c.SubTerritoryId IS NULL AND c.TerritoryId IS NULL AND v.AreaId = c.AreaId) OR
                (c.RegionId IS NOT NULL AND c.MarketId IS NULL AND c.SubTerritoryId IS NULL AND c.TerritoryId IS NULL AND c.AreaId IS NULL AND v.RegionId = c.RegionId) OR
                (c.GroupId IS NOT NULL AND c.MarketId IS NULL AND c.SubTerritoryId IS NULL AND c.TerritoryId IS NULL AND c.AreaId IS NULL AND c.RegionId IS NULL AND v.GroupId = c.GroupId)
            )
    )
    -- Step 2: Insert only first matching customer per campaign based on highest priority
    INSERT INTO @MasterTable (CustomerId, CustomerCode, CampMasId)
    SELECT 
        CustomerMasterId,
        CustomerCode,
        CampgainMasterId
    FROM CustomerMatches
    WHERE RowNum = 1

    -- Step 3: Add directly assigned campaign customers (if not already added)
    INSERT INTO @MasterTable (CustomerId, CustomerCode, CampMasId)
    SELECT 
        c.CustomerMasterId,
        cm.CustomerCode,
        c.CampaignMasterId
    FROM dbo.tbl_BonusCampaignCustomerDetail c WITH (NOLOCK)
    LEFT JOIN dbo.tblCustMaster cm WITH (NOLOCK)
        ON cm.CustomerMasterId = c.CustomerMasterId
    WHERE NOT EXISTS (
        SELECT 1 
        FROM @MasterTable mt
        WHERE mt.CustomerId = c.CustomerMasterId
          AND mt.CampMasId = c.CampaignMasterId
    )

    RETURN
END
