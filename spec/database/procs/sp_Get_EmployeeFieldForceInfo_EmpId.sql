CREATE PROCEDURE [dbo].[sp_Get_EmployeeFieldForceInfo_EmpId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
		 
		select  MIOEmpId, ASMEMPId, RSMEMPId,NSMEMPId, EmpGroupId,EmpRegionId,  EmpAreaId,  EmpTerrId  from View_Webapi_EmployeeFieldForceInfo with (nolock) where EmpInfoId=@id

END
