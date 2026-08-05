CREATE PROCEDURE [dbo].[sp_Webapi_Save_TourPlanInfo_vThree]
 
    @VisitedWithEmpInfoId INT = NULL , 
    @marketId INT = NULL , 
    @marketIdEnd INT = NULL , 
   
    @PurposeId INT = NULL , 
    @TourDate datetime = NULL ,
    @empId INT = null,
    @SerialNo INT = null,

	@IsMorning bit = 0 
           ,@IsEvening bit = 0  
           ,@Starttime  nvarchar(50) 
           ,@Endtime  nvarchar(50),
            @Objective  nvarchar(max) ,

		   	@IsMarketVisit bit = 0 
           ,@IsOtherVisit bit = 0  


AS
    BEGIN
 
--DECLARE @inputDate VARCHAR(max) = @TourDate;
--DECLARE @dayPart VARCHAR(max);
--DECLARE @monthPart VARCHAR(max);
--DECLARE @yearPart VARCHAR(max);

--SET @dayPart = LEFT(@inputDate, 2);
--SET @monthPart = SUBSTRING(@inputDate, 4, 3);
--SET @yearPart = RIGHT(@inputDate, 4);

---- Convert the month abbreviation to its short form
--IF @monthPart = 'Sept'

--begin
--    SET @monthPart = 'Sep';

 


-- end
--SET @TourDate = @dayPart + '-' + @monthPart + '-' + @yearPart;

	if(@TourDate is not null)

	BEGIN

	
	DECLARE @tpMasterId int
	DECLARE @userId INT,
	  @RoleTypeId INT
SELECT @userId = UserId,@RoleTypeId=ur.RoleTypeId  FROM dbo.tblUser
INNER JOIN dbo.tbl_UserRoleInfo ur ON ur.UserRoleID = tblUser.UserRoleID
 

 WHERE EmpInfoId = @empId


	IF(NOT EXISTS(SELECT * FROM dbo.tbl_TourPlanMaster WHERE MonthValue = MONTH(@TourDate) AND YearValue = YEAR(@TourDate) AND EmpInfoId = @empId))
	BEGIN

	INSERT INTO dbo.tbl_TourPlanMaster
	        ( MonthValue ,
	          YearValue ,
	          EmpInfoId ,ApprovalStatus
	          
	        )
	VALUES  ( 
	MONTH(@TourDate),
	YEAR(@TourDate),
	@empId,'0' 

	        )


			SET @tpMasterId = SCOPE_IDENTITY()

		
	END
	ELSE
	BEGIN

	SET @tpMasterId = (SELECT  TOP 1 TPMaster FROM dbo.tbl_TourPlanMaster WHERE MonthValue = MONTH(@TourDate) AND YearValue = YEAR(@TourDate) AND EmpInfoId = @empId ORDER BY TPMaster DESC)
		
	END



	DECLARE @StationTypeId INT, @GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId_ INT,@SubTerritoryId_ INT 


	, @GroupIdEnd INT,@RegionIdEnd INT,@AreaIdEnd INT,@TerritoryId_End INT,@SubTerritoryId_End INT 

 	declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)

	
 	declare @GroupNameEnd nvarchar(max),@RegionNameEnd nvarchar(max),@AreaNameEnd nvarchar(max),@TerritoryNameEnd nvarchar(max),@SubTerritoryNameEnd nvarchar(max),@MarketNameEnd nvarchar(max), @GroupCode_ordEnd nvarchar(max),@RegionCode_ordEnd nvarchar(max),@AreaCode_ordEnd nvarchar(max),@TerritoryCode_ordEnd nvarchar(max),@SubTerritoryCode_ordEnd nvarchar(max),@MarketCode_ordEnd nvarchar(max)


 SELECT  @StationTypeId=StationTypeId FROM dbo.tblMarketStationDetail WHERE MarketId=@MarketId AND UserRoleID=@RoleTypeId
 if(@IsMarketVisit=1)
 begin

 if(ISNULL(@marketId,0)>0)
	begin
 select   
		
