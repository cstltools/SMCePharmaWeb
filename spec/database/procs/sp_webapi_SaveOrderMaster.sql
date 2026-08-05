
CREATE PROCEDURE [dbo].[sp_webapi_SaveOrderMaster] --[dbo].[sp_webapi_SaveOrderMaster] 'shaon20','20245','11/25/2020 5:04:16 PM'
    @empId INT,
    --comuitid IS actually comanyId
    @comUnitId INT,
    @CustomerCode NVARCHAR(50),
    @SubmittedDate NVARCHAR(MAX)=null,
    @CollectionDate NVARCHAR(MAX)=null,
    @PaymentDate NVARCHAR(MAX)=null,
	@DeliveryDate  NVARCHAR(MAX)=null,
    @EntryDate DATETIME = NULL,
    @Remarks NVARCHAR(MAX) = NULL,
    @orderType NVARCHAR(50) = NULL,    @PaymentType NVARCHAR(50) = NULL,

	@tpDiscount DECIMAL(18,2) = 0
AS
BEGIN

if(@PaymentType='COD')
begin
set @PaymentDate=null
end

set @SubmittedDate= convert(Date,getdate());
 --set @CollectionDate= convert(Date,getdate());
 --set @DeliveryDate= convert(Date,getdate());


DECLARE @CountDataOrd INT
SELECT @CountDataOrd=COUNT(*) FROM dbo.tblOrder WHERE CustomerCode=@CustomerCode AND CONVERT(DATE,SubmissionDate)=CONVERT(DATE,@SubmittedDate) AND ServerDateTime BETWEEN DATEADD(MINUTE,-5,GETDATE()) AND DATEADD(SECOND,30,GETDATE())

