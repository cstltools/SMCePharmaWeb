
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_EmployeeInformationList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   Select distinct PM.EmployeeStatus, PM.EmpMasterCode, PM.EmpName, fs.RegionCode+ ' : ' +fs.RegionName RegionName,  fs.AreaCode+ ' : ' +fs.AreaName AreaName,  fs.TerritoryCode+ ' : ' +fs.TerritoryName TerritoryName, dgs.DesigName, PM.CellNumber PhoneNo,format( PM.JoiningDate,'dd MMMM,yyyy')  JoiningDate ,usRT.RoleType, usR.RoleName, PM.EmpInfoId,CONVERT(NVARCHAR(50),PM.DateOfBirth,106)AS EmpDateOfBirth  from tblEmpGeneralInfo PM with (nolock)
   left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
   

   left join tblDesignation dgs  with (nolock) on PM.DesignationId=dgs.DesignationId
   left join tbl_UserRoleInfo usR  with (nolock) on usR.UserRoleId=us.UserRoleId
   left join tblRoleType usRT  with (nolock) on usR.RoleTypeId=usRT.RoleTypeId

   left join View_Webapi_EmployeeFieldForceInfo fs  with (nolock) on fs.EmpInfoId=PM.EmpInfoId

  
 -- left join   (select 'MIO' rType, mio.EmployeeId ,mio.TerritoryId  from tblMioInfo mio
 --where mio.isactive=1
 --  ) tblMIO on usRT.RoleType=tblMIO.rType and tblMIO.EmployeeId=PM.EmpInfoId
    
 --    left join   (select 'AM' rType, mio.EmployeeId ,mio.AreaId  from tblASMInfo mio
 -- where mio.isactive=1
 --  ) tblAM on usRT.RoleType=tblAM.rType and tblAM.EmployeeId=PM.EmpInfoId

 --  left join   (select 'DZSM' rType, mio.EmployeeId ,mio.RegionId  from tblRSMInfo mio
 -- where mio.isactive=1
 --  ) tblDZSM on usRT.RoleType=tblDZSM.rType and tblDZSM.EmployeeId=PM.EmpInfoId


 --   left join   (select 'NSM' rType, mio.EmployeeId ,mio.GroupId  from tblNSMInfo mio
 -- where mio.isactive=1
 --  ) tblNSM on usRT.RoleType=tblNSM.rType and tblNSM.EmployeeId=PM.EmpInfoId

 order by PM.EmpMasterCode asc
END

