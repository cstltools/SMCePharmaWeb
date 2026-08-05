
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_DoctorSpecialDay_All_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT SpecialDay,SpecialDayId FROM tblDoctorSpecialDay  with (nolock) WHERE IsActive = 1

END


