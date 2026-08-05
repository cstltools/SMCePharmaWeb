
CREATE PROCEDURE [dbo].[sp_Webapi_GetCampaignTradePolicyPerc]
	-- Add the parameters for the stored procedure here
@RemTotalAmount DECIMAL(18,0),
@customerId INT,@cuttypeId INT
AS
BEGIN
	
	SELECT * FROM dbo.tbl_BonusCampaignNewMaster
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	WHERE (@RemTotalAmount BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount) AND (GETDATE() BETWEEN FromDate AND Todate)
	AND CampaignMasterId IN (SELECT CampMasId FROM dbo.GetCampaignCustomer(@cuttypeId) WHERE CustomerId=@customerId)

END

