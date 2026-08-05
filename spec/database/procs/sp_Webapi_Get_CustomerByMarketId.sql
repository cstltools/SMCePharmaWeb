CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerByMarketId]
	-- Add the parameters for the stored procedure here
@marketId INT = NULL
AS
BEGIN
		
		SELECT CustomerMasterId ,
              (CustomerCode +' : '+ CustomerName)AS CustomerName  ,
               Address 
			    FROM dbo.tblCustMaster WHERE MarketId = @marketId AND IsActive = 1
		 

END
