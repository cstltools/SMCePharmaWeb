-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_DoctorSpecialDay_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

	SELECT	* FROM dbo.tblDoctorSpecialDay WHERE IsActive=1

END


