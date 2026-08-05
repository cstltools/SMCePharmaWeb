-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_TadaClaim]
	-- Add the parameters for the stored procedure here
    @tadaDate nvarchar(max) = NULL ,
    @empId INT = NULL ,
    @NewTourTypeId INT = NULL ,
	--@tourtypeid INT=NULL,
	@type NVARCHAR(MAX)=NULL,
    @remarks NVARCHAR(MAX) = NULL ,
    @HotelName NVARCHAR(MAX) = NULL ,
    @HotelPhone NVARCHAR(MAX) = NULL ,
	@id INT=NULL
    --@taMt DECIMAL(18, 2) = NULL ,
    --@daAmt DECIMAL(18, 2) = NULL
AS
    BEGIN

	update  dbo.tbl_TourPlanInfo  set TPId=2
				 where   ISNULL(tbl_TourPlanInfo.TPId,0)=0


		declare @ExtraBenifit int=0
		
		DECLARE @RoleTypeId INT=0
		DECLARE @TourTypeId INT=0
		DECLARE @TourPurposeId INT=0

	DECLARE @Role NVARCHAR(MAX)
DECLARE @ToEmpId INT
DECLARE @GroupId INT
DECLARE @RegionId INT
DECLARE @AreaId INT
DECLARE @TerrId INT
	
DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
		DECLARE @amount DECIMAL(18,2)=0
	    DECLARE @masterId INT=0,@userId INT 
			DECLARE @mainId INT=0
	 IF @tadaDate IS NOT NULL
    BEGIN
        DECLARE @FromDateString VARCHAR(20) = CONVERT(VARCHAR, @tadaDate, 106);
        SET @FromDateString = REPLACE(@FromDateString, 'Sept', 'Sep');
        SET @tadaDate = CONVERT(DATETIME, @FromDateString);
    END
	SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @empId

		SELECT @RoleTypeId=RoleTypeId FROM dbo.tblUser
		LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
		WHERE UserId=@userId

        if(@empId=683)
            begin
            set @RoleTypeId=4
            end

	if(convert(Date,@tadaDate)=convert(Date,getdate()))
	begin
	
	declare @IsOtherVisit bit=0
