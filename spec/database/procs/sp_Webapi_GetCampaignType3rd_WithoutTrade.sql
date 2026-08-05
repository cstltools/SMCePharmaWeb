

create PROCEDURE [dbo].[sp_Webapi_GetCampaignType3rd_WithoutTrade]
	-- Add the parameters for the stored procedure here
@RemTotalAmount DECIMAL(18,0),
@customerId INT,@cuttypeId INT
AS
BEGIN
	
	SELECT * FROM dbo.tbl_BonusCampaignNewMaster
		WHERE (@RemTotalAmount BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount) AND (GETDATE() BETWEEN FromDate AND Todate)
	AND CampainTypeId='3' AND IsActive=1 and tbl_BonusCampaignNewMaster.IsTradePolicy=0 AND  CampgainMasterId IN (SELECT CampMasId FROM dbo.GetCampaignCustomer(@cuttypeId) WHERE CustomerId=@customerId)

END


