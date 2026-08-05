CREATE PROCEDURE [dbo].[sp_webapi_SaveOrderMaster_Doctor] --[dbo].[sp_webapi_SaveOrderMaster] 'shaon20','20245','11/25/2020 5:04:16 PM'
    @empId INT,
    @DoctorId INT,

  
    
    @SubmittedDate DATETIME,
    @CollectionDate DATETIME,
    @EntryDate DATETIME = NULL,
    @Remarks NVARCHAR(MAX) = NULL 
AS
BEGIN

    DECLARE @comUnitCode NVARCHAR(50),
            @comunitName NVARCHAR(50),
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
    FROM dbo.tblUser usr
	 INNER JOIN dbo.tblEmpGeneralInfo emp ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @empId;


    --SELECT @mioCode = A.EmpMasterCode,
    --       @mioName = A.EmpName,
    --       @mioId = B.EmployeeId
    --FROM dbo.tblEmpGeneralInfo A
    --    INNER JOIN dbo.tblMIOInfo B ON A.EmpInfoId = B.EmployeeId
    --WHERE A.EmpInfoId = @empId;

    DECLARE @depId INT, @DistributionRouteId INT, @MIOEmpId int;
	DECLARE @Tericode nvarchar(max)

    --SET @comUnitCode = 'BD33' 
    --SET @comunitName = 'Dhaka Distribution Center' 

     
    --SET @depId = 12



	
 
		DECLARE @rsmEmpID INT,@asmEmpID int
	SELECT @groupId=GroupId ,@regionId=RegionId,@areaId=AreaId,@territoryId=TerritoryId,@MIOEmpId=MIOEmpId, @ASMEMPId=ASMEMPId, @RSMEMPId=RSMEMPId, @NSMEMPId=NSMEMPId from View_Webapi_EmployeeFieldForceInfo where   dbo.View_Webapi_EmployeeFieldForceInfo.EmpInfoId =@empId

	SELECT @companyId= comu.ComUnitId, @comunitName= comu.ComUnitName,@comUnitCode= comu.ComUnitCode FROM dbo.tblDcWiseTerritoryDetail  dtl
	INNER JOIN dbo.tblDcWiseTerritoryMaster mas ON mas.DcWiseTerritoryMasterId = dtl.DcWiseTerritoryMasterId
	INNER JOIN dbo.tblCompanyUnit comu ON mas.DCId = comu.ComUnitId
    
	WHERE dtl.TerritoryId=@territoryId
	
	 
	  





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
    FROM tblOrder
    WHERE SubmissionDate = @SubmittedDate;

	 


    INSERT INTO dbo.tblOrder_Doctorrequirement
    (
        OrderCode,
        ComUnitId,
        ComUnitCode,
        ComUnitName,
        MIOCode,
        MIOName,
        ManufacId,
       
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
		GroupId,SubTerritoryId,RsmEmpId,AsmEmpId,TPDiscount,ServerDateTime,DistributionRouteId, OrderSenderCode, OrderSenderName,OrderSenderType, NSMId,DoctorId
    )
    VALUES
    (@orderCode, @companyId, @comUnitCode, @comunitName, @mioCode, @mioName, @companyId, 
     @SubmittedDate, @regionId, @areaId, @territoryId, @marketId, @customerMasterId, @rsmEmpID, @asmEmpID, @mioId,
     @userIdMaster, @EntryDate, 0, 0, 0, 'Accepted', 1, @Remarks, 'Sample', @Tericode, 0, 'Default', 0,
	 @groupId,@subterritory,null,null,0, GETDATE(),@DistributionRouteId,@empmasCode, @EmpName,@UserType,@nsmEmpId,@DoctorId );


    --SELECT SCOPE_IDENTITY();

					DECLARE @Id INT
        SELECT  @Id=SCOPE_IDENTITY()

		


		 


--DECLARE @Role NVARCHAR(MAX)
--SELECT @Role=usR.RoleName
--FROM dbo.tblEmpGeneralInfo  emp
--left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
--left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
-- WHERE us.EmpInfoId=@empId


--DECLARE @ToEmpId1 INT
--DECLARE @GroupId1 INT
--DECLARE @RegionId1 INT
--DECLARE @AreaId1 INT
--DECLARE @TerrId1 INT

--DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
----SELECT * FROM dbo.View_webapi_FieldForce
----LEFT JOIN dbo.tblMIOInfo ON 

--IF(@Role='MIO')
--BEGIN
--    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
--END
--IF(@Role='ASM')
--BEGIN
--SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
--END
--IF(@Role='RSM')
--BEGIN
--    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
--END
--IF(@Role='NSM')
--BEGIN
--    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
--END

----declare @entrydate datetime=getdate()
	
--EXECUTE dbo.sp_webapi_SaveOrderAppLog @OrderApprovalId = 0,                         -- int
--                                 @Date = @entrydate,           -- datetime
--                                 @FromEmpId = @empId,                          -- int
--                                 @ToEmpId = 0,                            -- int
--                                 @TableId = @Id,                            -- int
--                                 @Status = N'Posted',                           -- nvarchar(max)
--                                 @Comments = N'',                         -- nvarchar(max)
--                                 @Type = N'Customer',                             -- nvarchar(max)
--                                 @Step = 1,                               -- int
--                                 @GroupId = @GroupId1,                            -- int
--                                 @RegionId = @RegionId1,                           -- int
--                                 @AreaId = @AreaId1,                             -- int
--                                 @TerritoryId = @TerrId1,                        -- int
--                                 @ToGroupId = 0,                          -- int
--                                 @ToRegionId = 0,                         -- int
--                                 @ToAreaId = 0,                           -- int
--                                 @ToTerritoryId = 0,                      -- int
--                                 @EntryByS = @empId,                         -- nvarchar(max)
--                                 @EntryDateS = @entrydate,     -- datetime
--                                 @EntryTimeS = @EntryTime,                -- time(7)
--                                 @ApproveByS = NULL,                       -- nvarchar(max)
--                                 @ApproveDateS = NULL,   -- datetime
--                                 @ApproveTimeS = NULL,              -- time(7)
--                                 @EntryByApp = @empId,                       -- nvarchar(max)
--                                 @EntryDateApp = @entrydate,   -- datetime
--                                 @EntryTimeApp = @EntryTime,              -- time(7)
--                                 @ApproveByApp = NULL,                     -- nvarchar(max)
--                                 @ApproveDateApp = NULL, -- datetime
--                                 @ApproveTimeApp = NULL,            -- time(7)
--                                 @MenuId = 302                          -- int


    SELECT  @Id

END;