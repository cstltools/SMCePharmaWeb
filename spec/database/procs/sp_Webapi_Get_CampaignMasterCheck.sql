


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE 
[dbo].[sp_Webapi_Get_CampaignMasterCheck]
	-- Add the parameters for the stored procedure here
	@CustomerId INT,
	@param NVARCHAR(MAX)

AS
BEGIN
	
	DECLARE @CustTypeId INT=0

	SELECT @CustTypeId=CustomerTypeId FROM dbo.tblCustMaster WHERE CustomerMasterId=@CustomerId

	DECLARE @q NVARCHAR(MAX)='
	SELECT Count(tbl_BonusCampaignNewMaster.BonusProductId) as ProductCount,tbl_BonusCampaignNewMaster.BonusProductId FROM dbo.tbl_BonusCampaignNewMaster
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId AND CampainTypeId=3
	 WHERE IsActive=1 AND (GETDATE() BETWEEN FromDate AND Todate) AND (CampgainMasterId IN (SELECT CampMasId FROM dbo.GetCampaignCustomer('+CONVERT(NVARCHAR(MAX),@CustTypeId)+') WHERE CustomerId='+CONVERT(NVARCHAR(MAX),@CustomerId)+')) '+@param
	 +' GROUP BY tbl_BonusCampaignNewMaster.BonusProductId Having Count(tbl_BonusCampaignNewMaster.BonusProductId)>1  '

	 EXEC sys.sp_executesql @q
	

END




