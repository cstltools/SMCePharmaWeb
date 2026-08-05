CREATE PROCEDURE [dbo].[sp_GET_DistributionRouteByDCID]
	-- Add the parameters for the stored procedure here
  @id int

AS
    BEGIN

	--SELECT		GRP.RouteInformationMasterId , GRP.RouteName RouteName 
	--FROM dbo.tblRouteInformationMaster AS GRP WITH (NOLOCK)
	--where GRP.DCId=@id
	
	select distinct ord.DistributionRouteId RouteInformationMasterId ,ord.DistributionRoute_Ord  RouteName
	 
from tblOrder ord  with (nolock)  where IsInvoice=1  and DistributionRoute_Ord is not null 
and ord.ComUnitId=@id order by ord.DistributionRoute_Ord 
 END