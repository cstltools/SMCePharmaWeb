
create PROCEDURE [dbo].[sp_GET_ProductNameList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT GRP.ProductId, GRP.ProductCode+' : '+GRP.ProductName ProductName
	FROM dbo.tblProduct AS GRP WITH (NOLOCK) where GRP.IsActive=1



 END
