


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TADAMarketRuleConfig_For_DDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    

	Select A.StationTypeId TourTypeId, A.StationTypeName TourTypeName from dbo.tblStationType A WHERE A.IsActive=1


END




