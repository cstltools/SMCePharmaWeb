

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_TADAMarketRulesConfig]
	-- Add the parameters for the stored procedure here
  	@TADAMarketRuleConfigId INT,
    @TourType INT =NULL,
	@TAAmount decimal(18,2),
	@DAAmount decimal (18,2),
	@IsActive bit,
	@UpdateBy nvarchar(50),
	
    @IsRoleWise bit =NULL,
    @IsMarketWise bit =NULL,
    @IsBoth bit =NULL,
    @UserRoleID INT =NULL,
    @GroupId INT =NULL,
    @ZoneId INT =NULL,
    @AreaId INT =NULL,
    @TerritoryId INT =NULL,
    @MarketId INT =NULL

AS
    BEGIN
        UPDATE  [dbo].[tbl_TADAMarketRulesConfig]
        SET     TourType = @TourType,
		        TAAmount = @TAAmount,
				DAAmount = @DAAmount,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive, [IsRoleWise] = @IsRoleWise 
      ,[IsMarketWise] = @IsMarketWise 
      ,[IsBoth] = @IsBoth 
      ,[UserRoleID] = @UserRoleID 
      ,[GroupId] = @GroupId 
      ,[ZoneId] = @ZoneId 
      ,[AreaId] = @AreaId 
      ,[TerritoryId] = @TerritoryId 
      ,[MarketId] = @MarketId 
        
        WHERE   TADAMarketRuleConfigId = @TADAMarketRuleConfigId   

    END


