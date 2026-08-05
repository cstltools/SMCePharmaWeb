CREATE PROCEDURE [dbo].[sp_webapi_GetTourPlanDateById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			
		SELECT DISTINCT  DATEPART(d, mas.TourPlanDate) DayValue ,DATENAME(dw,mas.TourPlanDate) [DayName], FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate  FROM dbo.tbl_TourPlanInfo mas

WHERE mas.TPMaster=@id
END
