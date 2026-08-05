
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_TourSetupEmployeeList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
 select emp.EmpMasterCode +'' : ''+ emp.EmpName EmpName , st.StationTypeName, Rt.RoleType,* from tblTourSetupEmployee  TSE  with (nolock)
left join tblEmpGeneralInfo emp   with (nolock) on TSE.EmpInfoId=emp.EmpInfoId
left join tblStationType st   with (nolock) on st.StationTypeId=TSE.StationTypeId
left join tblRoleType Rt   with (nolock) on Rt.RoleTypeId=TSE.RoleTypeId
where TSE.TourSetupEmployeeId is not null
  '+@Parm  


EXEC sp_executesql @Q
	
END