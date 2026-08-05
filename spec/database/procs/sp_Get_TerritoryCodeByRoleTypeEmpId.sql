CREATE

 PROCEDURE [dbo].[sp_Get_TerritoryCodeByRoleTypeEmpId]
	-- Add the parameters for the stored procedure here

 
	@RoleType nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 
 

 declare @marCo  nvarchar(max) 
 declare @marName  nvarchar(max) 
if(@RoleType='MIO')
begin
select @marCo=Tr.TerritoryCode , @marName=Tr.TerritoryName
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId and M.IsActive=1
							   order by M.MIOId desc

							   
							   if(@marCo is null)
begin 
select @marCo=Tr.TerritoryCode  , @marName=Tr.TerritoryName
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId  
							   order by M.MIOId desc
end


							   end


							   if(@RoleType='AM')
begin
select @marCo=Ar.AreaCode  , @marName=ar.AreaName
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  Ar.isactive=1  and AM.EmployeeId=@EmpId and AM.IsActive=1
							   order by AM.ASMId desc

							   if(@marCo is null)
begin 
select @marCo=Ar.AreaCode  , @marName=ar.AreaName
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  Ar.isactive=1  and AM.EmployeeId=@EmpId  
							   order by AM.ASMId desc
end
							   end

 


 		   if(@RoleType='DZSM')
begin
select @marCo=rg.RegionCode   , @marName=rg.RegionName
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   rg.IsActive=1  and RM.EmployeeId=@EmpId and RM.IsActive=1
							   order by RM.RSMId desc

							     if(@marCo is null)
begin 
select @marCo=rg.RegionCode  , @marName=rg.RegionName
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   rg.IsActive=1  and RM.EmployeeId=@EmpId  
							   order by RM.RSMId desc
end


							   end

							 
if(@RoleType='NSM')
begin
select @marCo=Tr.GroupCode  , @marName=Tr.GroupName
                 FROM    dbo.tblNSMInfo AS M LEFT OUTER JOIN
                              dbo.tbl_Group AS Tr ON M.GroupId = Tr.GroupId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId
							   order by M.NSMId desc
							   end

  
   select @marCo as TerritoryCode, @marName TerritoryName

 end