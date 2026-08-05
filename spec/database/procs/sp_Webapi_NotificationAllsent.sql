


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Webapi_NotificationAllsent]
	-- Add the parameters for the stored procedure here
    
AS
    BEGIN
	
	DECLARE @NoticeTitle NVARCHAR(MAX)
DECLARE @Announcement NVARCHAR(MAX)
DECLARE @EmployeeId INT
DECLARE @NoticeId INT
DECLARE @EmpNoticeId INT


DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR



SELECT NoticeTitle,Announcement,EmployeeId,NoticeId,Notice_Emp_Id FROM dbo.tbl_Notice_MarketMaster
inner JOIN dbo.tblNotice_Employee ON dbo.tbl_Notice_MarketMaster.NoticeId=dbo.tblNotice_Employee.MasterId
WHERE (IsPushNotification IS NULL OR IsPushNotification='0') AND (IsPushNotificationEmp is null or IsPushNotificationEmp='0')  AND CONVERT(date, GETDATE())  BETWEEN FromDate AND ToDate

OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO   @NoticeTitle,
    @Announcement,@EmployeeId,@NoticeId,@EmpNoticeId

WHILE @@FETCH_STATUS = 0
BEGIN



DECLARE @devicetoken NVARCHAR(MAX)

SELECT 
   @devicetoken=
   STUFF((SELECT ', '+'"' + US.DeviceToken +'"'
          FROM tblUserDeviceToken US
          WHERE US.EmpInfoId = SS.EmpInfoId
          ORDER BY US.EmpInfoId
          FOR XML PATH('')), 1, 1, '') 
FROM dbo.tblUserDeviceToken SS
WHERE SS.EmpInfoId=@EmployeeId
GROUP BY SS.EmpInfoId


SET @devicetoken='['+@devicetoken+']'


set @Announcement=''

DECLARE @status NVARCHAR(MAX)


DECLARE	
		@response nvarchar(max)

EXEC	[dbo].[sp_Webapi_NotificationPost]
		@notitle = @NoticeTitle,
		@nobody = @Announcement,
		@deviceids = @devicetoken,
		@response = @response OUTPUT

SELECT @status=StringValue FROM parseJSON(@response) WHERE Name='message'

IF(@status='Success')
BEGIN
    UPDATE dbo.tblNotice_Employee SET IsPushNotificationEmp='1' WHERE Notice_Emp_Id=@EmpNoticeId
END



DECLARE @countnonupdate INT
SELECT @countnonupdate=ISNULL(COUNT(*),0) FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId AND (IsPushNotificationEmp IS NULL OR IsPushNotificationEmp='0')
IF(@countnonupdate=0)
BEGIN
    UPDATE dbo.tbl_Notice_MarketMaster SET IsPushNotification='1' WHERE NoticeId=@NoticeId
END




FETCH NEXT FROM @MyCursor
INTO   @NoticeTitle,
    @Announcement,@EmployeeId,@NoticeId,@EmpNoticeId
END
CLOSE @MyCursor
DEALLOCATE @MyCursor







    END




