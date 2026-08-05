-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_BonusCampaignMarketDetail]
	-- Add the parameters for the stored procedure here
	 

@CampaignMasterId  INT,
@GroupId  INT,
@RegionId  INT,
@AreaId  INT,
@TerritoryId  INT,
@SubTerritoryId  INT,
@MarketId  INT
AS
    BEGIN
	
    INSERT INTO [dbo].[tbl_BonusCampaignMarketDetail]
           ([CampaignMasterId]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId])
     VALUES
           (@CampaignMasterId 
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId )

 

END

