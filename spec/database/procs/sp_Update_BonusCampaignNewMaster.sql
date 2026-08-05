
 CREATE PROCEDURE [dbo].[sp_Update_BonusCampaignNewMaster]
	-- Add the parameters for the stored procedure here
	@CampgainMasterId INT,
    @CampaignName nvarchar (max)=NULL,
    
    
	@FromDate datetime=NULL,
    @ToDate datetime=NULL,
	@EntryBy nvarchar(50)=NULL,


	@IsActive BIT=NULL,
    @CampainTypeId INT=NULL,
	@CustomerTypeId  INT=NULL,
	@CampaignCategoryId  INT=NULL,

	  @Amount DECIMAL(18,2)=NULL,
	@MaxAmount   DECIMAL(18,2) =NULL,
	@ProductQty   DECIMAL(18,2) =NULL,
	@IsTradePolicy bit =null,
	@IsFCFS bit =null,
	@ProductLineID int=null,
	@BonusProductId int=null,

	@UpdateBy NVARCHAR(50),
	@IsRatioWiseIncrement bit=null,
	@IsPTforCOD bit =0,
	@IsPTforOther bit =0

   
AS
    BEGIN

       UPDATE [dbo].[tbl_BonusCampaignNewMaster] set
     [ProductLineID] = @ProductLineID 
      
      ,[CampaignName] = @CampaignName 
     
      ,[FromDate] = @FromDate 
      ,[Todate] = @Todate 
      ,[CampainTypeId] = @CampainTypeId 
      ,[IsActive] = @IsActive 
      ,[CustomerTypeId] = @CustomerTypeId 
      ,[Amount] = @Amount 
      ,[MaxAmount] = @MaxAmount 
      ,[ProductQty] = @ProductQty 
      ,[IsTradePolicy] = @IsTradePolicy 
      ,[BonusProductId] = @BonusProductId ,
	  UpdateBy=@UpdateBy,
	  UpdateDate=getdate() ,  IsRatioWiseIncrement  =@IsRatioWiseIncrement,  CampaignCategoryId =@CampaignCategoryId,  IsFCFS=@IsFCFS ,   IsPTforCOD=@IsPTforCOD,IsPTforOther  =@IsPTforOther              
        WHERE    CampgainMasterId = @CampgainMasterId

		Delete From dbo.tbl_BonusCampaignMarketDetail where  CampaignMasterId = @CampgainMasterId
		 Delete From dbo.tbl_BonusCampaignNewDetail where  CampaignMasterId = @CampgainMasterId

		Delete From dbo.tbl_BonusCampaignCustomerDetail where  CampaignMasterId = @CampgainMasterId

    END
