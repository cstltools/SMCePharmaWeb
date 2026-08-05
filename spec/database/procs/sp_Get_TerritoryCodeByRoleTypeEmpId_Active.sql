create

 PROCEDURE [dbo].[sp_Get_TerritoryCodeByRoleTypeEmpId_Active]
	-- Add the parameters for the stored procedure here

 
	@RoleType nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 
 

 declare @marCo  nvarchar(max) 
if(@RoleType='MIO')
begin
select @marCo=Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId and M.IsActive=1
							   order by M.MIOId desc
							   end


							   if(@RoleType='AM')
begin
select @marCo=Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  Ar.isactive=1  and AM.EmployeeId=@EmpId  and AM.IsActive=1
							   order by AM.ASMId desc
							   end

 


 		   if(@RoleType='DZSM')
begin
select @marCo=rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   rg.IsActive=1  and RM.EmployeeId=@EmpId  and RM.IsActive=1
							   order by RM.RSMId desc
							   end

							 
if(@RoleType='NSM')
begin
select @marCo=Tr.GroupCode 
                 FROM    dbo.tblNSMInfo AS M LEFT OUTER JOIN
                              dbo.tbl_Group AS Tr ON M.GroupId = Tr.GroupId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId  and M.IsActive=1
							   order by M.NSMId desc
							   end

  
   select @marCo as TerritoryCode

 end