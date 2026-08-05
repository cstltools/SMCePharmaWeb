

CREATE PROCEDURE [dbo].[sp_webapi_SavePunchTotalInfo]
	-- Add the parameters for the stored procedure here
	 
@attendaceDate DATETIME,
@pInTime NVARCHAR(50) = NULL,
@pInLat NVARCHAR(50) = NULL,
@pInLong NVARCHAR(50) = NULL,

@remarks NVARCHAR(max) =NULL,
@empId INT,
@EntryDate DATETIME,
@AttType INT,
@AttAddress NVARCHAR(max) =NULL


AS
BEGIN


set @pInTime=FORMAT(getdate(),'hh:mm tt')
DECLARE @CountDataOrd INT
SELECT @CountDataOrd=ISNULL(COUNT(*),0) from tblMarketAttendance_Master_webapi WHERE EmpInfoId = @empId AND   AttendanceDate  BETWEEN DATEADD(MINUTE,-10,GETDATE()) AND DATEADD(SECOND,30,GETDATE())

IF(@CountDataOrd=0)
BEGIN

DECLARE @AttId INT=null
--AttType IN just FOR Inser/UPDATE Process
-- 1 = Just Punch In info Save, 2 = Punch Out Update, 3 = Total Insert
 
 DECLARE @mioId INT,@shiftId int,@UserRoleID int

SELECT @mioId = MIOId FROM dbo.tblMIOInfo WHERE EmployeeId = @empId

DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName ,@UserRoleID= us.UserRoleID 
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
 WHERE emp.EmpInfoId=@empId

SELECT @shiftId = ShiftId FROM dbo.tblEmpGeneralInfo WHERE EmpInfoId = @empId


declare
@GroupIdM INT,@RegionIdM INT,@AreaIdM INT,@TerritoryIdM INT,@SubTerritoryIdM INT,@MarketIdM INT

			declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)


			SELECT @GroupIdM=GroupId,@RegionIdM=RegionId,@AreaIdM=AreaId,@TerritoryIdM=TerritoryId,@SubTerritoryIdM=SubTerritoryId,@MarketIdM=MarketId,  @GroupName=TP.GroupName, @RegionName=TP.RegionName, @AreaName=TP.AreaName,@TerritoryName=TP.TerritoryName ,@SubTerritoryName=TP.SubTerritoryName, @MarketName=TP.MarketName,@GroupCode_ord=TP.GroupCode_TP, @RegionCode_ord=TP.RegionCode_TP, @AreaCode_ord=TP.AreaCode_TP,@TerritoryCode_ord=TP.TerritoryCode_TP ,@SubTerritoryCode_ord=TP.SubTerritoryCode_TP , @MarketCode_ord=TP.MarketCode_TP from   dbo.tbl_TourPlanInfo  TP
		inner join tbl_TourPlanMaster mas on tp.TpMaster=mas.TpMaster where mas.ApprovalStatus='2'
 and TP.EmpInfoId=@empId and TP.serialno='1' and convert(Date, TP.TourPlanDate)=convert(Date, GETDATE())
IF(@AttType = 1)
BEGIN
	

	DECLARE @count INT

SELECT @count =  ISNULL(COUNT(*),0) FROM dbo.tblMarketAttendance_Master_webapi WHERE CONVERT(DATE,AttendanceDate) = CONVERT(DATE,GETDATE())  AND EmpInfoId = @empId  and  AttType=1

IF(@count = 0)
BEGIN
	--IF(NOT EXISTS (SELECT * FROM dbo.tblMarketAttendance_Master_webapi WHERE EmpInfoId = @empId AND CONVERT(DATE,AttendanceDate) = CONVERT(DATE,GETDATE())  and  AttType=1))
	--BEGIN

	

		INSERT INTO dbo.tblMarketAttendance_Master_webapi
        (
          EmpInfoId ,
          PunchInTime ,
          PInLat ,
          PInLog ,
          AttendanceDate,
		  PINCreatedDateTime,
		  ShiftId,AttType,ApprovalStatus, UserRoleID,AttAddress,[GroupId]
      ,[RegionId]
      ,[AreaId]
      ,[TerritoryId]
      ,[SubTerritoryId]
      ,[MarketId],[GroupName_Att]
           ,[RegionName_Att]
           ,[AreaName_Att]
           ,[TerritoryName_Att]
           ,[SubTerritoryName_Att]
           ,[MarketName_Att],[GroupCode_Att]
           ,[RegionCode_Att]
           ,[AreaCode_Att]
           ,[TerritoryCode_Att]
           ,[SubTerritoryCode_Att]
           ,[MarketCode_Att]
        )
