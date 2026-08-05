CREATE PROCEDURE [dbo].[sp_GetTopSheetByBatchNo_daaw]
	@BatchNo VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT   da.Dacode+' : '+da.Name SalesAsistant,
        '' AS TopSheetGenCode,
        Ct.CustomerType AS CustomerType, 
        CellNo,
        (C.Address + '[' + C.Address +']') as Address,
        'Route Name : ' + rt.RouteName as MarketName,
        tblD.ManufacId as TpGrandTotal,
        * 				
    FROM tblInvoice I  WITH (NOLOCK)
    INNER JOIN (
        SELECT DISTINCT D.InvoiceId, sum(NetAmount) as ManufacId  
        FROM dbo.tblInvoice I WITH (NOLOCK)
        INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
        INNER JOIN dbo.tblProduct P WITH (NOLOCK) ON D.ProductCode = P.ProductCode
        GROUP BY D.InvoiceId
    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
    INNER JOIN dbo.tblCustMaster C WITH (NOLOCK) ON I.CustomerMasterId = C.CustomerMasterId
    INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON I.OrderId = ord.OrderId  
    LEFT JOIN dbo.tblCustomerType Ct WITH (NOLOCK) ON ord.CustTypeId = Ct.CustomerTypeId
    INNER JOIN dbo.tblRouteInformationMaster rt WITH (NOLOCK) ON rt.RouteInformationMasterId = ord.DistributionRouteId 
    left join tblRouteInformationDADetail rtda on rtda.RouteInformationMasterId=ord.DistributionRouteId 

    left join tblDAInfo da on rtda.DAId=da.DAId 

    INNER JOIN dbo.tblInvoiceBatch B WITH (NOLOCK) ON I.InvoiceId = B.InvoiceId
    WHERE B.BatchNo = @BatchNo
    ORDER BY I.InvoiceNo ASC;

END
