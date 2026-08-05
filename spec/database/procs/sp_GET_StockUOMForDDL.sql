CREATE PROCEDURE [dbo].[sp_GET_StockUOMForDDL] 


AS
BEGIN
	
	 Select  StockUOMId, StockUOMName from tblStockUOM 

END