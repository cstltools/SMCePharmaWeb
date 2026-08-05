
CREATE PROCEDURE [dbo].[sp_GET_CampaignType]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT Description TypeName, *
	FROM dbo.tbl_CampaignType AS GRP WITH (NOLOCK) WHERE IsActive = 1


 END
