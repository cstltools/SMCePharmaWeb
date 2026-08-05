

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_UserInfo]
	-- Add the parameters for the stored procedure here
	  @UserId  INT ,
	  --@UserName  nvarchar(max) =null,
	  @LoginName  nvarchar(max) =null ,
	  @EmpInfoId  int =null 

	   
AS
BEGIN
		 
	--SELECT * FROM dbo.tblUser WHERE UserName=@UserName AND  UserId NOT IN ( @UserId)

 	SELECT * FROM dbo.tblUser WHERE  LoginName=@LoginName AND  UserId NOT IN ( @UserId)


union all	SELECT * FROM dbo.tblUser WHERE   EmpInfoId=@EmpInfoId AND EmpInfoId is not null and  UserId NOT IN ( @UserId)



END