select @IsOtherVisit=IsOtherVisit from tbl_TourPlanInfo where CONVERT(date,TourPlanDate)=CONVERT(date,GETDATE()) and EmpInfoId=@empId


	if(@IsOtherVisit=1)
	begin

	if not exists (select * from tbl_TadaClaimMaster where CONVERT(date,TadaDate)=CONVERT(date,@tadaDate) and EmpInfoId=@empId)
    begin 

	declare @RoleType nvarchar(max)
	    SELECT @RoleType= uType.RoleType
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @empId;

    

			if(@empId=683)
            begin
            set @RoleType='NSM'
            end


		SELECT @TourPurposeId= isnull(tbl_TourPlanInfo.TPId,0) FROM dbo.tbl_TourPlanInfo 
				inner join tbl_TourPlanMaster mas on tbl_TourPlanInfo.TpMaster=mas.TpMaster where mas.ApprovalStatus='2' and tbl_TourPlanInfo.EmpInfoId=@empId AND tbl_TourPlanInfo.TourPlanId=@id and tbl_TourPlanInfo.SerialNo='1'


				if(@RoleType='NSM')
	begin
	--select distinct RegionId from View_webapi_FieldForce where RSMEMPId=@empId

		select  @amount=ISNULL(daAmt.DAAmount,0)  from tblTourPurposeOtherSetup mas
				inner join tblTourPurposeOtherSetupDtl dtl on mas.TourPurposeOtherSetupId=dtl.TourPurposeOtherSetupId
				 inner JOIN dbo.tblRoleType uType    with (nolock) ON dtl.RoleName =uType.displayname
				inner join tbl_TADAMarketRulesConfig daAmt on daAmt.TourType=dtl.TourTypeId and daAmt.UserRoleID=uType.RoleTypeId
				where dtl.GroupId is not null and dtl.GroupId in (select distinct GroupId from View_webapi_FieldForce where NSMEMPId=@empId) and mas.TourPurposeId=@TourPurposeId   
                
           


	end

	if(@RoleType='DZSM')
	begin
	--select distinct RegionId from View_webapi_FieldForce where RSMEMPId=@empId

		select  @amount=ISNULL(daAmt.DAAmount,0)  from tblTourPurposeOtherSetup mas
				inner join tblTourPurposeOtherSetupDtl dtl on mas.TourPurposeOtherSetupId=dtl.TourPurposeOtherSetupId
				 inner JOIN dbo.tblRoleType uType    with (nolock) ON dtl.RoleName =uType.RoleType
				inner join tbl_TADAMarketRulesConfig daAmt on daAmt.TourType=dtl.TourTypeId and daAmt.UserRoleID=uType.RoleTypeId
				where dtl.RegionId is not null and dtl.RegionId in (select distinct RegionId from View_webapi_FieldForce where RSMEMPId=@empId) and mas.TourPurposeId=@TourPurposeId    


	end

         if(@empId=683)
            begin
           select  @amount=ISNULL(daAmt.DAAmount,0)  from tblTourPurposeOtherSetup mas
				inner join tblTourPurposeOtherSetupDtl dtl on mas.TourPurposeOtherSetupId=dtl.TourPurposeOtherSetupId
				 inner JOIN dbo.tblRoleType uType    with (nolock) ON dtl.RoleName =uType.displayname
				inner join tbl_TADAMarketRulesConfig daAmt on daAmt.TourType=dtl.TourTypeId and daAmt.UserRoleID=uType.RoleTypeId
				where dtl.GroupId is not null and dtl.GroupId in (select distinct GroupId from View_webapi_FieldForce where NSMEMPId=408) and mas.TourPurposeId=@TourPurposeId   
             
            end

	if(@RoleType='AM')
	begin
	--select distinct AreaId from View_webapi_FieldForce where  ASMEMPId=@empId

		select  @amount=ISNULL(daAmt.DAAmount,0)  from tblTourPurposeOtherSetup mas
				inner join tblTourPurposeOtherSetupDtl dtl on mas.TourPurposeOtherSetupId=dtl.TourPurposeOtherSetupId
				 inner JOIN dbo.tblRoleType uType    with (nolock) ON dtl.RoleName =uType.RoleType
				inner join tbl_TADAMarketRulesConfig daAmt on daAmt.TourType=dtl.TourTypeId and daAmt.UserRoleID=uType.RoleTypeId
				where dtl.AreaID is not null and  dtl.AreaID in (select distinct AreaId from View_webapi_FieldForce where  ASMEMPId=@empId) and mas.TourPurposeId=@TourPurposeId    


	end

	
	if(@RoleType='MIO')
begin
   -- select distinct TerritoryId from View_webapi_FieldForce where MIOEmpId=@empId
 

		select  @amount=ISNULL(daAmt.DAAmount,0)  from tblTourPurposeOtherSetup mas
				inner join tblTourPurposeOtherSetupDtl dtl on mas.TourPurposeOtherSetupId=dtl.TourPurposeOtherSetupId
				 inner JOIN dbo.tblRoleType uType    with (nolock) ON dtl.RoleName =uType.RoleType
				inner join tbl_TADAMarketRulesConfig daAmt on daAmt.TourType=dtl.TourTypeId and daAmt.UserRoleID=uType.RoleTypeId
				where dtl.TerritoryId is not null and dtl.TerritoryId in (select distinct TerritoryId from View_webapi_FieldForce where MIOEmpId=@empId) and mas.TourPurposeId=@TourPurposeId    

			

			 
		end
		if(@amount>0)
		begin
INSERT  INTO dbo.tbl_TadaClaimMaster
                ( TadaDate ,
                  Remarks ,
                  EntryBy ,
                  EntryDate ,
                  ApprovalStatus ,
                  EmpInfoId,DAAmount
	            )
        VALUES  ( @tadaDate ,
                  @remarks ,
                  @userId ,
                  GETDATE() ,
                  '0' ,
                  @empId,@amount

	            )

        SET @masterId = SCOPE_IDENTITY()




        INSERT  INTO dbo.tbl_TadaClaimDetails
                ( TadaID, TaAmt, DaAmt )
        VALUES  ( @masterId, 0, @amount )



	
			SELECT SCOPE_IDENTITY()
			SELECT @mainId=SCOPE_IDENTITY()


 
SELECT @Role=usR.RoleName
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
 WHERE emp.EmpInfoId=@empId


 
--SELECT * FROM dbo.View_webapi_FieldForce
--LEFT JOIN dbo.tblMIOInfo ON 

