create PROCEDURE [dbo].[sp_webapi_GetDoctorVisitPlanMasterById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			
			SELECT   CASE WHEN mas.MonthValue=1 THEN 'January' WHEN mas.MonthValue=2 THEN 'February' WHEN mas.MonthValue=3 THEN 'March' WHEN mas.MonthValue=4 THEN 'April' WHEN mas.MonthValue=5 THEN 'May' WHEN mas.MonthValue=6 THEN 'June'  WHEN mas.MonthValue=7 THEN 'July' WHEN mas.MonthValue=8 THEN 'August' WHEN mas.MonthValue=9 THEN 'September'  WHEN mas.MonthValue=10 THEN 'October'  WHEN mas.MonthValue=11 THEN 'November'  WHEN mas.MonthValue=12 THEN 'December' ELSE '' END  [MonthName]    , * FROM dbo.tbl_DoctorTourPlanMaster mas WHERE mas.DocTPMaster = @id

END
