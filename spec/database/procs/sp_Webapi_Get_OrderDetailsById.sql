-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_OrderDetailsById]
	-- Add the parameters for the stored procedure here
    @OrderId INT  
AS
    BEGIN
	
  SELECT   dtl.ProductId,pro.ProductCode, pro.ProductName,dtl.TotalTradePrice UnitPrice, dtl.Quantity,dtl.TradePrice TotalTradePrice, dtl.TotalTradePrice, dtl.TotalVatAmount
                FROM    tblOrderDetail dtl     with (nolock)
                        LEFT JOIN dbo.tblProduct pro    with (nolock) ON pro.ProductId = dtl.ProductId
                     where dtl.OrderId=@OrderId

    END

