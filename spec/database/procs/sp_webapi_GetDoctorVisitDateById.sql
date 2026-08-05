CREATE PROCEDURE [dbo].[sp_webapi_GetDoctorVisitDateById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			
		SELECT DISTINCT     DATEPART(d, mas.TourPlanDate) DayValue ,DATENAME(dw,mas.TourPlanDate) [DayName], FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate  FROM dbo.tbl_DoctorTourPlanDetail mas
		--left join (select distinct convert(Date,mgd.TourPlanDate) TourPlanDate, STUFF( (SELECT CONCAT(',', mm.DoctorCode ,  '') FROM tblDoctorMaster mm (NOLOCK) INNER JOIN dbo.tbl_DoctorTourPlanDetail mgd ON mgd.DoctorId=mm.DoctorId WHERE mgd.DoctorId=mm.DoctorId ORDER BY mgd.DoctorId FOR XML PATH ('') ),1,1,'') AS DegreeName)tbl on tbl.TourPlanDate=convert(Date,mas.TourPlanDate)
		--left join tblDoctorMaster doc on doc.DoctorId=mas.DoctorId
		--left join tblStationType ty on ty.StationTypeId=mas.TourTypeId
		--left join tblMarket mr on mr.marketid=mas.marketid

WHERE mas.DocTPMaster=@id
END
