create view DWSPMasterTerritoryDATA
as

 

select distinct rg.RegionId, ar.AreaId, tr.TerritoryId,  Emp.EmpMasterCode, tr.TerritoryCode ,ISNULL(Emp.EmpName,'Vaccant') EmpName,  dgs.DesigName , ur.RoleName ,0 TargetSetof  
   from tblTerritory tr  with (nolock)
left join tblMIOInfo mio   with (nolock) on tr.TerritoryId=mio.TerritoryId   and mio.IsActive=1 
  
left join tblEmpGeneralInfo Emp   with (nolock)  on Emp.EmpInfoId=mio.EmployeeId 
left join tblDesignation dgs   with (nolock)  on Emp.DesignationId=dgs.DesignationId
left join tblUser us   with (nolock)  on Emp.EmpInfoId=us.EmpInfoId
left join tbl_UserRoleInfo ur   with (nolock)  on ur.UserRoleID=us.UserRoleID

inner  join tblArea ar  with (nolock) on ar.AreaId=tr.AreaId and ar.IsActive=1
left join tblASMInfo am   with (nolock) on ar.AreaId=am.AreaId   and am.IsActive=1 
  
left join tblEmpGeneralInfo EmpAm   with (nolock)  on EmpAm.EmpInfoId=am.EmployeeId 
left join tblDesignation dgsAm   with (nolock)  on EmpAm.DesignationId=dgsAm.DesignationId
left join tblUser usAm   with (nolock)  on EmpAm.EmpInfoId=usAm.EmpInfoId
left join tbl_UserRoleInfo urAm   with (nolock)  on urAm.UserRoleID=usAm.UserRoleID

inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId and rg.IsActive=1

where tr.IsActive=1   

 