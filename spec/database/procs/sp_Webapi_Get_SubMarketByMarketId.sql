CREATE PROCEDURE [dbo].[sp_Webapi_Get_SubMarketByMarketId]
	-- Add the parameters for the stored procedure here
@marketId INT = NULL
AS
BEGIN
		
		SELECT SMId ,
               SMCode ,
               SMName 
			    FROM dbo.tbl_SubMarket WHERE MarketId = @marketId AND IsActive = 1
		 

END
