
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_doctorCateList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT * FROM tblDoctorCategory WHERE IsActive = 1

END


