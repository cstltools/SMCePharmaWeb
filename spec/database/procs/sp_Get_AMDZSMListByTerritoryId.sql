CREATE PROCEDURE [dbo].[sp_Get_AMDZSMListByTerritoryId]
	  @TerritoryId int=0
AS
BEGIN
	
	  select distinct * from (select distinct PM.EmpInfoId, case when ar.IsActive=0 then  pm.EmpMasterCode +' : '+ pm.EmpName +' [Area: '+ar.AreaName +'] (Inactive)'   else
  pm.EmpMasterCode +' : '+ pm.EmpName end + ' [Role:AM]' EmpName   from tblEmpGeneralInfo PM with (nolock)
   inner join tblASMInfo asm  with (nolock) on PM.EmpInfoId=asm.EmployeeId  
      inner join tblArea ar  with (nolock) on ar.AreaId=asm.AreaId 
   inner join tblTerritory tr  with (nolock) on tr.AreaId=ar.AreaId 

   where tr.TerritoryId=@TerritoryId

   union all

   select distinct  PM.EmpInfoId,  case when ar.IsActive=0 then  pm.EmpMasterCode +' : '+ pm.EmpName +' [Area: '+ar.AreaName +'] (Inactive)'   else
  pm.EmpMasterCode +' : '+ pm.EmpName end + ' [Role:DZSM]'   EmpName  from tblEmpGeneralInfo PM with (nolock)
   inner join tblRSMInfo rsm  with (nolock) on PM.EmpInfoId=rsm.EmployeeId  
      inner join tblRegion rz  with (nolock) on rz.RegionId=rsm.RegionId 
      inner join tblArea ar  with (nolock) on ar.RegionId=rz.RegionId 
   inner join tblTerritory tr  with (nolock) on tr.AreaId=ar.AreaId 

   where tr.TerritoryId=@TerritoryId) tbl
END