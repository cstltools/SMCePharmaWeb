-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_UserMaster]
	-- Add the parameters for the stored procedure here
	@UserId INT,
    @UserName nvarchar (max)=NULL,
    @UserType nvarchar (max)=NULL,
    @LoginName nvarchar (max)=NULL,
    @Password nvarchar (max)=NULL,
    @IMEI_One nvarchar (max)=NULL,
    @IMEI_Two nvarchar (max)=NULL,
    @EmpInfoId int=NULL,
    @UserRoleID int=NULL,
    @UserTypeId int=NULL,
    
    
	@IsAppsUser bit=NULL,
    @ActiveInActiveDate datetime=NULL,
	@EntryBy nvarchar(50)=NULL,


	@UserStatus nvarchar (max)=NULL

   
AS
    BEGIN

       UPDATE [dbo].[tblUser] set
     [UserName]=@UserName
           ,[UserType]=@UserType
           
           ,[LoginName]=@LoginName
           ,[Password]=@Password,
         
      UserStatus=@UserStatus
           ,[EmpInfoId]=@EmpInfoId
           ,[IsAppsUser]=@IsAppsUser
           ,[IMEI_One]=@IMEI_One
           ,[IMEI_Two]=@IMEI_Two
           ,[UserRoleID]=@UserRoleID
           ,[ActiveInActiveDate]=@ActiveInActiveDate
           ,[UserTypeId]=@UserTypeId,UpdateBy=@EntryBy,UpdateDate =GETDATE()               
        WHERE    UserId = @UserId
 delete from [tbl_UserMarketDetail]         WHERE    UserId = @UserId
 delete from tblUserCompanyUnit         WHERE    UserId = @UserId
 
    END

