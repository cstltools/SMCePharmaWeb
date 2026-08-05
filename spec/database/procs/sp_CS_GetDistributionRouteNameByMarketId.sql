
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetDistributionRouteNameByMarketId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
			 


			select   mas.RouteInformationMasterId ,mas.RouteName DistributionRouteName

from   tblRouteInformationMaster mas with (nolock) 
inner join dbo.tblRouteInformationMarketDetail dtl with (nolock)  on dtl.RouteInformationMasterId=mas.RouteInformationMasterId

WHERE dtl.MarketId=@id
END


