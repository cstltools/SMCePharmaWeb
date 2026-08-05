

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_MIOInfo]
	-- Add the parameters for the stored procedure here
	  @TerritoryId  INT ,
	  @MIOId  INT  
AS
BEGIN
		 
	SELECT * FROM dbo.tblMIOInfo WHERE TerritoryId=@TerritoryId AND  MIOId NOT IN ( @MIOId)
	 and IsActive=1
END



