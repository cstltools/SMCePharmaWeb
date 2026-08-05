CREATE PROCEDURE [dbo].[sp_Webapi_GET_WeekofYear]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	
	
	SELECT WeekSettingId ,
           FiscalYearId ,
           WeekName ,
           Quaters ,
           CONVERT(NVARCHAR(50),FromDate,106)AS FromDate ,
           ISNULL(CONVERT(NVARCHAR(50),Todate,106),'')AS Todate 
		    FROM dbo.tblWeekSetting WHERE FiscalYearId = @id




END
