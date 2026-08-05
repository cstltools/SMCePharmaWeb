CREATE PROCEDURE [dbo].[sp_HigharchyInfoByEmployeeId]
	-- Add the parameters for the stored procedure here
    @EmployeeId  INT ,
    @RoleId  INT 


AS
    BEGIN

	if(@RoleId=1)
	begin
select rg.GroupId, rg.RegionId,ar.AreaId,tr.TerritoryId from View_Webapi_EmployeeFieldForceInfo mas with (nolock)
	inner join tblTerritory tr  with (nolock) on mas.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		inner join dbo.tbl_Group gr  with (nolock) on gr.GroupId=gr.GroupId

where mas.EmpInfoId=@EmployeeId  
end


else if(@RoleId=2)
	begin
select rg.GroupId, rg.RegionId,ar.AreaId  from View_Webapi_EmployeeFieldForceInfo mas with (nolock)
	 
		inner join tblArea ar   with (nolock)  on ar.AreaId=mas.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		inner join dbo.tbl_Group gr  with (nolock) on gr.GroupId=rg.GroupId
		where mas.EmpInfoId=@EmployeeId  
end



else if(@RoleId=3)
	begin

	
select rg.GroupId, rg.RegionId   from View_Webapi_EmployeeFieldForceInfo mas with (nolock)
	 
	 inner join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		inner join dbo.tbl_Group gr  with (nolock) on gr.GroupId=rg.GroupId
		where mas.EmpInfoId=@EmployeeId  
end


else if(@RoleId=4)
	begin

	IF @EmployeeId = 683
    BEGIN
        SELECT 2 AS GroupId; -- If EmpInfoId = 683, return 2 as GroupId
    END
    ELSE
    BEGIN
        SELECT gr.GroupId 
        FROM View_Webapi_EmployeeFieldForceInfo mas WITH (NOLOCK)
        INNER JOIN dbo.tbl_Group gr WITH (NOLOCK) ON gr.GroupId = mas.GroupId
        WHERE mas.EmpInfoId = @EmployeeId;
    END
--select gr.GroupId    from View_Webapi_EmployeeFieldForceInfo mas with (nolock)
	 
--	 	inner join dbo.tbl_Group gr  with (nolock) on gr.GroupId=mas.GroupId
--		where mas.EmpInfoId=@EmployeeId  
end


else

	begin

	
select top 1 0 GroupId    from View_Webapi_EmployeeFieldForceInfo mas with (nolock)
	 
	 	 
end
end