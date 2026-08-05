
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_CheckWhocanSubmitOrder]
	-- Add the parameters for the stored procedure here
	@EmpId INT ,
	@CustomerCode  nvarchar(max) ='' 

AS
BEGIN
  declare @FirstCount int =0
  declare @Msg nvarchar(max) =''


  	declare  @UserType nvarchar(max)=''
  	declare  @UserStatus nvarchar(max)=''

	    SELECT @UserType= uType.RoleType, @UserStatus=usr.UserStatus
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId 
    WHERE usr.EmpInfoId = @empId;



	    	DECLARE  @mioCode nvarchar(max)=''
	SELECT @mioCode=isnull(MIOEmpMastercode,'')  from View_CustomerMaster  with (nolock) where   CustomerCode =@CustomerCode
	


  select  @FirstCount=count(*) from tblOrderPermission where PermittedEmpId=@EmpId and GETDATE () between FrmDate and ToDate


  if(@FirstCount>0) 
  begin
  set @Msg='Allowed'
  end




  if(@Msg<>'Allowed')

  begin
   if(@UserType='MIO')
begin
    SET  @Msg='Allowed'
end

if(@UserType='DZSM')
	begin
	SET  @Msg='Not Allowed'

	end

	
if(@UserType='AM')
	begin

	if(isnull(@mioCode,'')='')
	begin
	 SET  @Msg='Allowed'
	end
	else
	begin
	SET  @Msg='Not Allowed'
	end
	end

    end



	if(@UserStatus='Inactive')
	begin
	SET  @Msg='Not Allowed'

	end

	select @Msg Msg

END


