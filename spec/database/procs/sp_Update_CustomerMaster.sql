-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_CustomerMaster]
	-- Add the parameters for the stored procedure here
  
	 @CustomerMasterId int,
          @CustomerName  nvarchar(max)=null
           ,@Address  nvarchar(max)=null
           ,@CellNo  nvarchar(max)=null
           ,@MarketId  int=NULL
           
          
         
           ,@MarketName   nvarchar(max)=null
          
         
        
           ,@IsActive   bit=null
        
           ,@CustomerStation   nvarchar(max)=null
           ,@Division   nvarchar(max)=null
           ,@District   nvarchar(max)=null
           ,@Thana  nvarchar(max)=null
          
           ,@CustomerType  nvarchar(max)=null
          
           ,@CustomerTypeId  int=NULL
           ,@DistrictId  int=NULL
           ,@DivisionId  int=NULL
           ,@ThanaId  int=NULL
           ,@StationTypeId   int=NULL
          
         
           ,@DistributionRouteId   int=NULL
           ,@OwnerName nvarchar(max)=null
           ,@VoterID nvarchar(max)=null
           ,@TradeLicense nvarchar(max)=null
           ,@DrugLicense nvarchar(max)=null
           ,@PharmacyCouncilCertificate nvarchar(max)=null
           ,@BCDS nvarchar(max)=null
           
           ,@ActionStatus nvarchar(max)=null
           ,@Email nvarchar(max)=null
           ,@Reamrks nvarchar(max)=null,
	 
	@UpdateBy int=NULL,
	@ProgramTypeId int=NULL,
	@ComUnitId int=NULL,
	@NSMStationTypeId int=NULL,
	@DZSMStationTypeId int=NULL

   
AS
    BEGIN

      	DECLARE   @GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId INT,@SubTerritoryId INT,  @Unit Nvarchar(max), @ComUnitName Nvarchar(max), @ComUnitCode Nvarchar(max) 

	select @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId
		left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
	left join tbl_Division div  with (nolock) on dis.DivisionId=div.DivisionId
		  where  MarketId=@marketId

		    INSERT INTO tblCustMaster_Log ([CustomerMasterId]
           ,[CustomerCode]
           ,[CategoryId]
           ,[CustomerName]
           ,[Address]
           ,[CellNo]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[Addrees2]
           ,[City]
           ,[ConPerson]
           ,[ShippingCond]
           ,[MarketCode]
           ,[MarketName]
           ,[MIACode]
           ,[MIAName]
           ,[AreaCode]
           ,[DisCode]
           ,[FEName]
           ,[ComUnitCode]
           ,[ComUnitName]
           ,[RegionCode]
           ,[DZSMName]
           ,[TermOfPayment]
           ,[CustomerCodeOld]
           ,[UploadDate]
           ,[ExcelUpload]
           ,[FixedCustomer]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[Type]
           ,[ComUnitId]
           ,[IsActive]
           ,[InActiveDate]
           ,[CustomerStation]
           ,[Division]
           ,[District]
           ,[Thana]
           ,[Upazila]
           ,[CustomerType]
           ,[AITGLId]
           ,[CustomerTypeId]
           ,[DistrictId]
           ,[DivisionId]
           ,[ThanaId]
           ,[StationTypeId]
           ,[CreateBy]
           ,[CreateDate]
           ,[IsVatApplicable]
           ,[DistributionRouteId]
           ,[OwnerName]
           ,[VoterID]
           ,[TradeLicense]
           ,[DrugLicense]
           ,[PharmacyCouncilCertificate]
           ,[BCDS]
           ,[ProgramTypeId]
           ,[ApproveBy]
           ,[ApproveDate]
           ,[ActionStatus]
           ,[Email]
           ,[Reamrks]
           ,[Latitude]
           ,[Longitude]
           ,[LocationUpdateBy]
           ,[LocationUpdateTime]
           ,[StreetAddress]
           ,[NSMStationTypeId]
           ,[DZSMStationTypeId]
           ,[ProgramTypeCode]
           ,[COldCode]
           ,[LogBy]
           ,[LogDate])
