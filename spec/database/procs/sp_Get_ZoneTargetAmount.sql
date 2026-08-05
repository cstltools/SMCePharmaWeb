
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ZoneTargetAmount]
	-- Add the parameters for the stored procedure here

	@RegionId INT,
	@month nvarchar(max),
	@Year INT


AS
BEGIN
	
	SELECT    Amount FROM dbo.tblZoneWiseTargetSetup  with (nolock) WHERE    RegionId = @RegionId and Year=@Year and  month=@month

END



