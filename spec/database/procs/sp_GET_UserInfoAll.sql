CREATE
 PROCEDURE [dbo].[sp_GET_UserInfoAll] 

 @loginName nvarchar(Max),
 @Password nvarchar(Max)
AS
BEGIN
 SELECT U.UserId,
        U.UserName,
        U.UserType,
       
        U.LoginName,
        U.Password,
        U.UserStatus,
        U.Email,
        U.ContactNo
        
 FROM dbo.tblUser U  
 
 where LoginName=@loginName and Password=@Password
 
END
