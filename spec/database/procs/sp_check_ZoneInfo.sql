


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_ZoneInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
	  @GroupId  INT ,
      @Name     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblRegion WHERE RegionName=@Name  AND GroupId=@GroupId AND RegionId NOT IN ( @id)

END




