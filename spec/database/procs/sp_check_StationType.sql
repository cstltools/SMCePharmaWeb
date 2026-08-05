
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_StationType]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
     @StationTypeName  NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblStationType WHERE StationTypeName=@StationTypeName AND    StationTypeId NOT IN ( @id)

END


