
--------------------------------------------------
-- PROCEDURE: sp_GET_da_MarketListDAClaim
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_GET_da_MarketListDAClaim]
    @ComUnitId INT,
    @RouteId INT,
    @daid INT,
    @frmDate DATE,
    @toDate DATE
AS
BEGIN
    SET NOCOUNT ON;


    select DISTINCT * from (
    SELECT  DISTINCT  
        mas.MarketCode_Ord + ' : ' + mas.MarketName_Ord AS MarketName,
        mas.MarketId,
        CAST(100 AS DECIMAL(18, 2)) AS DAClaimAmount
    FROM dbo.tblInvoice I WITH (NOLOCK)
    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
        ON ID.InvoiceId = I.InvoiceId
    INNER JOIN dbo.tblOrder mas WITH (NOLOCK)
        ON I.OrderId = mas.OrderId
  
   
    WHERE
        ( DelivaryInvoiceNo IS    NULL )  
        AND mas.ComUnitId = @ComUnitId
        AND mas.DistributionRouteId = @RouteId
        AND CONVERT(DATE, I.InvoiceDate) BETWEEN CONVERT(DATE,@frmDate) AND CONVERT(DATE,@toDate) 


        union all

        
    SELECT  DISTINCT  
        mas.MarketCode_Ord + ' : ' + mas.MarketName_Ord AS MarketName,
        mas.MarketId,
        CAST(100 AS DECIMAL(18, 2)) AS DAClaimAmount
    FROM dbo.tblInvoice I WITH (NOLOCK)
    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
        ON ID.InvoiceId = I.InvoiceId
    INNER JOIN dbo.tblOrder mas WITH (NOLOCK)
        ON I.OrderId = mas.OrderId
  
   
    WHERE
        ( PaymentInvoiceNo IS    NULL )  
        AND mas.ComUnitId = @ComUnitId
        AND mas.DistributionRouteId = @RouteId
        AND CONVERT(DATE, I.UpdateDate) BETWEEN CONVERT(DATE,@frmDate) AND CONVERT(DATE,@toDate))tbl
END

