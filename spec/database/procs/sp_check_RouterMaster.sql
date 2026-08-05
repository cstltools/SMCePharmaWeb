


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_RouterMaster]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @RouterName   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.RouterMaster WHERE RouterName=@RouterName AND RouterMasterId NOT IN ( @id)

END




