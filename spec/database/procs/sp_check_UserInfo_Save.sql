

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_UserInfo_Save]
	-- Add the parameters for the stored procedure here
	  @UserId  INT ,
	  --@UserName  nvarchar(max) =null,
	  @LoginName  nvarchar(max) =null ,
	  @EmpInfoId  int =null 

	   
AS
BEGIN
		 
	--SELECT * FROM dbo.tblUser WHERE UserName=@UserName 

 	SELECT * FROM dbo.tblUser WHERE  LoginName=@LoginName and UserStatus='Active' 


union all	SELECT * FROM dbo.tblUser WHERE   EmpInfoId=@EmpInfoId AND EmpInfoId is not null   and UserStatus='Active' 



END