VALUES  ( 
			 
			@empId,
			@pInTime,
			@pInLat,
			@pInLong,
			getdate(),
			@EntryDate,
			@shiftId,@AttType,0,@UserRoleID,@AttAddress,@GroupIdM, @RegionIdM, @AreaIdM,@TerritoryIdM,@SubTerritoryIdM,@MarketIdM,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord
        )

		 
		 SET @AttId = SCOPE_IDENTITY()
	END


END

IF(@AttType = 2)
BEGIN
	DECLARE @count2 INT

SELECT @count2 = ISNULL(COUNT(*),0) FROM dbo.tblMarketAttendance_Master_webapi WHERE CONVERT(DATE,AttendanceDate) = CONVERT(DATE,GETDATE())  AND EmpInfoId = @empId  and  AttType=2

IF(@count2 = 0)
BEGIN


if(CONVERT(time,@pInTime)>CONVERT(time,'01:00 pm'))
BEGIN
INSERT INTO dbo.tblMarketAttendance_Master_webapi
        (  
          EmpInfoId ,
          PunchInTime ,
          PInLat ,
          PInLog ,
          AttendanceDate,
		  PINCreatedDateTime,
		  ShiftId,AttType,ApprovalStatus, POutRemarks, UserRoleID,AttAddress,[GroupId]
      ,[RegionId]
      ,[AreaId]
      ,[TerritoryId]
      ,[SubTerritoryId]
      ,[MarketId],[GroupName_Att]
           ,[RegionName_Att]
           ,[AreaName_Att]
           ,[TerritoryName_Att]
           ,[SubTerritoryName_Att]
           ,[MarketName_Att],[GroupCode_Att]
           ,[RegionCode_Att]
           ,[AreaCode_Att]
           ,[TerritoryCode_Att]
           ,[SubTerritoryCode_Att]
           ,[MarketCode_Att]
        )
VALUES  ( 
			
			@empId,
			@pInTime,
			@pInLat,
			@pInLong,
			GETDATE(),
			@EntryDate,
			@shiftId,@AttType,0,@remarks,@UserRoleID,@AttAddress,@GroupIdM, @RegionIdM, @AreaIdM,@TerritoryIdM,@SubTerritoryIdM,@MarketIdM,@GroupName 
           ,@RegionName 
           ,@AreaName 
           ,@TerritoryName 
           ,@SubTerritoryName 
           ,@MarketName ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord
        )
		 
		SET @AttId=SCOPE_IDENTITY()
END
END
end
--IF(@AttType = 3)
--BEGIN
--		INSERT INTO dbo.tblMarketAttendance_Master_webapi
--		        (
--		          EmpInfoId ,
--		          PunchInTime ,
--		          PInLat ,
--		          PInLog ,
		          
--		          POutRemarks ,
--		          AttendanceDate,
--				  PINCreatedDateTime,
--				  POUTCreatedDateTime,
--				  ShiftId,AttType,ApprovalStatus
--		        )
--		VALUES  ( 
			 
--				@empId,
--				@pInTime,
--				@pInLat,
--				@pInLong,
			 
--				@remarks,
--				@attendaceDate,
--				@EntryDate,
--				@EntryDate,
--				@shiftId,2,0

--		        )
--END


select @AttId
--IF(@AttType = 1)
--BEGIN
DECLARE @ToEmpId INT
DECLARE @GroupId INT
DECLARE @RegionId INT
DECLARE @AreaId INT
DECLARE @TerrId INT
DECLARE @MarketId INT

DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
--SELECT * FROM dbo.View_webapi_FieldForce
--LEFT JOIN dbo.tblMIOInfo ON 

IF(@Role='MIO')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT   @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT  @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT  @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
END



IF(@AttId IS not null)
BEGIN
--    SELECT @AttId=AttendanceId FROM dbo.tblMarketAttendance_Master_webapi WHERE CONVERT(DATE,AttendanceDate) = CONVERT(DATE,GETDATE()) AND EmpInfoId = @empId
--END

declare @datess datetime
set @datess=GETDATE()
EXECUTE dbo.sp_webapi_SaveAppLog @ApprovalId = 0,                         -- int
                                 @Date =@datess,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @AttId,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Attendance',                             -- nvarchar(max)
                                 @Step = 1,                               -- int
                                 @GroupId = @GroupId,                            -- int
                                 @RegionId = @RegionId,                           -- int
                                 @AreaId = @AreaId,                             -- int
                                 @TerritoryId = @TerrId,                        -- int
                                 @ToGroupId = 0,                          -- int
                                 @ToRegionId = 0,                         -- int
                                 @ToAreaId = 0,                           -- int
                                 @ToTerritoryId = 0,                      -- int
                                 @EntryByS = @empId,                         -- nvarchar(max)
                                 @EntryDateS = @EntryDate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @EntryDate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 301                              -- int

								 

 
 
END
END

else
begin
set @AttId=-1

select @AttId
end
END