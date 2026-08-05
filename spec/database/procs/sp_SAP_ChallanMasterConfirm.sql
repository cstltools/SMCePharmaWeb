CREATE PROCEDURE [dbo].[sp_SAP_ChallanMasterConfirm] ---SAP Invoice
  

AS
BEGIN 
     select IsDeliver, c.ChalanId, c.ChalanNo challan_code, FORMAT(c.ChalanDate,'dd.MM.yyyy')  challan_date,
      comF.SAP_Code   from_Plant_code,
       comT.SAP_Code  to_Plant_code from tblChalanInfo c 	 with (nolock)
		 left join tblCompanyUnit comF 	 with (nolock) on  comF.ComUnitCode=c.FromComUnitCode
		 left join tblCompanyUnit comT 	 with (nolock) on  comT.ComUnitCode=c.ToComUnitCode
	  where ISNULL(SAP_ChallanSend,0)=1 and  ISNULL(IsDeliver,'False')='True' and   ISNULL(SAP_Challan_ConfirmationSend,0)=0


END



























 




