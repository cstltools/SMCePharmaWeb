
 create PROCEDURE [dbo].[sp_GET_CampaignMasterMap_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select  isnull(max(BonusCampaignDetailsCustTypeId),0)+1 BonusCampaignDetailsCustTypeId from [tbl_BonusCampaignDetailsCustType]  
      
    END
