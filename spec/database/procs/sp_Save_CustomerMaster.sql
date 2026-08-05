-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_CustomerMaster]
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
	 
	@EntryBy int=NULL,
	@ProgramTypeId int=NULL,
	@ComUnitId int=NULL,
	@NSMStationTypeId int=NULL,
	@DZSMStationTypeId int=NULL


 

AS
    BEGIN
	
	DECLARE   @GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId INT,@SubTerritoryId INT,  @Unit Nvarchar(max), @ComUnitName Nvarchar(max), @ComUnitCode Nvarchar(max) 

	select @DivisionId=div.DivisionId,@DistrictId=dis.DistrictId,  @ThanaId=mr.ThanaId,@SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId
		left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
		left join tbl_Division div  with (nolock) on dis.DivisionId=div.DivisionId
		  where  MarketId=@marketId


		    select  @StationTypeId= ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId and UserRoleID=1

		   select @NSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId and UserRoleID=2

		   	   select @DZSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@marketId and UserRoleID=3
		   
  select   @ComUnitName=cunit.ComUnitName,@ComUnitCode=cunit.ComUnitCode FROM  tblCompanyUnit  cunit
 

where cunit.ComUnitId=@ComUnitId

		  
		   DECLARE @CustCode NVARCHAR(MAX)
	DECLARE @CustCodeint INT
SELECT  @CustCodeint=MAX(CONVERT(INT,SUBSTRING(CustomerCode,2,LEN(CustomerCode)+1)))+1 FROM dbo.tblCustMaster WHERE ActionStatus='2'
-- ORDER BY CustomerMasterId DESC
SET @CustCode='C'+CONVERT(NVARCHAR(MAX),@CustCodeint)

	 


 INSERT INTO [dbo].[tblCustMaster]
           ( [CustomerName]
           ,[Address]
           ,[CellNo]
           ,[MarketId]
          
         
           ,[MarketName]
          
         
        
           ,[IsActive]
        
           ,[CustomerStation]
           ,[Division]
           ,[District]
           ,[Thana]
          
           ,[CustomerType]
          
           ,[CustomerTypeId]
           ,[DistrictId]
           ,[DivisionId]
           ,[ThanaId]
           ,[StationTypeId]
           ,[CreateBy]
           ,[CreateDate]
         
           ,[DistributionRouteId]
           ,[OwnerName]
           ,[VoterID]
           ,[TradeLicense]
           ,[DrugLicense]
           ,[PharmacyCouncilCertificate]
           ,[BCDS]
           
           ,[ActionStatus]
           ,[Email]
           ,[Reamrks],ProgramTypeId, CustomerCode,GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, NSMStationTypeId, DZSMStationTypeId, ComUnitId,ComUnitName, ComUnitCode)
     VALUES
           ( @CustomerName 
           ,@Address 
           ,@CellNo 
           ,@MarketId 
          
         
           ,@MarketName 
          
         
        
           ,@IsActive 
        
           ,@CustomerStation 
           ,@Division 
           ,@District 
           ,@Thana 
          
           ,@CustomerType 
          
           ,@CustomerTypeId 
           ,@DistrictId 
           ,@DivisionId 
           ,@ThanaId 
           ,@StationTypeId 
           ,@EntryBy 
           ,GETDATE() 
         
           ,@DistributionRouteId 
           ,@OwnerName 
           ,@VoterID 
           ,@TradeLicense 
           ,@DrugLicense 
           ,@PharmacyCouncilCertificate 
           ,@BCDS 
           
           ,'2' 
           ,@Email 
           ,@Reamrks,@ProgramTypeId,@CustCode,@GroupId,@RegionId,@AreaId,@TerritoryId,@SubTerritoryId,@NSMStationTypeId,@DZSMStationTypeId,@ComUnitId,@ComUnitName,@ComUnitCode )

SELECT SCOPE_IDENTITY()

END

