
create PROCEDURE [dbo].[sp_GET_CampaignCategory]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT   *
	FROM dbo.tblCampaignCategory AS GRP WITH (NOLOCK) 


 END
