
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TadaClaimMaster]
	-- Add the parameters for the stored procedure here
    @TadaID INT = 0 ,
    @TadaDate datetime ,
    @Remarks NVARCHAR(MAX) ,
    @TourTypeId int ,
    @EmpInfoId int ,
    @GroupId int ,
    @RegionId int ,
    @AreaId int ,
    @TerritoryId int ,
    @SubTerritoryId int ,
    @MarketId int ,
    @HotelName NVARCHAR(MAX) ,
    @HotelPhone NVARCHAR(MAX) ,
	@DAAmount Decimal(18,2),
    @UpdateBy NVARCHAR(50)

AS
    BEGIN

	IF  NOT EXISTS (SELECT * FROM [tbl_TadaClaimMaster] WHERE CONVERT(dATE,[TadaDate]) = @TadaDate and EmpInfoId= @EmpInfoId)
		BEGIN

	 
 	declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)

		select @GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=sr.SubTerritoryName, @MarketName=mr.MarketName ,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=sr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		 inner join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
		  where  MarketId=@MarketId

INSERT INTO [dbo].[tbl_TadaClaimMaster]
           ([TadaDate]
           ,[Remarks]
           ,[EntryBy]
           ,[EntryDate]
            
           ,[ApprovalStatus]
           ,[EmpInfoId]
           ,[ApprovedBy]
           ,[ApprovedDate]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[DAAmount]
           ,[TourTypeId]
           ,[HotelName]
           ,[HotelPhone], [GroupName]
      ,[RegionName]
      ,[AreaName]
      ,[TerritoryName]
      ,[SubTerritoryName]
      ,[MarketName]
      ,[GroupCode_DA]
      ,[RegionCode_DA]
      ,[AreaCode_DA]
      ,[TerritoryCode_DA]
      ,[SubTerritoryCode_DA]
      ,[MarketCode_DA])
     VALUES
           (@TadaDate 
           ,@Remarks 
           ,@UpdateBy 
           ,GETDATE() 
           
           ,'2' 
           ,@EmpInfoId 
           ,@UpdateBy 
           ,GETDATE()  
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId 
           ,@DAAmount 
           ,@TourTypeId 
           ,@HotelName 
           ,@HotelPhone,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord )
		   SELECT SCOPE_IDENTITY()
    END
	END
