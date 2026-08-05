

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_MinusStockUpdatetoZero]
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN
		 
	update dbo.tblDCStore set StockQty=0    WHERE   StockQty<0

END



