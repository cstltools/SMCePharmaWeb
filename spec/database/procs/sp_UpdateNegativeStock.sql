
CREATE PROCEDURE [dbo].[sp_UpdateNegativeStock]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

update tblCentralStore set Quantity=0 where Quantity<0
update tblDCStore set StockQty=0  where StockQty<0




 END
