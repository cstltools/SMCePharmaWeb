create PROCEDURE [dbo].[sp_Webapi_Get_OnOffButtonForCustomerChange_MS]
  

 as
 
BEGIN

	SELECT     '1'  btnCustMS FROM dbo.tblUserSettingPanel  with (nolock)    where CriteriaRemarks='MS' and GETDATE() between  FromDate and Todate

END