IF(@CountDataOrd=0)
BEGIN

    DECLARE @comUnitCode NVARCHAR(50),@ProgramTypeId INT , @SmcTypeId INT=null ,
            @comunitName NVARCHAR(50),@SMCType NVARCHAR(50),
            @mioCode NVARCHAR(50),
            @mioName NVARCHAR(50),
            @companyId INT,
            @customerName NVARCHAR(50),
            @regionId INT,
            @areaId INT,
            @territoryId INT,
            @marketId INT,
            @subterritory INT,
            @groupId INT,
            @customerMasterId INT,
            @rsmId INT,
            @asmId INT,
            @nsmEmpId INT,
            @mioId INT,
            @userIdMaster INT;

			declare @empmasCode NVARCHAR(max), @EmpName nvarchar(max), @UserType nvarchar(max)

    SELECT @userIdMaster = usr.UserId, @empmasCode=emp.EmpMasterCode, @EmpName=EmpName,@UserType= uType.RoleType
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @empId;


    --SELECT @mioCode = A.EmpMasterCode,
    --       @mioName = A.EmpName,
    --       @mioId = B.EmployeeId
    --FROM dbo.tblEmpGeneralInfo A
    --    INNER JOIN dbo.tblMIOInfo B ON A.EmpInfoId = B.EmployeeId
    --WHERE A.EmpInfoId = @empId;

    DECLARE @IsSubDepo INT, @depId INT, @DistributionRouteId int;
	DECLARE @Tericode nvarchar(max)

    --SET @comUnitCode = 'BD33' 
    --SET @comunitName = 'Dhaka Distribution Center' 

    SET @companyId = 1
    --SET @depId = 12


	declare @GroupCode_ord nvarchar(max),@RegionCode_ord nvarchar(max),@AreaCode_ord nvarchar(max),@TerritoryCode_ord nvarchar(max), @SAPTerritoryCode_Ord nvarchar(max),@SubTerritoryCode_ord nvarchar(max),@MarketCode_ord nvarchar(max),@GroupName_ord nvarchar(max),@RegionName_ord nvarchar(max),@AreaName_ord nvarchar(max),@TerritoryName_ord nvarchar(max),@SubTerritoryName_ord nvarchar(max),@MarketName_ord nvarchar(max),@RouteName_ord nvarchar(max)
	


    SELECT @SAPTerritoryCode_Ord=terry.SAP_code, @RouteName_ord=RMas.RouteName ,  @SMCType=smcT.SMCType, @SmcTypeId= ISNULL(CSTMR.SmcTypeId,NULL), @ProgramTypeId=ProgramTypeId, @DistributionRouteId=RMas.RouteInformationMasterId, @Tericode=terry.TerritoryCode, @marketId = CSTMR.MarketId,
           @subterritory = tr.SubTerritoryId,
           @territoryId = terry.TerritoryId,
           @areaId = ar.AreaId,
           @regionId = rg.RegionId,
           @groupId = gp.GroupId,@GroupName_ord=gp.GroupName, @RegionName_ord=rg.RegionName, @AreaName_ord=Ar.AreaName,@TerritoryName_ord=terry.TerritoryName ,@SubTerritoryName_ord=tr.SubTerritoryName, @MarketName_ord=MKT.MarketName,@GroupCode_ord=gp.GroupCode, @RegionCode_ord=rg.RegionCode, @AreaCode_ord=Ar.AreaCode,@TerritoryCode_ord=terry.TerritoryCode ,@SubTerritoryCode_ord=tr.SubTerritoryCode , @MarketCode_ord=MKT.MarketCode
    FROM tblCustMaster AS CSTMR   with (nolock)
        INNER JOIN dbo.tblMarket AS MKT   with (nolock) ON CSTMR.MarketId = MKT.MarketId
        INNER JOIN dbo.tblSubTerritory tr   with (nolock) ON tr.SubTerritoryId = MKT.SubTerritoryId
        INNER JOIN dbo.tblTerritory terry   with (nolock) ON terry.TerritoryId = tr.TerritoryId
        INNER JOIN dbo.tblArea ar   with (nolock) ON ar.AreaId = terry.AreaId
        INNER JOIN dbo.tblRegion rg    with (nolock)ON rg.RegionId = ar.RegionId
        INNER JOIN dbo.tbl_Group gp   with (nolock) ON gp.GroupId = rg.GroupId

        left JOIN dbo.tblRouteInformationMarketDetail rDtl   with (nolock) ON rDtl.MarketId = CSTMR.MarketId
        left JOIN dbo.tblRouteInformationMaster RMas   with (nolock) ON RMas.RouteInformationMasterId = rDtl.RouteInformationMasterId

		 left JOIN dbo.tblSMCType smcT   with (nolock) ON smcT.SmcTypeId = CSTMR.SmcTypeId
		   




		WHERE CSTMR.CustomerCode = @CustomerCode



		--@comUnitCode=comUnitCode, @comunitName=comunitName, @depId=ComUnitId ,

		  select @IsSubDepo=masR.IsSubDepo, @depId=  masR.DCId, @comunitName=cunit.ComUnitName,@comUnitCode=cunit.ComUnitCode from tblRouteInformationMaster masR with (nolock)
inner join tblRouteInformationMarketDetail dtl with (nolock) on masR.RouteInformationMasterId=dtl.RouteInformationMasterId
inner join tblCompanyUnit cunit  with (nolock) on masR.DCId=cunit.ComUnitId

