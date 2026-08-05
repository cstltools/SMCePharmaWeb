CREATE PROCEDURE [dbo].[sp_Get_BonusCampaignNewMasterList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='select distinct case when CustomerTypeIdNew='''' then CustomerType when CustomerTypeIdNew is null then CustomerType else CustomerTypeIdNew end CustomerType,   * from (
SELECT A.CampaignName, A.EntryDate, STUFF((
    SELECT '','' + CAST(ccT.CustomerType AS VARCHAR)
    FROM tbl_BonusCampaignDetailsCustType dtl
	left join tblCustomerType ccT on dtl.CustomerTypeId=ccT.CustomerTypeId
    WHERE CampgainMasterMapId in (select CampgainMasterMapId from tbl_BonusCampaignDetailsCustType  where  CampgainMasterId =a.CampgainMasterId)  
    FOR XML PATH('''')
), 1, 1, '''')  CustomerTypeIdNew, cam.Description TypeName, Chmist.CustomerType,  format(A.FromDate,''dd-MMM-yyyy hh:mm tt'')  FromDate ,  format(A.Todate,''dd-MMM-yyyy hh:mm tt'') Todate,A.CampgainMasterId from dbo.tbl_BonusCampaignNewMaster A WITH (NOLOCK)
 LEFT JOIN dbo.tbl_CampaignType cam  WITH (NOLOCK) ON cam.CampainTypeId = A.CampainTypeId
 LEFT JOIN dbo.tblCustomerType Chmist  WITH (NOLOCK) ON Chmist.CustomerTypeId = A.CustomerTypeId
  where a.CampgainMasterId is not null  
 '+@Parm +'   )tbl  order by  EntryDate   desc '


EXEC sp_executesql @Q
	
END