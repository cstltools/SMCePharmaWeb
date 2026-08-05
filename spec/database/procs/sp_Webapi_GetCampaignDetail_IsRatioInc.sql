create
 PROCEDURE [dbo].[sp_Webapi_GetCampaignDetail_IsRatioInc]
	-- Add the parameters for the stored procedure here
    
    @CampaignMasterId INT = NULL,
	@param NVARCHAR(MAX)=NULL
	
AS
    BEGIN
	
	DECLARE @q NVARCHAR(MAX)='

SELECT tbl_BonusCampaignNewMaster.Amount MasMinAmount, CampaignDetailId,
       CampaignMasterId,
       DiscountPercentage,
       DiscountAmount,
       tbl_BonusCampaignNewDetail.ProductId,
       Quantity,
       tbl_BonusCampaignNewDetail.BonusProductId,
       BonusQuantity,
       BonusTypeId,
       tbl_BonusCampaignNewDetail.CampaignName,
       MinAmount,
       tbl_BonusCampaignNewDetail.MaxAmount,
       BonusProductCode,
       tbl_BonusCampaignNewDetail.ProductCode,
       QuantityDteail,
       tblProduct.ProductCode,
       ProductName FROM dbo.tbl_BonusCampaignNewDetail
LEFT JOIN dbo.tblProduct ON tblProduct.ProductId = tbl_BonusCampaignNewDetail.BonusProductId
 LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = tbl_BonusCampaignNewDetail.CampaignMasterId
WHERE CampaignMasterId='+CONVERT(NVARCHAR(MAX),@CampaignMasterId)+' AND BonusTypeId=''5'' '+@param


EXEC sys.sp_executesql @q


    END


