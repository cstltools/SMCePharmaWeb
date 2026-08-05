 


CREATE PROCEDURE [dbo].[sp_SAP_ChallanSendDetailByChalanId] ---SAP Invoice
  @ChalanId int

AS
BEGIN 
     select c.ChalanId, pro.SAP_Code product_code,  c.BatchNo  batch_no,
      c.Quantity   quantity,
       proU.UOMSAPCode  UoM, '' remarks from tblChalanDetail c 	 with (nolock)
	   left join tblProduct pro on c.ProductCode=pro.ProductCode
	   left join tblStockUOM proU on proU.StockUOMId=pro.StockUOMId
	 
	  where  c.ChalanId=@ChalanId


END























 




