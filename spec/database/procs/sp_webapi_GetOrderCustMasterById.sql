CREATE PROCEDURE [dbo].[sp_webapi_GetOrderCustMasterById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
		SELECT D.CustomerMasterId ,
                D.CustomerName ,
				D.CategoryId,
                D.CustomerCode ,
				D.type,
                D.Address ,
                D.MarketName ,
                D.CellNo ,
				D.MarketId,
				D.MarketCode,
				D.OwnerName,
				'' City ,D.StreetAddress,
                Type AS CustomerType  FROM dbo.View_CustomerMaster D 
WHERE D.CustomerMasterId=@id
END
