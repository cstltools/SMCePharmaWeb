CREATE PROCEDURE [dbo].[sp_WebAPi_GetOrderDetails_New]  -- sp_WebAPi_GetOrderDetails_New 90672
	-- Add the parameters for the stored procedure here
    @orderId INT
AS
    BEGIN
		
        SELECT  ( B.ProductCode + ' : ' + B.ProductName ) AS ProductName ,
                CAST(Quantity AS INT) Quantity ,
                ISNULL(TradePrice, 0) AS TotalTradePrice ,
                ISNULL(TotalVatAmount, 0) AS TotalVatAmount ,
                ISNULL(NetAmount, 0) AS NetAmount
        FROM    dbo.tblOrderDetail
                LEFT JOIN dbo.tblProduct B ON B.ProductId = tblOrderDetail.ProductId
        WHERE   OrderId = @orderId
    END