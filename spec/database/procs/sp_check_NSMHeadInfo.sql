

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_NSMHeadInfo]
	-- Add the parameters for the stored procedure here
	  @GroupId  INT ,
	  @NSMId  INT  
AS
BEGIN
		 
	SELECT * FROM dbo.tblNational_NSM WHERE NationalId=@GroupId AND  National_NSMId NOT IN ( @NSMId)

END



