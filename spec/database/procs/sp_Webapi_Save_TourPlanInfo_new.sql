CREATE PROCEDURE [dbo].[sp_Webapi_Save_TourPlanInfo_new]
	-- Add the parameters for the stored procedure here
    --@IsMarketWise BIT = NULL ,
    --@territoryId INT = NULL ,
    @marketId INT = NULL ,
  @IsMorning bit = NULL 
           ,@IsEvening bit = NULL 
           ,@IsStartTime bit = NULL 
           ,@Starttime  nvarchar(50)
           ,@IsEndtime bit = NULL 
           ,@Endtime  nvarchar(50),
    --@subMarketId INT = NULL ,
    @customerId INT =null,
    --@shiftId INT = NULL ,
    --@typeId INT = NULL ,
    @PurposeId INT = NULL ,
    --@Comment NVARCHAR(MAX) = NULL ,
    @TourDate datetime = NULL ,
    @empId INT = null,
    @SerialNo INT = null,
    @VisitedWithEmpInfoId INT = null


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

	if(ISNULL(@marketId,0)>0)
	begin
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

 	declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)


 SELECT  @StationTypeId=StationTypeId FROM dbo.tblMarketStationDetail WHERE MarketId=@MarketId AND UserRoleID=@RoleTypeId


		select @SubTerritoryId_=sr.SubTerritoryId,@TerritoryId_=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId,@GroupName=gr.GroupName, @RegionName=rg.RegionName, @AreaName=Ar.AreaName,@TerritoryName=Tr.TerritoryName ,@SubTerritoryName=sr.SubTerritoryName, @MarketName=mr.MarketName ,@GroupCode_ord=gr.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=Tr.TerritoryCode ,@SubTerritoryCode_ord=sr.SubTerritoryCode , @MarketCode_ord=mr.MarketCode from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		 inner join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
		  where  MarketId=@MarketId
    
        INSERT  INTO dbo.tbl_TourPlanInfo
                (  
                  CustomerMasterId ,
                 
                 
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
           ,[MarketCode_TP],[IsMorning]
           ,[IsEvening]
           ,[IsStartTime]
           ,[Starttime]
           ,[IsEndtime]
           ,[Endtime],VisitedWithEmpInfoId
	            )
        VALUES  (  
                  @customerId ,
               
                
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
		   @IsMorning
           ,@IsEvening
           ,@IsStartTime
           ,@Starttime 
           ,@IsEndtime
           ,@Endtime,@VisitedWithEmpInfoId

                )




    SELECT  SCOPE_IDENTITY()     


    END
    END
    END

