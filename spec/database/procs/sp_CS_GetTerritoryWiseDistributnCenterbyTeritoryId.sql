
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_CS_GetTerritoryWiseDistributnCenterbyTeritoryId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN

SELECT mas.DCId FROM dbo.tblDcWiseTerritoryDetail dtl
INNER JOIN dbo.tblDcWiseTerritoryMaster  mas ON mas.DcWiseTerritoryMasterId = dtl.DcWiseTerritoryMasterId
WHERE dtl.TerritoryId=@id
			 

END


