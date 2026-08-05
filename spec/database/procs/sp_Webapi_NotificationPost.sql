

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Webapi_NotificationPost]
	-- Add the parameters for the stored procedure here
    @notitle NVARCHAR(max) = NULL ,
    @nobody nvarchar(max) = NULL,
	@deviceids NVARCHAR(MAX) NULL,
	@response NVARCHAR(MAX) OUTPUT
AS
    BEGIN
	
	Declare @json as table(Json_Table nvarchar(max))
	Declare @Object as Int;
Declare @ResponseText as Varchar(8000);
Declare @Body as varchar(MAX) = 
'{
    "NotificationTitle":"'+@notitle+'",
    "NotificationBody":"'+@nobody+'",
    "IsTopicWise":false,
    "Topic":"mychannel",
    "DeviceIds":'+@deviceids+'
}'  

--Exec sp_configure 'show advanced options', 1;  
--RECONFIGURE;  
--exec sp_configure 'Ole Automation Procedures', 1;  
--RECONFIGURE;  
Exec sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
EXEC  sp_OAMethod @Object, 'open', NULL, 'post','http://13.76.141.111:643/api/Notification/SendNotification', 'false'

Exec sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
Exec sp_OAMethod @Object, 'send', null, @body

Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
Select @ResponseText
SET @response=@ResponseText

Exec sp_OADestroy @Object

--RETURN @ResponseText

    END



