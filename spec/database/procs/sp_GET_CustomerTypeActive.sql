
create PROCEDURE [dbo].[sp_GET_CustomerTypeActive]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT  CustomerTypeId,   GRP.CustomerType   CustomerType
	FROM dbo.tblCustomerType AS GRP WITH (NOLOCK)   where GRP.IsActive=1


 END