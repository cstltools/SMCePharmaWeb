

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Update_PromoEmployeeQty]
    
	@TourSetupEmployeeId int,
	@CountNo int =null ,
    @UpdateBy INT =null,
	@UpdateDate DATETIME = NULL

AS
BEGIN


UPDATE tblGroupWisePromoQty
   SET Qty = @CountNo, TransactionQTY = @CountNo
       
      ,UpdateBy = @UpdateBy
      ,UpdateDate = @UpdateDate
 WHERE  GWPromoQtyId = @TourSetupEmployeeId

	

END



