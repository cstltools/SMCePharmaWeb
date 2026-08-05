
CREATE PROCEDURE [dbo].[sp_GET_CustomerType]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblCustomerType AS GRP WITH (NOLOCK) WHERE IsActive = 1


 END
