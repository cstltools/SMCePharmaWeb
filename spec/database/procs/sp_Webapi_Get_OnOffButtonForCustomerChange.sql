create PROCEDURE [dbo].[sp_Webapi_Get_OnOffButtonForCustomerChange]
  

 as
 
BEGIN

	SELECT   '1'  btnCustProvider FROM dbo.tblUserSettingPanel  with (nolock)    where CriteriaRemarks='PT' and GETDATE() between  FromDate and Todate

END