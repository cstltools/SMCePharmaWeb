CREATE PROCEDURE [dbo].[sp_Webapi_Get_DICcheck]
	-- Add the parameters for the stored procedure here
	 @EmployeeId NVARCHAR(MAX)= NULL
	AS
    BEGIN
  

 
 
  declare @UserType nvarchar(max)
  declare @NewEmpId nvarchar(max)


	select  @UserType= usrT.RoleType from tbluser us
	inner join tbl_UserRoleInfo usr ON usr.UserRoleID=us.UserRoleID
	inner join tblRoleType usrT ON usr.RoleTypeId=usrT.RoleTypeId

	 where EmpInfoId=@EmployeeId

	 print @UserType

	  if(@UserType='DZSM')
	  begin
	  select @NewEmpId= max(CustomerApprovalId)+1 from tblCustomerApprovalLog 
	  end


	  select @UserType   UserType,@NewEmpId  NewEmpId
	end