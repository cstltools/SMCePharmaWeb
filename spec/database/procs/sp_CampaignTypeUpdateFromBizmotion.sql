-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_CampaignTypeUpdateFromBizmotion] 

	
AS
BEGIN

	
DECLARE @CampaignType NVARCHAR(500)
DECLARE @IsCampaignProduct bit
DECLARE @ISGiftProduct bit
DECLARE @OrderDetailId int

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------

SELECT OrderDetailId,ISGiftProduct,IsCampaignProduct,tblOrderDetail.CampaignName FROM dbo.tblOrder 
INNER JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
WHERE 
--SubmissionDate BETWEEN '7/25/2020' AND GETDATE()
CONVERT(date, SubmissionDate) = DATEADD(day,-1,CONVERT(DATE, GETDATE()))


----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@OrderDetailId,@ISGiftProduct,@IsCampaignProduct,@CampaignType

WHILE @@FETCH_STATUS = 0
BEGIN

update tblInvoiceDetail set Campaign=@CampaignType 
 where OrderDetailsId=@OrderDetailId
update tblSubInvoiceDetail set Campaign=@CampaignType 
 where OrderDetailsId=@OrderDetailId

FETCH NEXT FROM @MyCursor
INTO 

@OrderDetailId,@ISGiftProduct,@IsCampaignProduct,@CampaignType

END
CLOSE @MyCursor
DEALLOCATE @MyCursor



END
