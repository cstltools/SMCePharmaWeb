
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_Degree_All_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT * FROM tblDoctorDegree WHERE IsActive = 1

END



