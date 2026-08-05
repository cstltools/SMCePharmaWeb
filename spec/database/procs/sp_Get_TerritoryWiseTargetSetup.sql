-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_TerritoryWiseTargetSetup]
	-- Add the parameters for the stored procedure here

	@RegionId INT,
	@month nvarchar(max),
	@Year INT


AS
BEGIN
	
	SELECT    Amount FROM dbo.tblTerritoryWiseTargetSetup  with (nolock) WHERE    TerritoryId= @RegionId and Year=@Year and  month=@month

END