SELECT [CustomerMasterId]
           ,[CustomerCode]
           ,[CategoryId]
           ,[CustomerName]
           ,[Address]
           ,[CellNo]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[Addrees2]
           ,[City]
           ,[ConPerson]
           ,[ShippingCond]
           ,[MarketCode]
           ,[MarketName]
           ,[MIACode]
           ,[MIAName]
           ,[AreaCode]
           ,[DisCode]
           ,[FEName]
           ,[ComUnitCode]
           ,[ComUnitName]
           ,[RegionCode]
           ,[DZSMName]
           ,[TermOfPayment]
           ,[CustomerCodeOld]
           ,[UploadDate]
           ,[ExcelUpload]
           ,[FixedCustomer]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[Type]
           ,[ComUnitId]
           ,[IsActive]
           ,[InActiveDate]
           ,[CustomerStation]
           ,[Division]
           ,[District]
           ,[Thana]
           ,[Upazila]
           ,[CustomerType]
           ,[AITGLId]
           ,[CustomerTypeId]
           ,[DistrictId]
           ,[DivisionId]
           ,[ThanaId]
           ,[StationTypeId]
           ,[CreateBy]
           ,[CreateDate]
           ,[IsVatApplicable]
           ,[DistributionRouteId]
           ,[OwnerName]
           ,[VoterID]
           ,[TradeLicense]
           ,[DrugLicense]
           ,[PharmacyCouncilCertificate]
           ,[BCDS]
           ,[ProgramTypeId]
           ,[ApproveBy]
           ,[ApproveDate]
           ,[ActionStatus]
           ,[Email]
           ,[Reamrks]
           ,[Latitude]
           ,[Longitude]
           ,[LocationUpdateBy]
           ,[LocationUpdateTime]
           ,[StreetAddress]
           ,[NSMStationTypeId]
           ,[DZSMStationTypeId]
           ,[ProgramTypeCode]
           ,[COldCode]
           ,@UpdateBy
           ,GETDATE()
FROM tblCustMaster
WHERE     CustomerMasterId=@CustomerMasterId and ActionStatus='2'

		   
   
UPDATE [dbo].[tblCustMaster]
   SET 
   [CustomerName]=@CustomerName
           ,[Address]=@Address
           ,[CellNo]=@CellNo,

		   GroupId=@GroupId,RegionId=@RegionId,AreaId=@AreaId,TerritoryId=@TerritoryId,SubTerritoryId=@SubTerritoryId
           ,[MarketId]=@MarketId
          
         
           ,[MarketName]=@MarketName
          
         
        
           ,[IsActive]=@IsActive
        
           ,[CustomerStation]=@CustomerStation
           ,[Division]=@Division
           ,[District]=@District
           ,[Thana]=@Thana
          
           ,[CustomerType]=@CustomerType
          
           ,[CustomerTypeId]=@CustomerTypeId
           ,[DistrictId]=@DistrictId
           ,[DivisionId]=@DivisionId
           ,[ThanaId]=@ThanaId
           ,[StationTypeId]=@StationTypeId
           ,UpdateBy=@UpdateBy
           ,UpdateDate=GETDATE()

         
           ,[DistributionRouteId]=@DistributionRouteId
           ,[OwnerName]=@OwnerName
           ,[VoterID]=@VoterID
           ,[TradeLicense]=@TradeLicense
           ,[DrugLicense]=@DrugLicense
           ,[PharmacyCouncilCertificate]=@PharmacyCouncilCertificate
           ,[BCDS]=@BCDS
           
          
           ,[Email]=@Email
           ,[Reamrks]=@Reamrks,ProgramTypeId=@ProgramTypeId, NSMStationTypeId=@NSMStationTypeId, DZSMStationTypeId=@DZSMStationTypeId   
		 where CustomerMasterId=@CustomerMasterId

		 delete from tblCustProductLine 	 where CustomerMasterId=@CustomerMasterId







	 
        select  @StationTypeId= ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@MarketId and UserRoleID=1

		   select @NSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@MarketId and UserRoleID=2

		   	   select @DZSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@MarketId and UserRoleID=3



			    DECLARE @RouteInformationMasterId int ,@DCId int ,   @divId int ,@disId int 
		select @divId=div.DivisionId,@disId=dis.DistrictId,  @thanaId=mr.ThanaId, @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId
		left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
		left join tbl_Division div  with (nolock) on dis.DistrictId=div.DivisionId 
		  where  MarketId=@MarketId


		

		  UPDATE dbo.tblCustMaster SET UpdateBy=@UpdateBy, UpdateDate=GETDATE(), ThanaId=@thanaId, DistrictId=@disId, DivisionId=@divId, StationTypeId=@StationTypeId, NSMStationTypeId=@NSMStationTypeId, DZSMStationTypeId=@DZSMStationTypeId
		   where  CustomerMasterId=@CustomerMasterId
    END