IF(@Role='MIO')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
END

---DECLARE @Id INT

DECLARE @entrydate DATETIME=GETDATE()


EXECUTE dbo.sp_webapi_SaveTADAAppLog @TADAApprovalId = 0,                         -- int
                                 @Date = @tadaDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @masterId,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'TADA',                             -- nvarchar(max)
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
                                 @EntryDateS = @entrydate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @entrydate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 376         
end
end
end


else

 

 


		if not exists (select * from tbl_TadaClaimMaster where CONVERT(date,TadaDate)=CONVERT(date,@tadaDate) and EmpInfoId=@empId)
    begin 
    
		
	declare	@GroupIdM INT,@RegionIdM INT,@AreaIdM INT,@TerritoryIdM INT,@SubTerritoryIdM INT,@MarketIdM INT

			declare @GroupName nvarchar(max),@RegionName nvarchar(max),@AreaName nvarchar(max),@TerritoryName nvarchar(max),@SubTerritoryName nvarchar(max),@MarketName nvarchar(max), @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max)

		


	 

		 IF(@NewTourTypeId=0)
		 BEGIN
			SELECT @TourPurposeId= ISNULL(tbl_TourPlanInfo.TPId,0) , @GroupIdM=GroupId,@RegionIdM=RegionId,@AreaIdM=AreaId,@TerritoryIdM=TerritoryId,@SubTerritoryIdM=SubTerritoryId,@MarketIdM=MarketId,  @TourTypeId=TourTypeId,@GroupName=tbl_TourPlanInfo.GroupName, @RegionName=tbl_TourPlanInfo.RegionName, @AreaName=tbl_TourPlanInfo.AreaName,@TerritoryName=tbl_TourPlanInfo.TerritoryName ,@SubTerritoryName=tbl_TourPlanInfo.SubTerritoryName, @MarketName=tbl_TourPlanInfo.MarketName,@GroupCode_ord=tbl_TourPlanInfo.GroupCode_TP, @RegionCode_ord=tbl_TourPlanInfo.RegionCode_TP, @AreaCode_ord=tbl_TourPlanInfo.AreaCode_TP,@TerritoryCode_ord=tbl_TourPlanInfo.TerritoryCode_TP ,@SubTerritoryCode_ord=tbl_TourPlanInfo.SubTerritoryCode_TP , @MarketCode_ord=tbl_TourPlanInfo.MarketCode_TP FROM dbo.tbl_TourPlanInfo 
				inner join tbl_TourPlanMaster mas on tbl_TourPlanInfo.TpMaster=mas.TpMaster where mas.ApprovalStatus='2' and tbl_TourPlanInfo.EmpInfoId=@empId AND tbl_TourPlanInfo.TourPlanId=@id and tbl_TourPlanInfo.SerialNo='1'
		 END
		 else

		  BEGIN
			SELECT  @TourPurposeId= isnull(tbl_TourPlanInfo.TPId,0) ,@GroupIdM=GroupId,@RegionIdM=RegionId,@AreaIdM=AreaId,@TerritoryIdM=TerritoryId,@SubTerritoryIdM=SubTerritoryId,@MarketIdM=MarketId,  @TourTypeId=@NewTourTypeId,@GroupName=tbl_TourPlanInfo.GroupName, @RegionName=tbl_TourPlanInfo.RegionName, @AreaName=tbl_TourPlanInfo.AreaName,@TerritoryName=tbl_TourPlanInfo.TerritoryName ,@SubTerritoryName=tbl_TourPlanInfo.SubTerritoryName, @MarketName=tbl_TourPlanInfo.MarketName,@GroupCode_ord=tbl_TourPlanInfo.GroupCode_TP, @RegionCode_ord=tbl_TourPlanInfo.RegionCode_TP, @AreaCode_ord=tbl_TourPlanInfo.AreaCode_TP,@TerritoryCode_ord=tbl_TourPlanInfo.TerritoryCode_TP ,@SubTerritoryCode_ord=tbl_TourPlanInfo.SubTerritoryCode_TP , @MarketCode_ord=tbl_TourPlanInfo.MarketCode_TP FROM dbo.tbl_TourPlanInfo 
			
			inner join tbl_TourPlanMaster mas on tbl_TourPlanInfo.TpMaster=mas.TpMaster where mas.ApprovalStatus='2' and tbl_TourPlanInfo.EmpInfoId=@empId AND tbl_TourPlanInfo.TourPlanId=@id and tbl_TourPlanInfo.SerialNo='1'
		 END

		--IF(@type='Visit')
		--BEGIN
		--    SELECT @TourTypeId=TourTypeId FROM dbo.tbl_DoctorTourPlanDetail WHERE EmpInfoId=@empId AND DocTPDetailsId=@id
		--END
		

	 
		select  @ExtraBenifit=count(*) from tbl_TourPlanPurpose  where TPId=100001 and ISNULL(IsExtraBenifit,0)=1 and IsActive=1

		if(@ExtraBenifit>0)
		begin


		if(@RoleTypeId=1)
		begin
		select @amount=MIOAmount from tbl_TourPlanPurpose  where TPId=@TourPurposeId and ISNULL(IsExtraBenifit,0)=1 and IsActive=1

		end

			if(@RoleTypeId=2)
		begin

		select @amount=AMAmount from tbl_TourPlanPurpose  where TPId=@TourPurposeId and ISNULL(IsExtraBenifit,0)=1 and IsActive=1

		end


			if(@RoleTypeId=3)
		begin

		select @amount=DZSMAmount from tbl_TourPlanPurpose  where TPId=@TourPurposeId and ISNULL(IsExtraBenifit,0)=1 and IsActive=1

		end

        	if(@RoleTypeId=4)
		begin

		select @amount=DZSMAmount from tbl_TourPlanPurpose  where TPId=@TourPurposeId and ISNULL(IsExtraBenifit,0)=1 and IsActive=1

		end
		 
		end
		else
		begin

		SELECT @amount=ISNULL(DAAmount,0) FROM dbo.tbl_TADAMarketRulesConfig WHERE TourType=@TourTypeId AND UserRoleID=@RoleTypeId
		AND IsActive=1
		end

		if(ISNULL(@MarketIdM,0)>0)
	begin
	declare @TpActiveCount int=0 
	select @TpActiveCount =isnull(count(*),0) from tbl_TourPlanPurpose  where TPId=@TourPurposeId  and IsActive=1
	if(@TpActiveCount>0)
		begin
		if(@amount>0)
		begin
        INSERT  INTO dbo.tbl_TadaClaimMaster
                ( TadaDate ,
                  Remarks ,
                  EntryBy ,
                  EntryDate ,
                  ApprovalStatus ,
                  EmpInfoId,DAAmount,[GroupId]
      ,[RegionId]
      ,[AreaId]
      ,[TerritoryId]
      ,[SubTerritoryId]
      ,[MarketId],TourTypeId,HotelName,HotelPhone,[GroupName]
           ,[RegionName]
           ,[AreaName]
           ,[TerritoryName]
           ,[SubTerritoryName]
           ,[MarketName],[GroupCode_DA]
           ,[RegionCode_DA]
           ,[AreaCode_DA]
           ,[TerritoryCode_DA]
           ,[SubTerritoryCode_DA]
           ,[MarketCode_DA]
	            )
        VALUES  ( @tadaDate ,
                  @remarks ,
                  @userId ,
                  GETDATE() ,
                  '0' ,
                  @empId,@amount,@GroupIdM, @RegionIdM, @AreaIdM,@TerritoryIdM,@SubTerritoryIdM,@MarketIdM,@TourTypeId,@HotelName,@HotelPhone ,@GroupName 
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

        SET @masterId = SCOPE_IDENTITY()




        INSERT  INTO dbo.tbl_TadaClaimDetails
                ( TadaID, TaAmt, DaAmt )
        VALUES  ( @masterId, 0, @amount )



 
			SELECT SCOPE_IDENTITY()
			SELECT @mainId=SCOPE_IDENTITY()


SELECT @Role=usR.RoleName
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
 WHERE emp.EmpInfoId=@empId

 

--SELECT * FROM dbo.View_webapi_FieldForce
--LEFT JOIN dbo.tblMIOInfo ON 

IF(@Role='MIO')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
END

---DECLARE @Id INT
 

EXECUTE dbo.sp_webapi_SaveTADAAppLog @TADAApprovalId = 0,                         -- int
                                 @Date = @tadaDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @masterId,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'TADA',                             -- nvarchar(max)
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
                                 @EntryDateS = @entrydate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @entrydate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 376                              -- int


--SELECT @mainId
    END
    END
    END

    END    END
    END    

