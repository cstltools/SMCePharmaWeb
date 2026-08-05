
CREATE PROCEDURE [dbo].[sp_Get_InvoiceCreationRouteWiseSalesAssistantList]
    @InputDate DATE,
    @DCId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
           mas.RouteInformationMasterId DAId,
       '[' +  mas.RouteName+ '] ' +  ISNULL(daInfo.DACode, '') + ' : ' + ISNULL(daInfo.Name, '') AS DAName
    FROM dbo.tblRouteInformationMaster mas WITH (NOLOCK)
    INNER JOIN dbo.tblRouteInformationDADetail daDtl WITH (NOLOCK)
            ON mas.RouteInformationMasterId = daDtl.RouteInformationMasterId
    INNER JOIN dbo.tblDAInfo daInfo WITH (NOLOCK)
            ON daInfo.DAId = daDtl.DAId
    INNER JOIN dbo.tblRouteInformationWeekNameDetails rtDays WITH (NOLOCK)
            ON mas.RouteInformationMasterId = rtDays.RouteInformationMasterId
    INNER JOIN dbo.tblWeekNameInfo rtWeekName WITH (NOLOCK)
            ON rtWeekName.WeekNameId = rtDays.WeekNameId
    WHERE mas.DCId = @DCId
      AND rtWeekName.WeekName = DATENAME(WEEKDAY, @InputDate)    
and mas.RouteInformationMasterId in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )
    ORDER BY DAName;
END