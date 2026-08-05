-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_OPAPI_GETCamaignDetail]
	-- Add the parameters for the stored procedure here
@CampgainMasterId int
AS
BEGIN
	SELECT A.CampaignDetailId,
       --ISNULL(A.MinAmount,0)MinAmount,
       --ISNULL(A.MaxAmount,0)MaxAmount,
       ISNULL(A.DiscountPercentage,0)DiscountPercentage,
       ISNULL(A.DiscountAmount,0)DiscountAmount,
       ISNULL(A.ProductId,0)ProductId,
       ISNULL(A.Quantity,0)Quantity,
       ISNULL(A.BonusProductId,0)BonusProductId,
       ISNULL(A.BonusQuantity,0)BonusQuantity,
       B.TypeName,
       B.CodeName,
	   '' AS campaignName
FROM dbo.tbl_BonusCampaignNewDetail A
    INNER JOIN dbo.tbl_BonusOnType B
        ON B.BonusTypeId = A.BonusTypeId
WHERE A.CampaignMasterId = @CampgainMasterId
END