where dtl.MarketId=@marketId


    SELECT  @customerMasterId = CustomerMasterId,
           @customerName = CustomerName
    FROM dbo.tblCustMaster
    WHERE CustomerCode = @CustomerCode;

		DECLARE @rsmEmpID INT,@asmEmpID int,@SAP_MIOCode nvarchar(max),@AMSAPCode_Ord nvarchar(max),@DZSMSAPCode_Ord nvarchar(max)
	SELECT @mioCode=MIOEmpMastercode, @mioName=MIOEmpName, @mioId=MIOEmpInfoId, @rsmEmpID=RSMEmpInfoId,@asmEmpID=ASMEmpInfoId, @rsmId=RSMEmpInfoId,@asmEmpID=ASMEmpInfoId, @nsmEmpId=NSMEmpInfoId ,@SAP_MIOCode= SAP_MIOCode, @AMSAPCode_Ord=ASMSapCode  ,@DZSMSAPCode_Ord=DZSMSapCode from View_CustomerMaster  with (nolock) where   CustomerCode =@CustomerCode
	
	 
	  





    DECLARE @orderNumber INT,
            @orderCode NVARCHAR(500);

    DECLARE @yearText NVARCHAR(MAX) = SUBSTRING(CONVERT(NVARCHAR(MAX), YEAR(@SubmittedDate)), 3, 3);
    DECLARE @monthText NVARCHAR(MAX) = (CASE
                                            WHEN LEN(MONTH(@SubmittedDate)) = 1 THEN
                                                '0' + CONVERT(NVARCHAR(MAX), MONTH(@SubmittedDate))
                                            ELSE
                                                CONVERT(NVARCHAR(MAX), MONTH(@SubmittedDate))
                                        END
                                       );
    DECLARE @dateText NVARCHAR(MAX) = (CASE
                                           WHEN LEN(DAY(@SubmittedDate)) = 1 THEN
                                               '0' + CONVERT(NVARCHAR(MAX), DAY(@SubmittedDate))
                                           ELSE
                                               CONVERT(NVARCHAR(MAX), DAY(@SubmittedDate))
                                       END
                                      );


    SELECT @orderCode
        = N'ODR-' + (@yearText + @monthText + @dateText)
          + CONVERT(NVARCHAR(MAX), CONVERT(INT, ISNULL(MAX(SUBSTRING(OrderCode, 11, 6)), 10000)) + 1)
    FROM tblOrder  with (nolock) 
    WHERE SubmissionDate = @SubmittedDate;


	SET @orderType='Regular'

	DECLARE @CustTypeId INT
	SELECT @CustTypeId=CustomerTypeId FROM dbo.tblCustMaster  with (nolock)  WHERE CustomerMasterId=@customerMasterId
	DECLARE @IsSpec BIT
    IF(@CustTypeId='3')
	BEGIN
	    SET @IsSpec=1
	END
	ELSE
    BEGIN
        SET @IsSpec=0
    END


    INSERT INTO dbo.tblOrder
    (
        OrderCode,
        ComUnitId,
        ComUnitCode,
        ComUnitName,
        MIOCode,
        MIOName,
        ManufacId,
        CustomerCode,
        CustomerName,
        SubmissionDate,
        RegionId,
        AreaId,
        TerritoryId,
        MarketId,
        CustomerMasterId,
        RSMId,
        ASMId,
        MIOId,
        EntryBy,
        EntryDate,
        IsInvoice,
        IsManual,
        IsSpecialApproval,
        ActionStatus,
        IsFromApp,
        Remarks,
        OrderType,
        TerritoryCode,
        IsSpDis,
        CustomerType,
        FixedCustomer,
		GroupId,SubTerritoryId,RsmEmpId,AsmEmpId,TPDiscount,ServerDateTime,DistributionRouteId, OrderSenderCode, OrderSenderName,OrderSenderType, NSMId,CustTypeId,ProgramTypeId,
		DeliveryDate, IsSubDepo,[GroupName_Ord]
           ,[RegionName_Ord]
           ,[AreaName_Ord]
           ,[TerritoryName_Ord]
           ,[SubTerritoryName_Ord]
           ,[MarketName_Ord]
           ,[GroupCode_Ord]
           ,[RegionCode_Ord]
           ,[AreaCode_Ord]
           ,[TerritoryCode_Ord]
           ,[SubTerritoryCode_Ord]
           ,[MarketCode_Ord], SmcTypeId_Ord, SMCType_Ord, DistributionRoute_ord,MIOSAPCode_Ord, AMSAPCode_Ord,DZSMSAPCode_Ord,SAPTerritoryCode_Ord,IsPrepareforInvoice,PaymentType,PaymentDate_ord,OrDRouteTerritoryId
    )
    VALUES
    (@orderCode, @depId, @comUnitCode, @comunitName, @mioCode, @mioName, @companyId, @CustomerCode, @customerName,
     @SubmittedDate, @regionId, @areaId, @territoryId, @marketId, @customerMasterId, @rsmEmpID, @asmEmpID, @mioId,
     @userIdMaster, @EntryDate, 0, 0, 0, '2', 1, @Remarks, @orderType, @Tericode, @IsSpec, 'Default', 0,
	 @groupId,@subterritory,null,null,@tpDiscount, GETDATE(),@DistributionRouteId,@empmasCode, @EmpName,@UserType,@nsmEmpId,@CustTypeId,@ProgramTypeId,@DeliveryDate,@IsSubDepo,@GroupName_Ord 
           ,@RegionName_Ord 
           ,@AreaName_Ord 
           ,@TerritoryName_Ord 
           ,@SubTerritoryName_Ord 
           ,@MarketName_Ord 
           ,@GroupCode_Ord 
           ,@RegionCode_Ord 
           ,@AreaCode_Ord 
           ,@TerritoryCode_Ord 
           ,@SubTerritoryCode_Ord 
           ,@MarketCode_Ord,  @SmcTypeId, @SMCType, @RouteName_ord,@SAP_MIOCode, @AMSAPCode_Ord,@DZSMSAPCode_Ord,@SAPTerritoryCode_Ord,1,@PaymentType,@PaymentDate,@territoryId );


    --SELECT SCOPE_IDENTITY();

					DECLARE @Id INT
        SELECT  @Id=SCOPE_IDENTITY()


	SET @orderCode
        = N'ODR-' + (@yearText + @monthText + @dateText)
          + CONVERT(NVARCHAR(MAX), @Id)

		UPDATE dbo.tblOrder SET OrderCode=@orderCode WHERE OrderId=@Id
   

