CREATE PROCEDURE [dbo].[sp_GetMarketwisePickingslipByBatchNo_daaw]
	@BatchNo VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT DISTINCT * FROM (
        SELECT   
            'Route Name : ' +  rt.RouteName as MarketName,
            I.InvoiceDate,
            D.ProductCode,
            D.ProductName,
            D.BatchNo as BatchNo,
            D.PackSize,
            SUM(D.Quantity) AS Quantity  
        FROM dbo.tblInvoice I WITH (NOLOCK)
        INNER JOIN tblCustMaster C WITH (NOLOCK) ON I.CustomerMasterId = C.CustomerMasterId  
        INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId  
        INNER JOIN dbo.tblOrder ord WITH (NOLOCK) ON I.OrderId = ord.OrderId   
        INNER JOIN dbo.tblProduct P WITH (NOLOCK) ON D.ProductCode = P.ProductCode   
        INNER JOIN dbo.tblRouteInformationMaster rt WITH (NOLOCK) ON rt.RouteInformationMasterId = ord.DistributionRouteId
        INNER JOIN dbo.tblInvoiceBatch B WITH (NOLOCK) ON I.InvoiceId = B.InvoiceId
        WHERE B.BatchNo = @BatchNo
        GROUP BY 
            rt.RouteName,
            I.InvoiceDate,
            D.ProductCode,
            D.ProductName,
            D.BatchNo,
            D.PackSize,
            rt.RouteName 
    ) tbl 
    ORDER BY ProductName ASC;

END
