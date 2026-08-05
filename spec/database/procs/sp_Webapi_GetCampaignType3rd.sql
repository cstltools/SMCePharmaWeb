CREATE PROCEDURE [dbo].[sp_Webapi_GetCampaignType3rd]
	-- Add the parameters for the stored procedure here
@RemTotalAmount DECIMAL(18,0),
@customerId INT,@cuttypeId INT ,
	@PaymentType NVARCHAR(20)
AS
BEGIN


if(@PaymentType='COD')
	begin
	SELECT isnull(IsFCFS,0) IsFCFS,isnull(IsTradePolicy,0) IsTradePolicy, * FROM dbo.tbl_BonusCampaignNewMaster
		WHERE IsPTforCOD=1 and (@RemTotalAmount BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount) AND (GETDATE() BETWEEN FromDate AND Todate)
	AND CampainTypeId='3' 
	--and CustomerTypeId= @cuttypeId 
	AND IsActive=1 AND CampgainMasterId IN (SELECT CampaignMasterId FROM dbo.tblCustMasterCampNew with (nolock)  WHERE CustomerMasterId=@customerId and custtypeid=@cuttypeId)
	end
	 
	if(@PaymentType='NCOD')
	begin
	SELECT isnull(IsFCFS,0) IsFCFS,isnull(IsTradePolicy,0) IsTradePolicy, * FROM dbo.tbl_BonusCampaignNewMaster
		WHERE IsPTforOther=1 and  (@RemTotalAmount BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount) AND (GETDATE() BETWEEN FromDate AND Todate)
	AND CampainTypeId='3' 
	--and CustomerTypeId= @cuttypeId 
	AND IsActive=1 AND CampgainMasterId IN (SELECT CampaignMasterId FROM dbo.tblCustMasterCampNew with (nolock)  WHERE CustomerMasterId=@customerId and custtypeid=@cuttypeId)
	end
	
	

END
