CREATE PROCEDURE [dbo].[sp_Del_BonusCampaignNewMaster]
	-- Add the parameters for the stored procedure here
	@CampgainMasterId INT 

   
AS
    BEGIN

	declare @CampgainMasterMapId int=0
	 
	select @CampgainMasterMapId=CampgainMasterMapId from tbl_BonusCampaignDetailsCustType  where  CampgainMasterId = @CampgainMasterId
	 
DECLARE @CampgainMasterIdNew INT = 0; 
DECLARE @RowCount INT;
if(@CampgainMasterMapId>0)
begin
-- Create a cursor to fetch the CampgainMasterId values for the given CampgainMasterMapId
DECLARE campaign_cursor CURSOR FOR
    SELECT CampgainMasterId 
    FROM tbl_BonusCampaignDetailsCustType 
    WHERE CampgainMasterMapId = @CampgainMasterMapId;

-- Open the cursor
OPEN campaign_cursor;

-- Fetch the first CampgainMasterId value
FETCH NEXT FROM campaign_cursor INTO @CampgainMasterIdNew;

-- Start the loop
WHILE @@FETCH_STATUS = 0
BEGIN


	INSERT INTO [dbo].[tbl_BonusCampaignNewMasterDel]
           ([CampgainMasterId]
           ,[CampaignCode]
           ,[ProductLineID]
           ,[EntryBy]
           ,[EntryDate]
           ,[CompanyId]
           ,[CampaignName]
           ,[CampaignDesc]
           ,[FromDate]
           ,[Todate]
           ,[CampainTypeId]
           ,[IsActive]
           ,[CustomerTypeId]
           ,[Amount]
           ,[MaxAmount]
           ,[ProductQty]
           ,[IsTradePolicy]
           ,[BonusProductId]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsRatioWiseIncrement]
           ,[CampaignCategoryId]
           ,[IsFCFS]
           ,[IsPTforCOD]
           ,[IsPTforOther]
           ,[pkCampaignSetupId])  select [CampgainMasterId]
           ,[CampaignCode]
           ,[ProductLineID]
           ,[EntryBy]
           ,[EntryDate]
           ,[CompanyId]
           ,[CampaignName]
           ,[CampaignDesc]
           ,[FromDate]
           ,[Todate]
           ,[CampainTypeId]
           ,[IsActive]
           ,[CustomerTypeId]
           ,[Amount]
           ,[MaxAmount]
           ,[ProductQty]
           ,[IsTradePolicy]
           ,[BonusProductId]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsRatioWiseIncrement]
           ,[CampaignCategoryId]
           ,[IsFCFS]
           ,[IsPTforCOD]
           ,[IsPTforOther]
           ,[pkCampaignSetupId]  from [tbl_BonusCampaignNewMaster]      WHERE    CampgainMasterId = @CampgainMasterIdNew 


		 
 
    -- Perform the delete operations for the current @CampgainMasterIdNew
    DELETE FROM dbo.tbl_BonusCampaignNewMaster WHERE CampgainMasterId = @CampgainMasterIdNew;
    DELETE FROM dbo.tbl_BonusCampaignDetailsCustType WHERE CampgainMasterId = @CampgainMasterIdNew;


	
INSERT INTO [dbo].[tbl_BonusCampaignNewDetailDEL]
           ([CampaignDetailId]
           ,[CampaignMasterId]
           ,[DiscountPercentage]
           ,[DiscountAmount]
           ,[ProductId]
           ,[Quantity]
           ,[BonusProductId]
           ,[BonusQuantity]
           ,[BonusTypeId]
           ,[CampaignName]
           ,[MinAmount]
           ,[MaxAmount]
           ,[BonusProductCode]
           ,[ProductCode]
           ,[QuantityDteail]
           ,[IsRatioWiseIncrementPro])
    
           select [CampaignDetailId]
           ,[CampaignMasterId]
           ,[DiscountPercentage]
           ,[DiscountAmount]
           ,[ProductId]
           ,[Quantity]
           ,[BonusProductId]
           ,[BonusQuantity]
           ,[BonusTypeId]
           ,[CampaignName]
           ,[MinAmount]
           ,[MaxAmount]
           ,[BonusProductCode]
           ,[ProductCode]
           ,[QuantityDteail]
           ,[IsRatioWiseIncrementPro] from tbl_BonusCampaignNewDetail WHERE CampaignMasterId = @CampgainMasterIdNew; 

    DELETE FROM dbo.tbl_BonusCampaignMarketDetail WHERE CampaignMasterId = @CampgainMasterIdNew;
    DELETE FROM dbo.tbl_BonusCampaignNewDetail WHERE CampaignMasterId = @CampgainMasterIdNew;
    DELETE FROM dbo.tbl_BonusCampaignCustomerDetail WHERE CampaignMasterId = @CampgainMasterIdNew;

    -- Fetch the next CampgainMasterId
    FETCH NEXT FROM campaign_cursor INTO @CampgainMasterIdNew;
