CREATE PROCEDURE [dbo].[sp_Webapi_GetCampaignFCFSCampainType]
	-- Add the parameters for the stored procedure here
 
@CampgainMasterId INT 
AS
BEGIN
	
	SELECT isnull(IsFCFS,0) IsFCFS, CampainTypeId, CampaignName FROM dbo.tbl_BonusCampaignNewMaster m
		WHERE m.CampgainMasterId=@CampgainMasterId

END
