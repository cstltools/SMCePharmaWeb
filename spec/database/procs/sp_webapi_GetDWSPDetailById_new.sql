create PROCEDURE [dbo].[sp_webapi_GetDWSPDetailById_new]
	-- Add the parameters for the stored procedure here
@id INT=null ,
@DWSPDate DATE =NULL
AS
BEGIN
			--DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
		SELECT *  from  tbl_DWSPDetail mas

WHERE mas.DWSPMasterId=@id AND mas.DWSPDate=@DWSPDate
END


--,      mas.MarketId, mr.MarketName, FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate, mas.TPId,tp.TPName,  * FROM 