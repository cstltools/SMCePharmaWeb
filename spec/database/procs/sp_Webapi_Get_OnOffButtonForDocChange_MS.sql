create PROCEDURE [dbo].[sp_Webapi_Get_OnOffButtonForDocChange_MS]
  

 as
 
BEGIN

	SELECT     '1'  btnDocMS FROM dbo.tblUserSettingPanel  with (nolock)    where CriteriaRemarks='DocMS' and GETDATE() between  FromDate and Todate

END