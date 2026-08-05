-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_DoctorFinalSubmit]
	-- Add the parameters for the stored procedure here
    @empId INT = NULL ,
    @month INT = NULL ,
    @year INT = NULL ,
    @remarks NVARCHAR(MAX) = NULL
AS
    BEGIN
        UPDATE  dbo.tbl_DoctorTourPlanMaster
        SET     IsFinalSubmit = 1 ,
                FinalSubmitRemarks = @remarks ,
                ApprovalStatus = '0'
        WHERE   EmpInfoId = @empId
                AND MonthValue = @month
                AND YearValue = @year

					DECLARE @MasterId INT=0
			SELECT @MasterId=DocTPMaster FROM dbo.tbl_DoctorTourPlanMaster WHERE EmpInfoId = @empId AND MonthValue = @month AND YearValue = @year
				 
		 


DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName, @empId=emp.EmpInfoId
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
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
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT @GroupId1=GroupId,@AreaId1=AreaId,@TerrId1=TerritoryId,@RegionId1=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
END

DECLARE @EDate DATETIME=GETDATE()
	
EXECUTE dbo.sp_webapi_SaveVisitPlanAppLog @VisitPlanApprovalId = 0,                         -- int
                                 @Date = @EDate,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @MasterId,                            -- int
                                 @Status = N'0',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'TourPlan',                             -- nvarchar(max)
                                 @Step = 1,                               -- int
                                 @GroupId = @GroupId1,                            -- int
                                 @RegionId = @RegionId1,                           -- int
                                 @AreaId = @AreaId1,                             -- int
                                 @TerritoryId = @TerrId1,                        -- int
                                 @ToGroupId = 0,                          -- int
                                 @ToRegionId = 0,                         -- int
                                 @ToAreaId = 0,                           -- int
                                 @ToTerritoryId = 0,                      -- int
                                 @EntryByS = @empId,                         -- nvarchar(max)
                                 @EntryDateS = @EDate,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @EDate,   -- datetime
                                 @EntryTimeApp = @EntryTime,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 377                           -- int



    END

