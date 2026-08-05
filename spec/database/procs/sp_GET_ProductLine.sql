
create PROCEDURE [dbo].[sp_GET_ProductLine]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblProductLine AS GRP WITH (NOLOCK) 



 END
