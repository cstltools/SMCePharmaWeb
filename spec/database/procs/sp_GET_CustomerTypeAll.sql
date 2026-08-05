
CREATE PROCEDURE [dbo].[sp_GET_CustomerTypeAll]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT  CustomerTypeId, case when IsActive=1 then GRP.CustomerType else  GRP.CustomerType+ ' [Inactive]' end CustomerType
	FROM dbo.tblCustomerType AS GRP WITH (NOLOCK)  


 END
