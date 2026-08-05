create FUNCTION [dbo].[GetCampaignCustomernn]
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
    -- Insert customers from market hierarchy
    INSERT INTO @MasterTable (CustomerId, CustomerCode, CampMasId)
    SELECT vcm.CustomerMasterId, vcm.CustomerCode, bcm.CampgainMasterId
    FROM dbo.tbl_BonusCampaignNewMaster bcm WITH (NOLOCK)
    LEFT JOIN tbl_BonusCampaignMarketDetail bcmd WITH (NOLOCK) 
        ON bcm.CampgainMasterId = bcmd.CampaignMasterId
    JOIN dbo.View_CustomerMaster vcm WITH (NOLOCK) ON 
        (bcmd.MarketId IS NOT NULL AND vcm.MarketId = bcmd.MarketId) OR
        (bcmd.MarketId IS NULL AND bcmd.SubTerritoryId IS NOT NULL AND vcm.SubTerritoryId = bcmd.SubTerritoryId) OR
        (bcmd.MarketId IS NULL AND bcmd.SubTerritoryId IS NULL AND bcmd.TerritoryId IS NOT NULL AND vcm.TerritoryId = bcmd.TerritoryId) OR
        (bcmd.MarketId IS NULL AND bcmd.SubTerritoryId IS NULL AND bcmd.TerritoryId IS NULL AND bcmd.AreaId IS NOT NULL AND vcm.AreaId = bcmd.AreaId) OR
        (bcmd.MarketId IS NULL AND bcmd.SubTerritoryId IS NULL AND bcmd.TerritoryId IS NULL AND bcmd.AreaId IS NULL AND bcmd.RegionId IS NOT NULL AND vcm.RegionId = bcmd.RegionId) OR
        (bcmd.MarketId IS NULL AND bcmd.SubTerritoryId IS NULL AND bcmd.TerritoryId IS NULL AND bcmd.AreaId IS NULL AND bcmd.RegionId IS NULL )
    WHERE bcm.CustomerTypeId = @CutstomerType 
      AND (GETDATE() BETWEEN bcm.FromDate AND bcm.Todate)
      AND NOT EXISTS (
          SELECT 1 FROM @MasterTable mt 
          WHERE mt.CustomerId = vcm.CustomerMasterId AND mt.CampMasId = bcm.CampgainMasterId
      );

    -- Insert directly assigned customers
    INSERT INTO @MasterTable (CustomerId, CustomerCode, CampMasId)
    SELECT cm.CustomerMasterId, cm.CustomerCode, bccd.CampaignMasterId 
    FROM tbl_BonusCampaignCustomerDetail bccd WITH (NOLOCK)
    JOIN dbo.tblCustMaster cm WITH (NOLOCK) 
        ON cm.CustomerMasterId = bccd.CustomerMasterId
    WHERE NOT EXISTS (
        SELECT 1 FROM @MasterTable mt 
        WHERE mt.CustomerId = cm.CustomerMasterId AND mt.CampMasId = bccd.CampaignMasterId
    );

    RETURN;
END