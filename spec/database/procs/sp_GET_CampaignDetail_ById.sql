

 CREATE PROCEDURE [dbo].[sp_GET_CampaignDetail_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select dtl.CampaignDetailId, dtl.BonusTypeId BonusTypeId, dtl.BonusProductId   ProductId,bt.TypeName TypeName, pro.ProductCode+' ; '+ pro.ProductName  ProductName , dtl.BonusQuantity Qty, dtl.DiscountPercentage PercentAmount, dtl.QuantityDteail Amount  from [dbo].[tbl_BonusCampaignNewDetail] dtl with (nolock)
	left join tbl_BonusOnType bt  with (nolock) on dtl.BonusTypeId=bt.BonusTypeId
	left join tblProduct pro  with (nolock) on dtl.BonusProductId=pro.ProductId
	 where CampaignMasterId= @id
      
    END


