


-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
create FUNCTION [dbo].[GetCampaignCustomerback]
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
		
		DECLARE @GroupId INT=NULL
		DECLARE @RegionId INT=NULL
		DECLARE @AreaId INT=NULL
		DECLARE @TerritoryId INT=NULL
		DECLARE @SubTerritoryId INT=NULL
		DECLARE @MarketId INT=NULL
		DECLARE @CampaignMasterId INT=NULL

		
		
		DECLARE @Main CURSOR
        SET @Main = CURSOR FAST_FORWARD
        FOR
		SELECT 
       GroupId,
       RegionId,
       AreaId,
       TerritoryId,
       SubTerritoryId,
       MarketId,CampaignMasterId FROM dbo.tbl_BonusCampaignNewMaster with (nolock)
LEFT JOIN tbl_BonusCampaignMarketDetail with (nolock) ON 
dbo.tbl_BonusCampaignNewMaster.CampgainMasterId=dbo.tbl_BonusCampaignMarketDetail.CampaignMasterId
WHERE CustomerTypeId=@CutstomerType AND (GETDATE() BETWEEN FromDate AND Todate)
		OPEN @Main
        FETCH NEXT FROM @Main
        INTO @GroupId,
       @RegionId,
       @AreaId,
       @TerritoryId,
       @SubTerritoryId,
       @MarketId,@CampaignMasterId
         
        WHILE @@FETCH_STATUS=0
        BEGIN
		DECLARE @Skip BIT=0
		IF(@MarketId IS NOT NULL )
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        CustomerId,
		        CustomerCode,CampMasId
		    )
		    
		    SELECT  CustomerMasterId,CustomerCode,@CampaignMasterId FROM dbo.View_CustomerMaster with (nolock) WHERE MarketId=@MarketId
			SET @Skip=1
		END

		IF(@SubTerritoryId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        CustomerId,
		        CustomerCode,CampMasId
		    )
		    
		    SELECT CustomerMasterId,CustomerCode,@CampaignMasterId FROM dbo.View_CustomerMaster with (nolock) WHERE SubTerritoryId=@SubTerritoryId
			SET @Skip=1
		END
		IF(@TerritoryId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        CustomerId,
		        CustomerCode,CampMasId
		    )
		    
		    SELECT CustomerMasterId,CustomerCode,@CampaignMasterId FROM dbo.View_CustomerMaster with (nolock) WHERE TerritoryId=@TerritoryId
			SET @Skip=1
		END
		IF(@AreaId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        CustomerId,
		        CustomerCode,CampMasId
		    )
		    
		    SELECT CustomerMasterId,CustomerCode,@CampaignMasterId FROM dbo.View_CustomerMaster with (nolock) WHERE AreaId=@AreaId
			SET @Skip=1
		END
		IF(@RegionId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        CustomerId,
		        CustomerCode,CampMasId
		    )
		    
		    SELECT CustomerMasterId,CustomerCode,@CampaignMasterId FROM dbo.View_CustomerMaster WHERE RegionId=@RegionId
			SET @Skip=1
		END
		IF(@GroupId IS NOT NULL AND @Skip=0 )
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        CustomerId,
		        CustomerCode,CampMasId
		    )
		    
		    SELECT CustomerMasterId,CustomerCode,@CampaignMasterId FROM dbo.View_CustomerMaster with (nolock) WHERE GroupId=@GroupId
			SET @Skip=1
		END
		



		FETCH NEXT FROM @Main
        INTO @GroupId,
       @RegionId,
       @AreaId,
       @TerritoryId,
       @SubTerritoryId,
       @MarketId,@CampaignMasterId
		END
        
		CLOSE @Main
		DEALLOCATE @Main

		INSERT INTO @MasterTable
		(
		    CustomerId,
		    CustomerCode,CampMasId
		)
		SELECT tblCustMaster.CustomerMasterId,CustomerCode,CampaignMasterId FROM tbl_BonusCampaignCustomerDetail with (nolock)
		LEFT JOIN dbo.tblCustMaster with (nolock) ON tblCustMaster.CustomerMasterId = tbl_BonusCampaignCustomerDetail.CustomerMasterId
		

		RETURN
		END






