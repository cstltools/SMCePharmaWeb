
create PROCEDURE [dbo].[sp_Webapi_Save_ExpenseClaimMasterOlddddddd]
	-- Add the parameters for the stored procedure here
	@typeid INT ,
	@expDate NVARCHAR(max) = NULL,
	@empId int,
	@amount DECIMAL(18,2),
	@remarks NVARCHAR(max) = NULL,
	@isFromApp bit



AS
BEGIN

	DECLARE @RoleCheck NVARCHAR(MAX)
    SELECT distinct @RoleCheck= uType.RoleType
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @empId;

 Declare @TagActive int=0
	
IF(@RoleCheck='MIO')
BEGIN

  
    SELECT distinct @TagActive= ISNULL(TerritoryId,0)  FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE MIOEmpId=@empId
	 
END
IF(@RoleCheck='AM')
BEGIN
SELECT  distinct @TagActive= ISNULL(AreaId,0) FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE ASMEMPId=@empId
END
IF(@RoleCheck='DZSM')
BEGIN
    SELECT  distinct @TagActive= ISNULL(RegionId,0)  FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE RSMEMPId=@empId
END


IF(@RoleCheck='NSM')
BEGIN
    SELECT  distinct @TagActive= ISNULL(GroupId,0)  FROM dbo.View_webapi_FieldForce  with (nolock)  WHERE NSMEMPId=@empId
END


if(@TagActive>0)
begin
BEGIN TRY
    -- Attempt to convert the @expDate variable
    SET @expDate = GETDATE();--CONVERT(DATETIME, @expDate, 106);
    
    -- You can add any further processing here, for example:
    -- INSERT INTO YourTable (YourDateColumn) VALUES (@expDate);
    
  
END TRY
BEGIN CATCH
    SET @expDate =GETDATE()
END CATCH;

	declare @ETActiveCount int=0 
	select @ETActiveCount =isnull(count(*),0) from tbl_ExpenseTypeMaster  where ExpenseTypeId=@typeid  and IsActive=1

	 if(@ETActiveCount>0)
		begin
 if((DATEDIFF(DAY,CONVERT(DATE,getdate()),CONVERT(DATE,GETDATE())))<=7)
	 begin
	IF(NOT EXISTS (SELECT * FROM dbo.tbl_ExpenseClaim WHERE EmpInfoId = @empId AND CONVERT(date,ExpenseDate) = CONVERT(date,@expDate ) and ExpenseTypeId=@typeid  and ApprovalStatus<>'3' )    )
	BEGIN
	declare @entryBy int
	select @entryBy=UserId from tblUser where EmpInfoId=@empId

	--------------------------------------
	   declare @TourTypeIdCount int=0
		  select @TourTypeIdCount=ISNULL(count(*),0) from     dbo.tbl_TourPlanInfo A  with (nolock) 
		   
			INNER JOIN dbo.tbl_TourPlanMaster tpM  with (nolock)  ON tpM.TPMaster = A.TPMaster  where A.EmpInfoId=@empId and CONVERT(date,A.TourPlanDate)=CONVERT(date,@expDate) and tpM.ApprovalStatus='2' and isnull(a.TourTypeId,0)<>1
			print @TourTypeIdCount

			if(@TourTypeIdCount>0)
			begin
	INSERT INTO dbo.tbl_ExpenseClaim
	        ( ExpenseTypeId ,
	          ExpenseDate ,
	          EmpInfoId ,
	          Amount ,
	          Remarks ,
	          EntryBy ,
	          EntryDate ,
	          ApprovalStatus,
			  IsFromApp
	        )
	VALUES  (
	@typeid,
	@expDate,
	@empId,
	@amount,
	@remarks,
	@entryBy,
	GETDATE(),
	'0',
	1
	        )

DECLARE @Id INT
			SELECT SCOPE_IDENTITY()
			SELECT @Id=SCOPE_IDENTITY()


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
 WHERE emp.EmpInfoId=@empId


DECLARE @ToEmpId INT
DECLARE @GroupId INT
DECLARE @RegionId INT
DECLARE @AreaId INT
DECLARE @TerrId INT

DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
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



declare @myDate date
set @myDate =convert(Date,getdate())
EXECUTE dbo.sp_webapi_SaveExpanseAppLog @ExpanseApprovalId = 0,                         -- int
                                 @Date =@myDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @Id,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'ExpanseClaim',                             -- nvarchar(max)
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
                                 @EntryDateS = @expDate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @expDate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 356                              -- int




								 end


								 --------------------
END
END
 END
 END
 END

