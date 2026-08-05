CREATE PROCEDURE [dbo].[sp_Get_EmployeeFieldForceInfo_EmpIdMArketInfo]
	-- Add the parameters for the stored procedure here
	@id int,
	@RoleTypeName nvarchar(max)
AS
BEGIN
		 if(@RoleTypeName='MIO')
		 begin
		select distinct top 1  ff.GroupId, ff.RegionId, ff.AreaId, ff.TerritoryId  from View_Webapi_EmployeeFieldForceInfo mas  with (nolock)
		inner join View_webapi_FieldForce ff  with (nolock) on mas.EmpInfoId=ff.MIOEmpId
		 where mas.EmpInfoId=@id

		 end

		else  if(@RoleTypeName='AM')
		 begin
		select distinct top 1  ff.GroupId, ff.RegionId, ff.AreaId, ff.TerritoryId  from View_Webapi_EmployeeFieldForceInfo mas  with (nolock)
		inner join View_webapi_FieldForce ff  with (nolock) on mas.EmpInfoId=ff.ASMEMPId
		 where mas.EmpInfoId=@id

		 end

		 else  if(@RoleTypeName='DZSM')
		 begin
		select distinct top 1  ff.GroupId, ff.RegionId, ff.AreaId, ff.TerritoryId  from View_Webapi_EmployeeFieldForceInfo mas  with (nolock)
		inner join View_webapi_FieldForce ff  with (nolock) on mas.EmpInfoId=ff.RSMEMPId
		 where mas.EmpInfoId=@id

		 end

		else   if(@RoleTypeName='NSM')
		 begin
		select distinct top 1  ff.GroupId, ff.RegionId, ff.AreaId, ff.TerritoryId  from View_Webapi_EmployeeFieldForceInfo mas  with (nolock)
		inner join View_webapi_FieldForce ff  with (nolock) on mas.EmpInfoId=ff.NSMEMPId
		 where mas.EmpInfoId=@id

		 end

		 else    
		 begin
		select distinct top 1  0 GroupId, 0 RegionId,0 AreaId, 0 TerritoryId  from View_Webapi_EmployeeFieldForceInfo mas  with (nolock)
		inner join View_webapi_FieldForce ff  with (nolock) on mas.EmpInfoId=ff.NSMEMPId
		 --where mas.EmpInfoId=@id

		 end

END
