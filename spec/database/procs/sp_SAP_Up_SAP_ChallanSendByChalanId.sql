 


create PROCEDURE [dbo].[sp_SAP_Up_SAP_ChallanSendByChalanId] ---SAP Invoice
  @ChalanId int

AS
BEGIN 
      update tblChalanInfo set SAP_ChallanSend=1 
	  where   ChalanId=@ChalanId


END























 




