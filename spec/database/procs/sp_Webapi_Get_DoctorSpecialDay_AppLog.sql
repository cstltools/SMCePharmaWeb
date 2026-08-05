-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DoctorSpecialDay_AppLog]
	-- Add the parameters for the stored procedure here
	@doctorId INT 
AS
BEGIN
	 
	SELECT tblDoctorSpecialDayDetail.SpecialDayId  SpecialDayId , chm.SpecialDay  SpecialDay,
           FORMAT(tblDoctorSpecialDayDetail.SpecialDate, 'dd-MMM-yyyy') AS SpecialDate 
        
             FROM dbo.tblDoctorSpecialDayDetail
			 left join tblDoctorSpecialDay chm on chm.SpecialDayId=tblDoctorSpecialDayDetail.SpecialDayId

			  WHERE DoctorId = @doctorId  
END

