

 CREATE PROCEDURE [dbo].[sp_Webapi_GET_CampaignDetail_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select dtl.BonusTypeId BonusTypeId, dtl.BonusProductId   ProductId,bt.TypeName OfferTypeName, case when dtl.BonusProductId is not null then   pro.ProductCode+' : '+ pro.ProductName   else  '' end ProductName , case when  dtl.BonusQuantity is not null then CAST('Qty: ' as nvarchar(max))+ CAST(dtl.BonusQuantity as nvarchar(max)) when dtl.DiscountPercentage is not null then  CAST('Discount Percentage: ' as nvarchar(max))+ CAST(dtl.DiscountPercentage as nvarchar(max)) when dtl.QuantityDteail is not null then CAST('Amount: ' as nvarchar(max))+ CAST(dtl.QuantityDteail as nvarchar(max)) else '' end  Qty   from [dbo].[tbl_BonusCampaignNewDetail] dtl with (nolock)
	left join tbl_BonusOnType bt  with (nolock) on dtl.BonusTypeId=bt.BonusTypeId
	left join tblProduct pro  with (nolock) on dtl.BonusProductId=pro.ProductId
	 where CampaignMasterId= @id
      
    END


