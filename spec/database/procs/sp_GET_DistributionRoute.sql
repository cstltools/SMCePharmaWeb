
CREATE PROCEDURE [dbo].[sp_GET_DistributionRoute]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	--SELECT		GRP.RouteInformationMasterId DistributionRouteId, GRP.RouteName DistributionRouteName 
	--FROM dbo.tblRouteInformationMaster AS GRP WITH (NOLOCK)

	select distinct ord.DistributionRouteId DistributionRouteId ,ord.DistributionRoute_Ord  DistributionRouteName

from tblOrder ord  with (nolock)
--inner join tblRouteInformationMaster  with (nolock) on tblRouteInformationMaster.RouteInformationMasterId=tblOrder.DistributionRouteId
where IsInvoice=1      order by ord.DistributionRoute_Ord asc

 END
