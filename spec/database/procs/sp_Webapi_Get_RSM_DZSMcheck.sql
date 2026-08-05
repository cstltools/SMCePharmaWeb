CREATE PROCEDURE [dbo].[sp_Webapi_Get_RSM_DZSMcheck]
	-- Add the parameters for the stored procedure here
	 @EmployeeId NVARCHAR(MAX)= NULL
	AS
    BEGIN
  

 
 

 declare @RoleTypeId int 
 declare @ASMEMPId int 

 declare @RSMEMPId int 

	select @RoleTypeId= usr.RoleTypeId from tbluser us
	inner join tbl_UserRoleInfo usr ON usr.UserRoleID=us.UserRoleID
	 where EmpInfoId=@EmployeeId

	 
	SELECT distinct @ASMEMPId= ASMEMPId,@RSMEMPId= RSMEMPId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@EmployeeId
	 

	if(@ASMEMPId=@RSMEMPId )
	 begin
	  select @ASMEMPId  ASMEMPId, @RSMEMPId RSMEMPId
	 end
	 else 
	  begin
	 select  'nai' ASMEMPId,'nai' RSMEMPId
	 end
	 

	end