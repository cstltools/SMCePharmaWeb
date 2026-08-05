	CREATE PROCEDURE 
[dbo].[sp_Webapi_Get_CampaignNCOD]
	-- Add the parameters for the stored procedure here
	 @CustomerId INT,
	@param NVARCHAR(MAX)

AS
BEGIN
	
	SELECT distinct tbl_BonusCampaignNewMaster.BonusProductId FROM dbo.tbl_BonusCampaignNewMaster
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId  
	 WHERE CustomerTypeId=12  and IsActive=1  and IsTradePolicy=0 AND (getdate() BETWEEN FromDate AND Todate)    and tbl_BonusCampaignNewMaster.BonusProductId=@CustomerId


	 end