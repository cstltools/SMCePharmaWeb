CREATE PROCEDURE [dbo].[sp_CS_CustomerType_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT CustomerTypeId,   CASE WHEN IsActive=1 THEN   CustomerType  ELSE   CustomerType+' (Inactive)' END  CustomerType  FROM dbo.tblCustomerType  with(nolock)
END
