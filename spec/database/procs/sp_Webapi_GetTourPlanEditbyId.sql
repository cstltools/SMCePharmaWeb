create PROCEDURE [dbo].[sp_Webapi_GetTourPlanEditbyId] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@tDate date = NULL ,
@TourPlanId INT = NULL 
AS
BEGIN 
 
select *   FROM dbo.tbl_TourPlanInfo AS InnerA  with(nolock) where InnerA.TourPlanId=@TourPlanId 
--and CONVERT(date,InnerA.TourPlanDate)=CONVERT(date,@tDate) 
 
;END