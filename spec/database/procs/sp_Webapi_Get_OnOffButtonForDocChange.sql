create PROCEDURE [dbo].[sp_Webapi_Get_OnOffButtonForDocChange]
  

 as
 
BEGIN

	SELECT   '1'  btnDocProvider FROM dbo.tblUserSettingPanel  with (nolock)    where CriteriaRemarks='DPT' and GETDATE() between  FromDate and Todate

END