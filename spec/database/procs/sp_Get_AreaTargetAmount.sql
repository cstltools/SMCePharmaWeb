
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_AreaTargetAmount]
	-- Add the parameters for the stored procedure here

	@RegionId INT,
	@month nvarchar(max),
	@Year INT


AS
BEGIN
	
	SELECT    Amount FROM dbo.tblAreaWiseTargetSetup  with (nolock) WHERE    AreaId = @RegionId and Year=@Year and  month=@month

END



