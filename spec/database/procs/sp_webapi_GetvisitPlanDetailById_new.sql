CREATE PROCEDURE [dbo].[sp_webapi_GetvisitPlanDetailById_new]
	-- Add the parameters for the stored procedure here
@id INT=null ,
@TourPlanDate DATE =NULL
AS
BEGIN
    SET NOCOUNT ON;
SELECT STUFF((
    SELECT ',' + CHAR(13) + CHAR(10) + mm.DoctorName_DV
    FROM dbo.tbl_DoctorTourPlanDetail mm WITH (NOLOCK)
   WHERE mm.DocTPMaster=@id AND CONVERT(Date,mm.TourPlanDate)=CONVERT(Date,@TourPlanDate)
    ORDER BY mm.Type_DV desc
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS DoctorName;

--select STUFF( (SELECT  CONCAT( char(10) +   mm.DoctorName_DV , '') FROM dbo.tbl_DoctorTourPlanDetail mm (NOLOCK)  WHERE mm.DocTPMaster=@id AND CONVERT(Date,mm.TourPlanDate)=CONVERT(Date,@TourPlanDate) ORDER BY mm.DoctorId FOR XML PATH ('') ),1,1,'') as DoctorName
			--DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
--		SELECT  doc.DoctorCode, doc.DoctorName  from  tbl_DoctorTourPlanDetail mas
--		left join tblDoctorMaster doc on doc.DoctorId=mas.DoctorId
 
 --WHERE mas.DocTPMaster=8 AND mas.TourPlanDate='02 Apr 2022'
END


--,      mas.MarketId, mr.MarketName, FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate, mas.TPId,tp.TPName,  * FROM 