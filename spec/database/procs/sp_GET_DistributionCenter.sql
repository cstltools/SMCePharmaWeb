
create PROCEDURE [dbo].[sp_GET_DistributionCenter]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT GRP.ComUnitId, GRP.ComUnitCode +' : '+GRP.ComUnitName ComUnitName
	FROM dbo.tblCompanyUnit AS GRP WITH (NOLOCK) 



 END
