-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_BonusCampaignNewDetail]
	-- Add the parameters for the stored procedure here
	 

@CampaignMasterId  INT
          
           ,@DiscountPercentage decimal(18,3) =Null 
           ,@ProductId  int =NULL
           ,@Quantity decimal(18,2) =Null 
           ,@BonusProductId  int=NULL
           ,@BonusQuantity decimal(18,3) =Null 
         
           ,@BonusTypeId INT =NULL,
            @CampaignName nvarchar(max) =NULL,
			@QuantityDteail decimal(18,2) =Null ,
	@IsRatioWiseIncrementPro bit=null

AS
    BEGIN
	
    
  
INSERT INTO [dbo].[tbl_BonusCampaignNewDetail]
           ([CampaignMasterId]
          
           ,[DiscountPercentage]
           ,ProductId
           ,[Quantity]
           ,BonusProductId
           ,[BonusQuantity]
        
           ,[BonusTypeId], CampaignName, QuantityDteail,  IsRatioWiseIncrementPro)
     VALUES
           (@CampaignMasterId 
         
           ,@DiscountPercentage 
           ,@ProductId  
           ,@Quantity  
           ,@BonusProductId 
           ,@BonusQuantity   
        
           ,@BonusTypeId,@CampaignName,@QuantityDteail, @IsRatioWiseIncrementPro)

 

END