@SubTerritoryId_=sr.SubTerritoryId,@TerritoryId_=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=sr.SubTerritoryName, @MarketName=mr.MarketName ,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=sr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		 inner join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
		  where  MarketId=@MarketId


		  	select  @SubTerritoryId_End=sr.SubTerritoryId,@TerritoryId_End=tr.TerritoryId,@AreaIdEnd=ar.AreaId,@RegionIdEnd=rg.RegionId,@GroupIdEnd=rg.GroupId,@GroupNameEnd=gr.GroupName, @RegionNameEnd=rg.RegionName, @AreaNameEnd=Ar.AreaName,@TerritoryNameEnd=Tr.TerritoryName ,@SubTerritoryNameEnd=sr.SubTerritoryName, @MarketNameEnd=mr.MarketName ,@GroupCode_ordEnd=gr.GroupCode, @RegionCode_ordEnd=rg.RegionCode, @AreaCode_ordEnd=Ar.AreaCode,@TerritoryCode_ordEnd=Tr.TerritoryCode ,@SubTerritoryCode_ordEnd=sr.SubTerritoryCode , @MarketCode_ordEnd=mr.MarketCode  
		  from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		 inner join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
		  where  MarketId=@marketIdEnd
    
        INSERT  INTO dbo.tbl_TourPlanInfo
                (  
                
                  TPId ,
                  
                  TourPlanDate ,
                  EmpInfoId ,
                  
                  CreatedBy ,
                  CreatedDate,
				  TPMaster,GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId, MarketId,TourTypeId,SerialNo,[GroupName]
           ,[RegionName]
           ,[AreaName]
           ,[TerritoryName]
           ,[SubTerritoryName]
           ,[MarketName],[GroupCode_TP]
           ,[RegionCode_TP]
           ,[AreaCode_TP]
           ,[TerritoryCode_TP]
           ,[SubTerritoryCode_TP]
           ,[MarketCode_TP],


		   GroupIdEnd,RegionIdEnd,AreaIdEnd,TerritoryIdEnd,SubTerritoryIdEnd, MarketIdEnd,[GroupNameEnd]
           ,[RegionNameEnd]
           ,[AreaNameEnd]
           ,[TerritoryNameEnd]
           ,[SubTerritoryNameEnd]
           ,[MarketNameEnd],[GroupCode_TPEnd]
           ,[RegionCode_TPEnd]
           ,[AreaCode_TPEnd]
           ,[TerritoryCode_TPEnd]
           ,[SubTerritoryCode_TPEnd]
           ,[MarketCode_TPEnd],


		      IsMorning 
      , IsEvening  , Starttime 
        , Endtime , 	 IsMarketVisit 
           , IsOtherVisit, Objective,VisitedWithEmpInfoId
	            )
        VALUES  (  
                 
                
                  @PurposeId ,
                 
                  @TourDate ,
                  @empId ,
                 
                  @userId ,
                  GETDATE(),
				  @tpMasterId,@GroupId,@RegionId,@AreaId,@TerritoryId_,@SubTerritoryId_, @marketId,@StationTypeId,@SerialNo,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord,
		   
		   @GroupIdEnd,@RegionIdEnd,@AreaIdEnd,@TerritoryId_End,@SubTerritoryId_End, @marketIdEnd,

		   @GroupNameEnd 
           ,@RegionNameEnd  
           ,@AreaNameEnd  
           ,@TerritoryNameEnd  
           ,@SubTerritoryNameEnd  
           ,@MarketNameEnd  ,@GroupCode_OrdEnd  
           ,@RegionCode_OrdEnd  
           ,@AreaCode_OrdEnd  
           ,@TerritoryCode_OrdEnd  
           ,@SubTerritoryCode_OrdEnd  
           ,@MarketCode_OrdEnd  , 


		   @IsMorning 
      ,@IsEvening  ,@Starttime 
        ,@Endtime , 	@IsMarketVisit 
           ,@IsOtherVisit,@Objective,@VisitedWithEmpInfoId
                )

 end
 end
		else
		begin

		
        INSERT  INTO dbo.tbl_TourPlanInfo
                (    TPId ,  TourPlanDate ,
                  EmpInfoId ,
                  
                  CreatedBy ,
                  CreatedDate,
				  TPMaster ,	 IsMarketVisit 
           , IsOtherVisit,  SerialNo
	            )
        VALUES  (  
                 
                
                  @PurposeId ,
                 
                  @TourDate ,
                  @empId ,
                 
                  @userId ,
                  GETDATE(),
				  @tpMasterId, @IsMarketVisit 
           ,@IsOtherVisit,@SerialNo
                )
		end



    SELECT  SCOPE_IDENTITY()     

 
    END
    END

