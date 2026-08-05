 


CREATE PROCEDURE [dbo].[sp_SAP_Up_SAP_ChallanConfirmByChalanId] ---SAP Invoice
  @ChalanId int

AS
BEGIN 
      update tblChalanInfo set SAP_Challan_ConfirmationSend=1 
	  where   ChalanId=@ChalanId


END
 





















 




