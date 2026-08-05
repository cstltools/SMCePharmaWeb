-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DoctorSpecialDay] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT SpecialDayId,SpecialDay FROM dbo.tblDoctorSpecialDay WHERE IsActive = 1
		 



END

