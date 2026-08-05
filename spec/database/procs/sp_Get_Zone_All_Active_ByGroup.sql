
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_Zone_All_Active_ByGroup]
	-- Add the parameters for the stored procedure here

	@GroupId INT

AS
BEGIN
	
	SELECT RegionId,RegionCode+' : '+ RegionName RegionName  FROM dbo.tblRegion   with (nolock) WHERE IsActive = 1 and GroupId = @GroupId

END



