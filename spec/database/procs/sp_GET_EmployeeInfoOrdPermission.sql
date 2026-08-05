
CREATE PROCEDURE [dbo].[sp_GET_EmployeeInfoOrdPermission]
	-- Add the parameters for the stored procedure here
		@Parm nvarchar(max)  

AS
BEGIN
 DECLARE @Q NVARCHAR(MAX)
 

  set @Q  ='select tr.TerritoryId, ar.RegionId,  ar.AreaId, tr.TerritoryCode,  PM.EmpInfoId,  ar.AreaCode + '' : '' +ar.AreaName AreaName, tr.TerritoryCode+ '' : '' +tr.TerritoryName TerritoryName, pm.EmpMasterCode, pm.EmpName, isnull(ordp.PermittedEmpId,0) PermittedEmpId, format(ordp.FrmDate,''yyyy-MM-dd HH:mm:ss'')  FrmDate,format( ordp.ToDate,''yyyy-MM-dd HH:mm:ss'')   ToDate    from tblTerritory tr  with (nolock)

 
   left join tblMIOInfo mio  with (nolock) on tr.TerritoryId=mio.TerritoryId and mio.IsActive=1
     left join tblEmpGeneralInfo PM  with (nolock) on PM.EmpInfoId=mio.EmployeeId  
   left join tblArea ar  with (nolock) on tr.AreaId=ar.AreaId and ar.IsActive=1
   left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
   left join tbl_UserRoleInfo usR  with (nolock) on usR.UserRoleId=us.UserRoleId
   left join tblRoleType usRT  with (nolock) on usR.RoleTypeId=usRT.RoleTypeId
   left join tblOrderPermission ordp   with (nolock) on ordp.TerritoryId=tr.TerritoryId
   where  tr.IsActive=1 ' +@Parm+'  order by tr.TerritoryCode asc'
 
  

						
EXEC sp_executesql @Q


END
