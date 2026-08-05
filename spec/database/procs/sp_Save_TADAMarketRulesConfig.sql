
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TADAMarketRulesConfig]
	-- Add the parameters for the stored procedure here
	@TADAMarketRuleConfigId INT,
    @TourType INT =NULL,
	@TAAmount decimal(18,2),
	@DAAmount decimal (18,2),
	@IsActive bit,
	@EntryBy nvarchar(50),

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

	IF(@IsRoleWise=1)
	  begin
	if not exists (select UserRoleID from tbl_TADAMarketRulesConfig where TourType=@TourType AND UserRoleID=@UserRoleID)
    begin 
	
       INSERT INTO [dbo].[tbl_TADAMarketRulesConfig]
           ([TourType]
           ,[TAAmount]
           ,[DAAmount]
           ,[IsActive]
           ,[EntryBy]
           ,[EntryDate]
            
           ,[IsRoleWise]
           ,[IsMarketWise]
           ,[IsBoth]
           ,[UserRoleID]
           ,[GroupId]
           ,[ZoneId]
           ,[AreaId]
           ,[TerritoryId]
           ,[MarketId])
     VALUES
           (@TourType 
           ,@TAAmount 
           ,@DAAmount 
           ,@IsActive 
           ,@EntryBy 
           ,GETDATE()
          
           ,@IsRoleWise 
           ,@IsMarketWise 
           ,@IsBoth 
           ,@UserRoleID 
           ,@GroupId 
           ,@ZoneId 
           ,@AreaId 
           ,@TerritoryId 
           ,@MarketId )

SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
	  else  Return 0

	 
	 
	  	IF(@IsMarketWise=1)
	 
	if not exists (select UserRoleID from tbl_TADAMarketRulesConfig where TourType=@TourType AND MarketId=@MarketId)
    begin 
	
       INSERT INTO [dbo].[tbl_TADAMarketRulesConfig]
           ([TourType]
           ,[TAAmount]
           ,[DAAmount]
           ,[IsActive]
           ,[EntryBy]
           ,[EntryDate]
            
           ,[IsRoleWise]
           ,[IsMarketWise]
           ,[IsBoth]
           ,[UserRoleID]
           ,[GroupId]
           ,[ZoneId]
           ,[AreaId]
           ,[TerritoryId]
           ,[MarketId])
     VALUES
           (@TourType 
           ,@TAAmount 
           ,@DAAmount 
           ,@IsActive 
           ,@EntryBy 
           ,GETDATE()
          
           ,@IsRoleWise 
           ,@IsMarketWise 
           ,@IsBoth 
           ,@UserRoleID 
           ,@GroupId 
           ,@ZoneId 
           ,@AreaId 
           ,@TerritoryId 
           ,@MarketId )

SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
	 




 