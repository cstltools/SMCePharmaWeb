CREATE PROCEDURE [dbo].[sp_webapi_GetTourPlanDetailById_new]
	-- Add the parameters for the stored procedure here
@id INT=null ,
@TourPlanDate DATE =NULL
AS
BEGIN
			--DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
		SELECT  distinct    isnull(  case when mas.IsMarketVisit=1 then 'Market Visit' + ' ('+case when mas.IsMorning=1 then 'Morning' else 'Evening' end+')' else 'Other Visit' end + ' ','') VisitType , isnull(STUFF( (SELECT  CONCAT( char(10) +   mm.CustomerCode +' : '+mm.CustomerName , '') FROM tblCustMaster mm (NOLOCK) INNER JOIN dbo.tblTPCustomerDetail mgd ON mgd.CustomerMasterId=mm.CustomerMasterId WHERE mgd.TourPlanId=mas.TourPlanId ORDER BY mgd.CustomerMasterId FOR XML PATH ('') ),1,1,''),'') as CustomerName, isnull(STUFF( (SELECT  CONCAT( char(10) +    mm.MarketName , '') FROM tblMarket mm (NOLOCK) INNER JOIN dbo.tblTPMarketDetail mgd ON mgd.MarketId=mm.MarketId WHERE mgd.TourPlanId=mas.TourPlanId ORDER BY mgd.MarketId FOR XML PATH ('') ),1,1,''),'') as OtherMarketName, mas.MarketId, mas.MarketName + isnull(' [Time: '+mas.Starttime+']','')  MarketName, mas.MarketNameEnd + isnull(' [Time: '+mas.Endtime+']','')  MarketNameEnd, FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate, mas.TPId,tp.TPName,  *  from  tbl_TourPlanInfo mas with (NOLOCK)
 
--left JOIN dbo.tblCustMaster cus ON cus.CustomerMasterId = mas.CustomerMasterId
left JOIN dbo.tbl_TourPlanPurpose tp  with (NOLOCK) ON tp.TPId = mas.TPId
WHERE mas.TPMaster=@id AND mas.TourPlanDate=@TourPlanDate
END


--,      mas.MarketId, mr.MarketName, FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate, mas.TPId,tp.TPName,  * FROM 