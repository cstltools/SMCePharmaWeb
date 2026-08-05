CREATE PROCEDURE [dbo].[sp_Update_MarketStructure_Approve]
	-- Add the parameters for the stored procedure here
   
    @MasterId NVARCHAR(MAX) , 


    @ApprovedBy NVARCHAR(50) ,
	@Type NVARCHAR(50) 

  

AS
    BEGIN
 
 if(@Type='Market')
    BEGIN

	declare  @TSubTerritoryId int 
	declare  @MarketId nvarchar(max) 

	select @MarketId=TMarketId, @TSubTerritoryId= TSubTerritoryId from tblMarketStructureTranfer where MarketStructureTranferId =@MasterId

 

 UPDATE tblMarketStructureTranfer SET ApprovalStatus='Approved',   
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE() 
			 
	  where    MarketStructureTranferId =@MasterId
	 
			UPDATE tblMarket SET SubTerritoryId=@TSubTerritoryId,   
	        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 
			 
	     WHERE   MarketId =@MarketId
		END
	 
	  if(@Type='Sub-Territory')
    BEGIN

	declare  @SubTerritoryId int 
	declare  @TerritoryId nvarchar(max) 

	select @TerritoryId=TTerritoryId, @SubTerritoryId= TSubTerritoryId from tblMarketStructureTranfer where MarketStructureTranferId =@MasterId

 

 UPDATE tblMarketStructureTranfer SET ApprovalStatus='Approved',   
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE() 
			 
	  where    MarketStructureTranferId =@MasterId
	 
			UPDATE tblSubTerritory SET  TerritoryId=@TerritoryId,   
	        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 
			 
	     WHERE    SubTerritoryId =@SubTerritoryId
		END



		  if(@Type='Territory')
    BEGIN

	declare  @AreaId int 
	declare  @TTerritoryId nvarchar(max) 

	select @AreaId=TAreaId, @TTerritoryId= TTerritoryId from tblMarketStructureTranfer  where MarketStructureTranferId =@MasterId

 

 UPDATE tblMarketStructureTranfer SET ApprovalStatus='Approved',   
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE() 
			 
	  where    MarketStructureTranferId =@MasterId
	 
	 
			UPDATE tblTerritory SET   AreaId=@AreaId,   
	        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 
			 
	     WHERE     TerritoryId =@TTerritoryId
		END
    END
	

