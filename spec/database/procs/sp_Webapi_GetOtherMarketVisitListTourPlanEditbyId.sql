create PROCEDURE [dbo].[sp_Webapi_GetOtherMarketVisitListTourPlanEditbyId] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@tDate date = NULL ,
@TourPlanId INT = NULL 
AS
BEGIN 
 
select mr.MarketId , mr.MarketName   FROM tblTPMarketDetail

AS InnerA with(nolock)
inner join tblMarket  mr with(nolock) on mr.MarketId=InnerA.MarketId
 where InnerA.TourPlanId=@TourPlanId 
--and CONVERT(date,InnerA.TourPlanDate)=CONVERT(date,@tDate) 
 
;END