DECLARE @IsOrd BIT=0
SELECT @IsOrd=ISNULL(IsOrderApproval,0) FROM dbo.tblCustomerType   with (nolock) 
INNER JOIN dbo.tblCustMaster  with (nolock)  ON tblCustMaster.CustomerTypeId = tblCustomerType.CustomerTypeId
WHERE CustomerMasterId=@customerMasterId
DECLARE @ActionStat NVARCHAR(MAX)='Posted'
IF(@IsOrd=0)
BEGIN
    SET @ActionStat='Accepted'
END
ELSE
BEGIN
    SET @ActionStat='Posted'
END
if(@Remarks='DICTAG')
	BEGIN
    SET @ActionStat='Accepted'
END	 

DECLARE @EmpInfoId INT=@empId
DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName,@EmpInfoId=emp.EmpInfoId
FROM dbo.tblEmpGeneralInfo  emp  with (nolock) 
left join  tblUser us  with (nolock)  on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR  with (nolock)  on usR.UserRoleID=us.UserRoleID
 
 WHERE us.EmpInfoId=@empId


DECLARE @ToEmpId1 INT
DECLARE @GroupId1 INT
DECLARE @RegionId1 INT
DECLARE @AreaId1 INT
DECLARE @TerrId1 INT

DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
--SELECT * FROM dbo.View_webapi_FieldForce
--LEFT JOIN dbo.tblMIOInfo ON 

IF(@Role='MIO')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE MIOEmpId=@EmpInfoId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE ASMEMPId=@EmpInfoId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE RSMEMPId=@EmpInfoId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE NSMEMPId=@EmpInfoId
END

PRINT 'entrydate-'+CONVERT(NVARCHAR(MAX),@EntryDate)
PRINT ' empid- '+CONVERT(NVARCHAR(MAX),@EmpInfoId)
PRINT ' empid- '+CONVERT(NVARCHAR(MAX),@Id)
PRINT ' GATR-'+CONVERT(NVARCHAR(MAX
),@GroupId1)+CONVERT(NVARCHAR(MAX),@RegionId1)+CONVERT(NVARCHAR(MAX),@TerrId1)+CONVERT(NVARCHAR(MAX),@AreaId1)
--declare @entrydate datetime=getdate()
	
EXECUTE dbo.sp_webapi_SaveOrderAppLog @OrderApprovalId = 0,                         -- int
                                 @Date = @entrydate,           -- datetime
                                 @FromEmpId = @EmpInfoId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = @ActionStat,                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Order',                             -- nvarchar(max)
                                 @Step = 1,                               -- int
                                 @GroupId = @GroupId1,                            -- int
                                 @RegionId = @RegionId1,                           -- int
                                 @AreaId = @AreaId1,                             -- int
                                 @TerritoryId = @TerrId1,                        -- int
                                 @ToGroupId = 0,                          -- int
                                 @ToRegionId = 0,                         -- int
                                 @ToAreaId = 0,                           -- int
                                 @ToTerritoryId = 0,                      -- int
                                 @EntryByS = @EmpInfoId,                         -- nvarchar(max)
                                 @EntryDateS = @entrydate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @EmpInfoId,                       -- nvarchar(max)
                                 @EntryDateApp = @entrydate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 377                          -- int


    SELECT  @Id
END

END;