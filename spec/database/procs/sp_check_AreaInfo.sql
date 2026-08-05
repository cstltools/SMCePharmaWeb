


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_AreaInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT ,@zoneId int ,
      @Name     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT  * FROM dbo.tblArea WHERE AreaName=@Name AND AreaId NOT IN ( @id) and RegionId=@zoneId

END




