CREATE PROCEDURE [dbo].[sp_Save_BonusCampaignNewMaster]
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
	@ProductLineID int=null,
	@BonusProductId int=null,
		@IsFCFS bit =null,
	@IsRatioWiseIncrement bit=null,
	@IsPTforCOD bit =0,
	@IsPTforOther bit =0


AS
    BEGIN
	
       DECLARE  @CampaignCode NVARCHAR(max)

SELECT @CampaignCode='Cam_'+ CAST(ISNULL(MAX(ISNULL(CampgainMasterId,0)),0)+1001 AS NVARCHAR(max)) FROM dbo.tbl_BonusCampaignNewMaster

  
INSERT INTO [dbo].[tbl_BonusCampaignNewMaster]
           ([CampaignCode]
           ,[EntryBy]
           ,[EntryDate]
         
           ,[CampaignName]
         
           ,[FromDate]
           ,[Todate]
           ,[CampainTypeId]
           ,[IsActive]
           ,[CustomerTypeId]
           ,[Amount]
           ,[MaxAmount],ProductQty,IsTradePolicy,ProductLineID,BonusProductId,  IsRatioWiseIncrement, CampaignCategoryId,  IsFCFS,  IsPTforCOD,IsPTforOther)
     VALUES
           (@CampaignCode
           ,@EntryBy 
           ,GETDATE() 
          
           ,@CampaignName 
           
           ,@FromDate 
           ,@Todate 
           ,@CampainTypeId 
           ,@IsActive 
           ,@CustomerTypeId 
           ,@Amount 
           ,@MaxAmount,@ProductQty,@IsTradePolicy,@ProductLineID,@BonusProductId, @IsRatioWiseIncrement,@CampaignCategoryId,@IsFCFS,  @IsPTforCOD,@IsPTforOther )

SELECT SCOPE_IDENTITY()

END

 