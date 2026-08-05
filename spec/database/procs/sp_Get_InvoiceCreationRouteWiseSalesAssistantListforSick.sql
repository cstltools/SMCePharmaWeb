
create PROCEDURE [dbo].[sp_Get_InvoiceCreationRouteWiseSalesAssistantListforSick]
    
    @DCId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
          daInfo.DAId DAId,
       '[' +  mas.RouteName+ '] ' +  ISNULL(daInfo.DACode, '') + ' : ' + ISNULL(daInfo.Name, '') AS DAName
    FROM dbo.tblRouteInformationMaster mas WITH (NOLOCK)
    INNER JOIN dbo.tblRouteInformationDADetail daDtl WITH (NOLOCK)
            ON mas.RouteInformationMasterId = daDtl.RouteInformationMasterId
    INNER JOIN dbo.tblDAInfo daInfo WITH (NOLOCK)
            ON daInfo.DAId = daDtl.DAId
   
    WHERE mas.DCId = @DCId
         
and mas.RouteInformationMasterId in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )
    ORDER BY DAName;
END