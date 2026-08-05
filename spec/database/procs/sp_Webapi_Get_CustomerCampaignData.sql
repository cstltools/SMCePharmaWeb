
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerCampaignData] 
	-- Add the parameters for the stored procedure here
	@customerId INT,
	@productId INT,
	@qty DECIMAL(18,0),
	@totalprice DECIMAL(18,2)
AS
BEGIN
	DECLARE @CustomerTypeId INT =0 
DECLARE @CountData INT=0

SELECT @CustomerTypeId=CustomerTypeId FROM dbo.tblCustMaster
WHERE CustomerMasterId=@customerId

		SELECT @CountData=COUNT(*) FROM dbo.GetCampaignCustomer(@CustomerTypeId) WHERE CustomerId=@customerId
 IF(@CountData>0)
 BEGIN
     IF(@productId<>0)
	 BEGIN
     
	 SELECT tbl_BonusCampaignNewDetail.CampaignName,CampaignCode,CampainTypeId,CustomerTypeId,tbl_BonusCampaignNewDetail.BonusProductId,CampaignMasterId,dbo.tbl_BonusCampaignNewMaster.MaxAmount,MinAmount,ProductQty FROM dbo.tbl_BonusCampaignNewMaster
	 LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	 WHERE (GETDATE() BETWEEN FromDate AND Todate) AND tbl_BonusCampaignNewDetail.BonusProductId=@productId
	 AND CampaignMasterId IN (SELECT CampMasId FROM dbo.GetCampaignCustomer(@CustomerTypeId) WHERE CustomerId=@customerId)

	 UNION ALL

	 SELECT tbl_BonusCampaignNewDetail.CampaignName,CampaignCode,CampainTypeId,CustomerTypeId,tbl_BonusCampaignNewDetail.BonusProductId,CampaignMasterId,dbo.tbl_BonusCampaignNewMaster.MaxAmount,Amount AS MinAmount,ProductQty FROM dbo.tbl_BonusCampaignNewMaster
	 LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	 WHERE (GETDATE() BETWEEN FromDate AND Todate) AND tbl_BonusCampaignNewDetail.BonusProductId=@productId
	 AND CampaignMasterId IN (SELECT CampMasId FROM dbo.GetCampaignCustomer(@CustomerTypeId) WHERE CustomerId=@customerId) AND @totalprice BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount
	 END
	 ELSE
	 BEGIN
	     SELECT tbl_BonusCampaignNewDetail.CampaignName,CampaignCode,CampainTypeId,CustomerTypeId,ISNULL(tbl_BonusCampaignNewDetail.BonusProductId,0)BonusProductId,CampaignMasterId,dbo.tbl_BonusCampaignNewMaster.MaxAmount,Amount AS MinAmount,ProductQty FROM dbo.tbl_BonusCampaignNewMaster
	 LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	 WHERE (GETDATE() BETWEEN FromDate AND Todate) AND tbl_BonusCampaignNewDetail.BonusProductId IS NULL
	 AND CampaignMasterId IN (SELECT CampMasId FROM dbo.GetCampaignCustomer(@CustomerTypeId) WHERE CustomerId=@customerId) AND @totalprice BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount
	 END
     
	 
     



	


 END
ELSE
BEGIN
    SELECT tbl_BonusCampaignNewDetail.CampaignName,CampaignCode,CampainTypeId,CustomerTypeId,tbl_BonusCampaignNewDetail.BonusProductId,CampaignMasterId FROM dbo.tbl_BonusCampaignNewMaster
	 LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	 WHERE  ProductQty=-100000
END		 



END


