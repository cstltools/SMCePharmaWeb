CREATE PROCEDURE [dbo].[sp_Get_RouteInfoforReturn2ndTimes]
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT 
        ord.DistributionRouteId,
        ord.DistributionRoute_Ord AS DistributionRouteName
    FROM 
        tblOrder AS ord WITH (NOLOCK)
    INNER JOIN 
        tblInvoice AS inv WITH (NOLOCK) ON ord.OrderId = inv.OrderId
    --INNER JOIN tblRouteInformationMaster AS route WITH (NOLOCK) 
    --    ON ord.DistributionRouteId = route.RouteInformationMasterId
    WHERE 
        inv.PaymentInvoiceNo IS NOT NULL
        AND inv.SndReturnInvoiceNo IS NULL
        AND inv.ComUnitId = @id and ord.DistributionRoute_Ord is not null
END;
