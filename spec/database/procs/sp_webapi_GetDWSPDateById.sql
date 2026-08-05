
CREATE PROCEDURE [dbo].[sp_webapi_GetDWSPDateById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			
		SELECT    ISNULL(mas.CampaignAmount+mas.FCBAmount+mas.GeneralAmount,0) TargetAmount ,mas.CampaignAmount,mas.FCBAmount,mas.GeneralAmount,  DATEPART(d, mas.DWSPDate) DayValue ,DATENAME(dw,mas.DWSPDate) [DayName], FORMAT(mas.DWSPDate,'dd MMM yyyy') DWSPDate  FROM dbo.tbl_DWSPDetail mas

WHERE mas.DWSPMasterId=@id

order by CONVERT(Date, mas.DWSPDate) asc
END