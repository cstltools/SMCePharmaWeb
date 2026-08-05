create PROCEDURE [dbo].[sp_Webapi_GetTourPlanForWorkedwithCopy] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@tDate date = NULL ,
@empId INT = NULL,
@morEve nvarchar(50) =null 
AS
BEGIN 
if(@morEve='Morning')
select *   FROM dbo.tbl_TourPlanInfo AS InnerA  with(nolock) where InnerA.Empinfoid=@empid and CONVERT(date,InnerA.TourPlanDate)=CONVERT(date,@tDate) and ( IsMorning=1 )

if(@morEve='Evening')
select *   FROM dbo.tbl_TourPlanInfo AS InnerA  with(nolock) where InnerA.Empinfoid=@empid and CONVERT(date,InnerA.TourPlanDate)=CONVERT(date,@tDate) and (  IsEvening= 1)

;END