-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_UserDeviceToken]
	-- Add the parameters for the stored procedure here
    @username NVARCHAR(50) ,
    @password NVARCHAR(50),
    @DeviceToken NVARCHAR(MAX)=NULL,
	@Device NVARCHAR(MAX)=NULL
AS
    BEGIN
	
	
	DECLARE @UserId INT , @EmpInfoId INT , @Count INT ,
	   @CountData int
SELECT @CountData=COUNT(*) FROM tblUser A
	WHERE   A.LoginName = @username
                AND A.Password = @password
                AND A.UserStatus = 'Active'

print @CountData
 IF(@CountData=1)
 BEGIN 

 
SELECT @UserId=A.UserId, @EmpInfoId= A.EmpInfoId	 FROM    tblUser A
	WHERE   A.LoginName = @username
                AND A.Password = @password
                AND A.UserStatus = 'Active'
  SELECT @Count=ISNULL(COUNT(*),0) FROM dbo.tblUserDeviceToken WHERE UserId = @UserId     AND  DeviceToken=@DeviceToken
  IF(@Count=0)
	BEGIN

       INSERT INTO [dbo].[tblUserDeviceToken]
           ([UserId]
           ,[EmpInfoId]
           ,[DeviceToken], EntryDate, Device)
     VALUES
           (@UserId 
           ,@EmpInfoId 
           ,@DeviceToken,GETDATE(), @Device)

SELECT SCOPE_IDENTITY()

    END
    END

	end	