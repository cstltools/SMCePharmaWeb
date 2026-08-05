-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorSpeciality_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

		SELECT * FROM tblDoctorSpeciality WHERE IsActive = 1

END


