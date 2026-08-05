
CREATE PROCEDURE [dbo].[sp_Update_MarketStructure_Transfer]
	-- Add the parameters for the stored procedure here
   
    
	@Type NVARCHAR(50) ,

	@FGroupId int=null
           ,@FRegionId   int=null
           ,@FAreaId   int=null
           ,@FTerritoryId   int=null
           ,@FSubTerritoryId   int=null
          
           ,@TGroupId   int=null
           ,@TRegionId  int=null
           ,@TAreaId  int=null
           ,@TTerritoryId  int=null
           ,@TSubTerritoryId  int=null
           ,@TMarketId  int=null
           ,@EntryBy  int=null

  

AS
    BEGIN
 
 if(@Type='Market')
    BEGIN
	declare @FMarketId int =null
	--select @FMarketId=MarketId from tblMarket where  SubTerritoryId=@FSubTerritoryId 

	INSERT INTO [dbo].[tblMarketStructureTranfer]
           ([FGroupId]
           ,[FRegionId]
           ,[FAreaId]
           ,[FTerritoryId]
           ,[FSubTerritoryId]
           ,[FMarketId]
           ,[TGroupId]
           ,[TRegionId]
           ,[TAreaId]
           ,[TTerritoryId]
           ,[TSubTerritoryId]
           ,[TMarketId]
           ,[EntryBy]
           ,[EntryDate],MarketType)
     VALUES
           (@FGroupId 
           ,@FRegionId 
           ,@FAreaId 
           ,@FTerritoryId 
           ,@FSubTerritoryId 
           ,@FMarketId 
           ,@TGroupId 
           ,@TRegionId 
           ,@TAreaId 
           ,@TTerritoryId 
           ,@TSubTerritoryId 
           ,@TMarketId 
           ,@EntryBy 
           ,GETDATE(),@Type)

     


 
		--UPDATE tblMarket SET SubTerritoryId=@TSubTerritoryId,   
	 --       UpdateBy = @EntryBy , UpdateDate=GETDATE() 

	 --   WHERE  MarketId=@TMarketId
		END



		 if(@Type='Sub-Territory')
    BEGIN
	 
	--select @FTerritoryId= TerritoryId from tblSubTerritory where  SubTerritoryId=@FSubTerritoryId 

	INSERT INTO [dbo].[tblMarketStructureTranfer]
           ([FGroupId]
           ,[FRegionId]
           ,[FAreaId]
           ,[FTerritoryId]
           ,[FSubTerritoryId]
           ,[FMarketId]
           ,[TGroupId]
           ,[TRegionId]
           ,[TAreaId]
           ,[TTerritoryId]
           ,[TSubTerritoryId]
           ,[TMarketId]
           ,[EntryBy]
           ,[EntryDate],MarketType)
     VALUES
           (@FGroupId 
           ,@FRegionId 
           ,@FAreaId 
           ,@FTerritoryId 
           ,@FSubTerritoryId 
           ,@FMarketId 
           ,@TGroupId 
           ,@TRegionId 
           ,@TAreaId 
           ,@TTerritoryId 
           ,@TSubTerritoryId 
           ,@TMarketId 
           ,@EntryBy 
           ,GETDATE(),@Type)

     


 
		--UPDATE tblMarket SET SubTerritoryId=@TSubTerritoryId,   
	 --       UpdateBy = @EntryBy , UpdateDate=GETDATE() 

	 --   WHERE  MarketId=@TMarketId
		END
 


  if(@Type='Territory')
    BEGIN
	 
	--select @FTerritoryId= TerritoryId from tblSubTerritory where  SubTerritoryId=@FSubTerritoryId 

	INSERT INTO [dbo].[tblMarketStructureTranfer]
           ([FGroupId]
           ,[FRegionId]
           ,[FAreaId]
           ,[FTerritoryId]
           ,[FSubTerritoryId]
           ,[FMarketId]
           ,[TGroupId]
           ,[TRegionId]
           ,[TAreaId]
           ,[TTerritoryId]
           ,[TSubTerritoryId]
           ,[TMarketId]
           ,[EntryBy]
           ,[EntryDate],MarketType)
     VALUES
           (@FGroupId 
           ,@FRegionId 
           ,@FAreaId 
           ,@FTerritoryId 
           ,@FSubTerritoryId 
           ,@FMarketId 
           ,@TGroupId 
           ,@TRegionId 
           ,@TAreaId 
           ,@TTerritoryId 
           ,@TSubTerritoryId 
           ,@TMarketId 
           ,@EntryBy 
           ,GETDATE(),@Type)

     


 
		--UPDATE tblMarket SET SubTerritoryId=@TSubTerritoryId,   
	 --       UpdateBy = @EntryBy , UpdateDate=GETDATE() 

	 --   WHERE  MarketId=@TMarketId
		END

    END
	
