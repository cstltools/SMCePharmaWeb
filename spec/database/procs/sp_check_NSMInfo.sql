

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_NSMInfo]
	-- Add the parameters for the stored procedure here
	  @GroupId  INT ,
	  @NSMId  INT  
AS
BEGIN
		 
	SELECT * FROM dbo.tblNSMInfo WHERE GroupId=@GroupId AND  NSMId NOT IN ( @NSMId)

END



