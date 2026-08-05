create PROCEDURE [dbo].[sp_Get_BonusCampaigndtlList]
	-- Add the parameters for the stored procedure here
	@CampgainMasterId nvarchar(max)=null
AS
BEGIN
    select CampaignDetailId  From dbo.tbl_BonusCampaignNewDetail where  CampaignMasterId = @CampgainMasterId
	
END