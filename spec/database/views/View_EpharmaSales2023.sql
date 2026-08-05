CREATE VIEW dbo.View_EpharmaSales2023
AS
SELECT dbo.tblInvoice.InvoiceNo, dbo.tblInvoice.UpdateDate AS SalesDate, dbo.tblInvoiceDetail.DeliveryNetAmount AS SalesValue, dbo.tblInvoiceDetail.DeliveryQuantity AS SalesQty, dbo.tblProduct.ProductCode, dbo.tblOrder.CustomerCode, 
                  dbo.tblOrder.RegionCode_Ord AS ZoneCode, dbo.tblOrder.AreaCode_Ord AS AreaCode, dbo.tblOrder.TerritoryCode_Ord AS TerritoryCode, dbo.tblCompanyUnit.ComUnitCode AS DepotCode, dbo.tblOrder.MIOCode, 
                  dbo.tblCustomerType.CustomerType, dbo.tblStockUOM.StockUOMName AS UOM
FROM     dbo.tblStockUOM INNER JOIN
                  dbo.tblInvoice INNER JOIN
                  dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId INNER JOIN
                  dbo.tblOrder ON dbo.tblInvoice.OrderId = dbo.tblOrder.OrderId INNER JOIN
                  dbo.tblProduct ON dbo.tblProduct.ProductCode = dbo.tblInvoiceDetail.ProductCode INNER JOIN
                  dbo.tblCompanyUnit ON dbo.tblCompanyUnit.ComUnitId = dbo.tblInvoice.ComUnitId ON dbo.tblStockUOM.StockUOMId = dbo.tblProduct.StockUOMId INNER JOIN
                  dbo.tblCustomerType INNER JOIN
                  dbo.tblCustMaster ON dbo.tblCustomerType.CustomerTypeId = dbo.tblCustMaster.CustomerTypeId ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
WHERE  (dbo.tblInvoice.UpdateDate BETWEEN '1-jan-2023' AND '31-dec-2023') AND (dbo.tblInvoice.DelivaryInvoiceNo IS NOT NULL) AND (dbo.tblInvoiceDetail.DeliveryStatus IN ('Full', 'Partial'))