END;

-- Close and deallocate the cursor
CLOSE campaign_cursor;
DEALLOCATE campaign_cursor;

end 
else
begin
	INSERT INTO [dbo].[tbl_BonusCampaignNewMasterDel]
           ([CampgainMasterId]
           ,[CampaignCode]
           ,[ProductLineID]
           ,[EntryBy]
           ,[EntryDate]
           ,[CompanyId]
           ,[CampaignName]
           ,[CampaignDesc]
           ,[FromDate]
           ,[Todate]
           ,[CampainTypeId]
           ,[IsActive]
           ,[CustomerTypeId]
           ,[Amount]
           ,[MaxAmount]
           ,[ProductQty]
           ,[IsTradePolicy]
           ,[BonusProductId]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsRatioWiseIncrement]
           ,[CampaignCategoryId]
           ,[IsFCFS]
           ,[IsPTforCOD]
           ,[IsPTforOther]
           ,[pkCampaignSetupId])  select [CampgainMasterId]
           ,[CampaignCode]
           ,[ProductLineID]
           ,[EntryBy]
           ,[EntryDate]
           ,[CompanyId]
           ,[CampaignName]
           ,[CampaignDesc]
           ,[FromDate]
           ,[Todate]
           ,[CampainTypeId]
           ,[IsActive]
           ,[CustomerTypeId]
           ,[Amount]
           ,[MaxAmount]
           ,[ProductQty]
           ,[IsTradePolicy]
           ,[BonusProductId]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsRatioWiseIncrement]
           ,[CampaignCategoryId]
           ,[IsFCFS]
           ,[IsPTforCOD]
           ,[IsPTforOther]
           ,[pkCampaignSetupId]  from [tbl_BonusCampaignNewMaster]      WHERE    CampgainMasterId = @CampgainMasterId 


		   INSERT INTO [dbo].[tbl_BonusCampaignNewDetailDEL]
           ([CampaignDetailId]
           ,[CampaignMasterId]
           ,[DiscountPercentage]
           ,[DiscountAmount]
           ,[ProductId]
           ,[Quantity]
           ,[BonusProductId]
           ,[BonusQuantity]
           ,[BonusTypeId]
           ,[CampaignName]
           ,[MinAmount]
           ,[MaxAmount]
           ,[BonusProductCode]
           ,[ProductCode]
           ,[QuantityDteail]
           ,[IsRatioWiseIncrementPro])
    
           select [CampaignDetailId]
           ,[CampaignMasterId]
           ,[DiscountPercentage]
           ,[DiscountAmount]
           ,[ProductId]
           ,[Quantity]
           ,[BonusProductId]
           ,[BonusQuantity]
           ,[BonusTypeId]
           ,[CampaignName]
           ,[MinAmount]
           ,[MaxAmount]
           ,[BonusProductCode]
           ,[ProductCode]
           ,[QuantityDteail]
           ,[IsRatioWiseIncrementPro] from tbl_BonusCampaignNewDetail WHERE CampaignMasterId = @CampgainMasterId; 
 
 
		Delete From dbo.tbl_BonusCampaignNewMaster where  CampgainMasterId = @CampgainMasterId
		Delete From dbo.tbl_BonusCampaignDetailsCustType where  CampgainMasterId = @CampgainMasterId
		Delete From dbo.tbl_BonusCampaignMarketDetail where  CampaignMasterId = @CampgainMasterId
		 Delete From dbo.tbl_BonusCampaignNewDetail where  CampaignMasterId = @CampgainMasterId

		Delete From dbo.tbl_BonusCampaignCustomerDetail where  CampaignMasterId = @CampgainMasterId

    END
    END
