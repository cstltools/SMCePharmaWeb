-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Get_DCRReportNew]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
 
    DECLARE @Query NVARCHAR(MAX)

 SET @Query = '
select distinct PM.EmpMasterCode, PM.EmpName, usR.RoleName,PM.EmpInfoId,dgs.DesigName, FORMAT(tblDrTarget.TourPlanDate,''dd-MMM-yyyy'') TourPlanDate , tblDrTarget.TerritoryName_DV, tblDrTarget.AreaName_DV,tblDrTarget.RegionName_DV,  com.CompanyName, 0 PharmachyTarget, 0 as PharmachyVisit, ISNULL(tblDrTarget.DoctorTarget,0) DoctorTarget , ISNULL(tblDCR.DCRTarget,0)  DCRTarget  from tblEmpGeneralInfo PM with (nolock)
left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId 
   left join tblDesignation dgs  with (nolock) on PM.DesignationId=dgs.DesignationId
   left join tbl_UserRoleInfo usR  with (nolock) on usR.UserRoleId=us.UserRoleId
   left join tblRoleType usRT  with (nolock) on usR.RoleTypeId=usRT.RoleTypeId
   inner join (select    COUNT(distinct DoctorId) DoctorTarget,  TourPlanDate, EmpInfoId, CompanyId, TerritoryName_DV, AreaName_DV,RegionName_DV  from tbl_DoctorTourPlanDetail  group by TourPlanDate, EmpInfoId ,CompanyId, TerritoryName_DV, AreaName_DV,RegionName_DV) tblDrTarget on tblDrTarget.EmpInfoId=PM.EmpInfoId

    left join (select   COUNT(distinct dcr.DoctorId) DCRTarget,  dcr.DcrDate, u.EmpInfoId  from tbl_DCRInfo  dcr
	inner join tblUser u on dcr.EntryBy=u.UserId
	 group by dcr.DcrDate, u.EmpInfoId) tblDCR on tblDCR.EmpInfoId=PM.EmpInfoId  and CONVERT(Date,tblDrTarget.TourPlanDate)=CONVERT(Date,tblDCR.DcrDate)

	 left join tblCompanyInfo com on com.CompanyId=tblDrTarget.CompanyId

	 where convert(Date,tblDrTarget.TourPlanDate) is not null
'+  @param +'  order by convert(Date,tblDrTarget.TourPlanDate) desc'
 
END

EXEC (@Query)
